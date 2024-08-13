//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 13/08/2024.
//

import Foundation

typealias ProfileCompletion = (Result<ProfileResultModel, Error>) -> Void

protocol ProfileServiceProtocol: AnyObject {
    func getProfile(profileId: String, completion: @escaping ProfileCompletion)
    func updateProfile(profile: ProfileModel, completion: @escaping ProfileCompletion)
}

final class ProfileService: ProfileServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Get profile data
    func getProfile(profileId: String, completion: @escaping ProfileCompletion) {
        let request = ProfileRequest(id: profileId, dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: ProfileResultModel.self) { result in
            switch result {
            case let .success(profile):
                completion(.success(profile))
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Update profile data
    func updateProfile(profile: ProfileModel, completion: @escaping ProfileCompletion) {
        let request = UpdateProfileRequest(
            profile: UpdateProfileRequestModel(
                name: profile.name,
                description: profile.description,
                website: profile.website,
                likes: profile.likes)
        )

        networkClient.send(request: request, type: ProfileResultModel.self) { result in
            switch result {
            case let .success(profile):
                completion(.success(profile))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
