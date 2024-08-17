//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 17/08/2024.
//

import Foundation

protocol MyNFTPresenterProtocol: AnyObject {
    func setup()
    func sortByPrice()
    func sortByRating()
    func sortByName()
    func loadSortOrder() -> String
    var nftIds: [String] { get }
}

final class MyNFTPresenter {

    // MARK: - Properties

    private weak var view: MyNFTViewProtocol?
    private var nftService: NFTServiceProtocol?
    private var profileService: ProfileServiceProtocol?
    private var profile: ProfileModel?
    private (set) var nftIds: [String]

    private let sortOrderKey = "MyNFTSortOrderKey"

    private var nfts: [NFTModel] = [] {
        didSet {
            render(reloadData: true)
        }
    }

    private var likedNFTs: [String] = [] {
        didSet {
            updateNFTModel()
            render(reloadData: true)
        }
    }

    // MARK: - Init

    init(
        view: MyNFTViewProtocol,
        nftService: NFTServiceProtocol,
        profileService: ProfileServiceProtocol,
        profile: ProfileModel
    ) {
        self.view = view
        self.nftService = nftService
        self.profileService = profileService
        self.profile = profile
        self.nftIds = profile.nfts
        self.likedNFTs = profile.likes
        loadNFTs()
    }

    // MARK: - Private methods

    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadData: reloadData)
    }

    private func buildScreenModel() -> MyNFTScreenModel {
        MyNFTScreenModel(
            title: "Мои NFT",
            tableData: .init(sections: buildNFTsSection())
        )
    }

    private func updateNFTModel() {
        nfts = nfts.map { nft in
            var updatedModel = nft
            updatedModel.isLiked = likedNFTs.contains(nft.id)
            return updatedModel
        }
    }

    private func buildNFTsSection() -> [MyNFTScreenModel.TableData.Section] {
        let cells: [MyNFTScreenModel.TableData.Cell] = nfts.map { nft in
            .NFTCell(NFTTableViewCellModel(
                image: nft.image,
                name: nft.name,
                authorName: nft.authorName,
                price: String("\(nft.price)"),
                rating: nft.rating,
                isLiked: nft.isLiked,
                onLikeAction: { [weak self] isLiked in
                    guard let self = self else { return }
                    self.handleLikeAction(isLiked: isLiked, for: nft.id)
                }
            ))
        }
        return [.simple(cells: cells)]
    }

    private func handleLikeAction(isLiked: Bool, for nftId: String) {
        if isLiked {
            if !likedNFTs.contains(nftId) {
                likedNFTs.append(nftId)
            }
        } else {
            likedNFTs.removeAll { $0 == nftId }
        }
        profile?.likes = likedNFTs
        updateProfile()
    }

    private func updateProfile() {
        guard let profile = profile else { return }
        profileService?.updateProfile(profile: ProfileModel(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: likedNFTs,
            id: profile.id)
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.render()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func loadNFTs() {
        UIBlockingProgressHUD.show()

        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)

        for id in nftIds {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) { [weak self] in
                guard let self = self else { return }

                self.nftService?.getNFT(id: id) { result in
                    defer { dispatchGroup.leave() }
                    switch result {
                    case .success(let nft):
                        let nftModel = NFTModel(
                            name: nft.name,
                            rating: nft.rating,
                            authorName: nft.author,
                            price: nft.price,
                            image: nft.images.first ?? "",
                            id: nft.id,
                            isLiked: self.likedNFTs.contains(nft.id)
                        )
                        self.appendNFTModel(nftModel)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func appendNFTModel(_ nftModel: NFTModel) {
        DispatchQueue.main.async { [weak self] in
            self?.nfts.append(nftModel)
        }
    }

    private func saveSortOrder(_ order: String) {
        UserDefaults.standard.set(order, forKey: sortOrderKey)
    }

}

// MARK: - MyNFTPresenterProtocol

extension MyNFTPresenter: MyNFTPresenterProtocol {
    func loadSortOrder() -> String {
        return UserDefaults.standard.string(forKey: sortOrderKey) ?? "rating"
    }
    func sortByPrice() {
        nfts.sort(by: { $0.price < $1.price })
        saveSortOrder("price")
        render()
    }

    func sortByRating() {
        nfts.sort(by: { $0.rating < $1.rating })
        saveSortOrder("rating")
        render()
    }

    func sortByName() {
        nfts.sort(by: { $0.name < $1.name})
        saveSortOrder("name")
        render()
    }

    func setup() {

        let sortOrder = loadSortOrder()

        switch sortOrder {
        case "price":
            sortByPrice()
        case "name":
            sortByName()
        default:
            sortByRating()
        }
        render()
    }
}
