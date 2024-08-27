import Foundation

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(result))
                    }
                    catch {
                        print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                        fulfillCompletion(.failure(NetworkError.serviceError))
                    }
                } else {
                    print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[objectTask]: \(error)")
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[objectTask(for:)]: \(String(describing: error?.localizedDescription))")
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
    }
}
