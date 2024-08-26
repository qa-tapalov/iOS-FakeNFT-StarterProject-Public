import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: StatisticsNft)
    func getNft(with id: String) -> StatisticsNft?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: StatisticsNft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: StatisticsNft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> StatisticsNft? {
        syncQueue.sync {
            storage[id]
        }
    }
}
