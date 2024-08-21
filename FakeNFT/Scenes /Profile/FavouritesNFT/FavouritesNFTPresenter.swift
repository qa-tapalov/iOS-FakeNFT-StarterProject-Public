//
//  FavouritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 20/08/2024.
//

import Foundation

protocol FavouritesNFTPresenterProtocol: AnyObject {
    func setup()
    var favouriteNFTIds: [String] { get }
}

final class FavouritesNFTPresenter {

    // MARK: - Properties

    typealias Cell = FavoritesNFTScreenModel.CollectionData.Cell
    typealias Section = FavoritesNFTScreenModel.CollectionData.Section

    private weak var view: FavouritesNFTViewProtocol?
    private var nftService: NFTServiceProtocol?
    private var profileService: ProfileServiceProtocol?
    private var profile: ProfileModel?
    private var favouriteNFTs: [NFTModel] = [] {
        didSet {
            render(reloadData: true)
        }
    }

    private (set) var favouriteNFTIds: [String] = [] {
        didSet {
            updateNFTModel()
            render(reloadData: true)
        }
    }

    // MARK: - Init

    init(
        view: FavouritesNFTViewProtocol?,
        nftService: NFTServiceProtocol,
        profileService: ProfileServiceProtocol,
        profile: ProfileModel
    ) {
        self.view = view
        self.nftService = nftService
        self.profileService = profileService
        self.profile = profile
        self.favouriteNFTIds = profile.likes

        loadNFTs()
    }

    // MARK: - Private methods

    private func render(reloadData: Bool = true) {
        view?.display(data: buildScreenModel(), reloadData: reloadData)
    }

    private func updateNFTModel() {
        favouriteNFTs = favouriteNFTs.map { nft in
            var updatedModel = nft
            updatedModel.isLiked = favouriteNFTIds.contains(nft.id)
            return updatedModel
        }
    }

    private func buildScreenModel() -> FavoritesNFTScreenModel {
        FavoritesNFTScreenModel(
            title: "Избранные NFT",
            collectionData: .init(sections: buildNFTsSection())
        )
    }

    private func buildNFTsSection() -> [Section] {
        let cells: [Cell] = favouriteNFTs.map { nft in
                .NFTCell(NFTCollectionViewCellModel(
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
        UIBlockingProgressHUD.show()
        if isLiked {
            if !favouriteNFTIds.contains(nftId) {
                favouriteNFTIds.append(nftId)
            }
        } else {
            favouriteNFTIds.removeAll { $0 == nftId }
            favouriteNFTs.removeAll { $0.id == nftId }
        }
        profile?.likes = favouriteNFTIds
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
            likes: favouriteNFTIds,
            id: profile.id)
        ) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
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

        for id in favouriteNFTIds {
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
                            isLiked: true
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
            self?.favouriteNFTs.append(nftModel)
        }
    }
}

// MARK: - FavouritesNFTPresenterProtocol

extension FavouritesNFTPresenter: FavouritesNFTPresenterProtocol {
    func setup() {
        render()
    }
}
