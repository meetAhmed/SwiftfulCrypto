//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class NetworkingManager {
    enum NetworkingErrors: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url): return "Bad response from URL: \(url)"
            case .unknown: return "Unknown error occured."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingErrors.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            print("CoinDataService: error: \(error.localizedDescription)")
        case .finished:
            break
        }
    }
}
