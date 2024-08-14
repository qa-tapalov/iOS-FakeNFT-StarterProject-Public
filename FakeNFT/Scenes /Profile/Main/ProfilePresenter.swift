//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit
import Kingfisher

protocol ProfilePresenterProtocol: AnyObject {
    func setup()
    func updateProfileData()
    func editProfile()
    func showWebsite(URL: URL)
}

final class ProfilePresenter {
    // MARK: - Properties

    typealias Cell = ProfileScreenModel.TableData.Cell

    private weak var view: ProfileViewProtocol?
    private var profile: ProfileModel?
    private var router: ProfileRouterProtocol?
    private var profileService: ProfileServiceProtocol?

    // MARK: - Init

    init(view: ProfileViewProtocol, router: ProfileRouterProtocol?, profileService: ProfileServiceProtocol?) {
        self.view = view
        self.router = router
        self.profileService = profileService
    }

    // MARK: - Private methods

    private func loadProfile() {
        UIBlockingProgressHUD.show()
        profileService?.getProfile(profileId: "1", completion: { [weak self] result in
            guard let self = self else { return }

            UIBlockingProgressHUD.dismiss()
            switch result {
            case let .success(profileResponse):
                self.profile = ProfileModel(
                    name: profileResponse.name,
                    avatar: UIImage(),
                    description: profileResponse.description,
                    website: profileResponse.website,
                    nfts: profileResponse.nfts,
                    likes: profileResponse.likes,
                    id: profileResponse.id
                )
                self.loadImage(from: profileResponse.avatar) { [weak self] result in
                    switch result {
                    case let .success(avatarImage):
                        self?.profile?.avatar = avatarImage
                        DispatchQueue.main.async {
                            self?.render()
                        }
                    case let .failure(error):
                        self?.view?.showErrorAlert(message: "Не удалось загрузить изображение: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self?.render()
                        }
                    }
                }

            case let .failure(error):
                view?.showErrorAlert(message: "Не удалось загрузить профиль: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.render()
                }
            }
        })
    }

    private func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case let .success(value):
                completion(.success(value.image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func render(reloadTableData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadTableData)
    }

    private func buildScreenModel() -> ProfileScreenModel {
        ProfileScreenModel(
            userName: profile?.name ?? "",
            userImage: profile?.avatar ?? UIImage(),
            userAbout: profile?.description ?? "",
            websiteUrlString: profile?.website ?? "",
            tableData: ProfileScreenModel.TableData(sections: [
                .simple(cells: [
                    buildMyNFTCell(),
                    buildFavouriteNFTCell(),
                    buildAboutDeveloperCell()
                ])
            ])
        )
    }

    private func buildMyNFTCell() -> Cell {
        .detail(ProfileDetailCellModel(
            title: "Мои NFT",
            subtitle: "(\(profile?.nfts.count ?? 0))",
            action: { [weak self] in
                guard let self else { return }
                self.showMyNFTScreen()
            }))
    }

    private func buildFavouriteNFTCell() -> Cell {
        .detail(ProfileDetailCellModel(
            title: "Избранные NFT",
            subtitle: "(\(profile?.likes.count ?? 0))",
            action: { [weak self] in
                guard let self else { return }
                self.showFavouritesNFTScreen()
            }))
    }

    private func buildAboutDeveloperCell() -> Cell {
        .detail(ProfileDetailCellModel(
            title: "О разработчике",
            subtitle: "",
            action: {
            }))
    }

    private func showMyNFTScreen() {
        router?.showMyNFTScreen()
    }

    private func showFavouritesNFTScreen() {
        router?.showFavouritesNFTScreen()
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func setup() {
        render()
    }

    func updateProfileData() {
        loadProfile()
    }

    func editProfile() {
        guard let profile = profile else { return }
        router?.showEditProfile(profile: profile, onDismiss: { [weak self] in
            guard let self else { return }
            self.loadProfile()
        })
    }

    func showWebsite(URL: URL) {
        router?.showWebView(URL: URL)
    }
}
