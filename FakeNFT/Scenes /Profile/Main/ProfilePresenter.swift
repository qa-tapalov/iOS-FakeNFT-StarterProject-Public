//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import Foundation

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
    private var imageLoader: ImageLoaderProtocol?

    // MARK: - Init

    init(view: ProfileViewProtocol, router: ProfileRouterProtocol?, profileService: ProfileServiceProtocol?, imageLoader: ImageLoaderProtocol?) {
        self.view = view
        self.router = router
        self.profileService = profileService
        self.imageLoader = imageLoader
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
                    avatar: ImageWrapper(data: Data()),
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

    private func loadImage(from urlString: String, completion: @escaping (Result<ImageWrapper, Error>) -> Void) {
        imageLoader?.loadImage(from: urlString, completion: completion)
    }

    private func render(reloadTableData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadTableData: reloadTableData)
    }

    private func buildScreenModel() -> ProfileScreenModel {
        ProfileScreenModel(
            userName: profile?.name ?? "",
            userImage: profile?.avatar ?? ImageWrapper(data: Data()),
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
        guard let profile = profile else { return }
        router?.showMyNFTScreen(profile: profile)
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
