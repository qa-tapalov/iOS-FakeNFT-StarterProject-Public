//
//  CartNetwork.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 12.08.2024.
//

import Foundation

final class CartNetworkService {
    static var shared = CartNetworkService()
    private init() {}
    
    func fetchOrder(completion: @escaping (Result<OrderModel, Error>) -> Void){
        
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.objectsTask(for: request) { (result: Result<OrderModel, Error>) in
            
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getNftById(id: String, completion: @escaping (Result<NftNetworkModel, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.objectsTask(for: request) { (result: Result<NftNetworkModel, Error> ) in
            
            switch result {
            case .success(let nftModel):
                completion(.success(nftModel))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        task.resume()
    }
    
    func deleteNftById(id: [String], completion: @escaping (Result<OrderModel, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        if !id.isEmpty {
            let id = "nfts=\(id.joined(separator: ","))"
            guard let bodyData = id.data(using: .utf8) else { return }
            request.httpBody = bodyData
        }
        
        let task = URLSession.shared.objectsTask(for: request) { (result: Result<OrderModel, Error> ) in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        task.resume()
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void){
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/currencies?") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.objectsTask(for: request) { (result: Result<[CurrencyModel], Error>) in
            
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func payOrder(id: String, completion: @escaping (Result<OrderSuccessModel, Error>) -> Void){
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let task = URLSession.shared.objectsTask(for: request) { (result: Result<OrderSuccessModel, Error>) in
            
            switch result {
            case .success(let orderSuccessResponce):
                completion(.success(orderSuccessResponce))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case serviceError
}

extension URLSession {
    
    func objectsTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                }
            case .failure(let error):
                completion(.failure(error))
                print("[dataTask]: DataError - \(error.localizedDescription)")
                
            }
        }
        return task
    }
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[dataTask]: NetworkError - status code: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[dataTask]: NetworkError - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[dataTask]: NetworkError - \(String(describing: error?.localizedDescription))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
