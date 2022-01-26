//
//  ApiManager.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/21/22.
//

/*
 API Manager - data logistics to and from App
 
 API Manager final class so it cannot be inherited
 
 
 */
import Foundation

final class APIManager {
    
    static let shared = APIManager() // access it App globally
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseURL = ""
    }
    private init()
    {
        
    }
    
    private enum Endpoint : String {
        case search
    }
    
    private enum APIError: Error {
        case noDataReceived
        case invalidUrl
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String : String] = [:]) -> URL? {
        
        return nil
    }
    
    //generic way to make api calls
    
    private func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping(Result<T, Error>) -> Void)
    {
        // variety of network calls to get data from Internet
        guard let url = url else{
            // invalid url
            completion(.failure(APIError.invalidUrl))
            return
        }
        //continue
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            // make sure data is not nil and error = nil
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }else{
                    completion(.failure(APIError.noDataReceived))
                }
                return
            }
            // try to decode data to given type
            do{
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
