import Foundation

final class StatisticsService {
    
    // MARK: - Properties
    
    static let shared = StatisticsService()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Users fetching
    
    func fetchUsers(completion: @escaping (Result<[StatisticsUsersModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = usersRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTask(for: request) { [weak self] (response: Result<[StatisticsUserModelResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let result = body.map { self.convertToUserModel(userResult: $0) }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                print("[StatisticsService]: \(error.localizedDescription) \(request)")
            }
        }
    }
    
    private func usersRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/users",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func convertToUserModel(userResult: StatisticsUserModelResult) -> StatisticsUsersModel {
        let userModel = StatisticsUsersModel(
            name: userResult.name,
            avatar: userResult.avatar,
            description: userResult.description,
            website: userResult.website,
            nfts: userResult.nfts,
            rating: userResult.rating,
            id: userResult.id
        )
        
        return userModel
    }
    
    // MARK: - NFTs fetching
    
    func fetchNFTs(completion: @escaping (Result<[StatisticsNFTModel], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = nftRequest()  else {
            assertionFailure("Invalid users request")
            return
        }
        
        URLSession.shared.objectTask(for: request) { [weak self] (response: Result<[StatisticsNFTModelResult], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let body):
                let result = body.map { self.convertToNFTModel(nftResult: $0) }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
                print("[StatisticsService]: \(error.localizedDescription) \(request)")
            }
        }
    }
    
    private func nftRequest() -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/api/v1/nft",
            httpMethod: "GET",
            baseURL: URL(string: RequestConstants.baseURL)
        )
        
        request?.setValue("application/json", forHTTPHeaderField: "Accept")
        request?.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
    
    private func convertToNFTModel(nftResult: StatisticsNFTModelResult) -> StatisticsNFTModel {
        let nftModel = StatisticsNFTModel(
            createdAt: nftResult.createdAt,
            name: nftResult.name,
            images: nftResult.images,
            rating: nftResult.rating,
            description: nftResult.description,
            price: nftResult.price,
            author: nftResult.author,
            id: nftResult.id
        )
        
        return nftModel
    }
 }
