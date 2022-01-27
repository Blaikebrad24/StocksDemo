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
        static let apiKey = "c7pcs9iad3ielbt6jrtg"
        static let sandboxApiKey = "sandbox_c7pcs9iad3ielbt6jru0"
        static let baseURL = "https://finnhub.io/api/v1/"
    }
    
    // ~Mark PUBLIC
    public func search(query: String, completion: @escaping (Result<[String], Error>) -> Void)
    {
        guard let url = url(for: .search, queryParams: ["q":query])
        else{
            return
        }
        
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
    
    /*
     Private Func - URL
     Purpose - creates a URL string used for API
     Parameters - endPoint of type enum Endpoint,
                  queryParams Dictionary(String)
     
     */
    private func url(for endpoint: Endpoint, queryParams: [String : String] = [:]) -> URL? {
        var urlString = Constants.baseURL + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        // add any parameters to URL
        for (name, value) in queryParams{
            queryItems.append(.init(name: name, value: value))
        }
        // add Token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        urlString += "?" + queryItems.map{"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
        print("\n\(urlString)\n")
        return URL(string: urlString)
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
