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
        static let day: TimeInterval = 3600 * 24
    }
    
    // MARK: - PUBLIC
    
    /*
     Function - Public Search
     Purpose -
     Parameters - query String type, completion type Result<Success, Error>
     
     Returns - completion returns either a result with type SearchResponse(Codable object)
               or type Error
     */
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void)
    {
        // configure for spaces in search
        guard let editedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return
        }
        request(url: url(for: .search, queryParams: ["q":editedQuery]), expecting: SearchResponse.self, completion: completion)
        
    }
    
    
    /*
     *
     *
     *
     *
     */
    
    public func news(for type: TopStoriesNewsController.`Type`,
                     completion: @escaping (Result<[NewStoriesModel], Error>) -> Void)
    {
        // create relevant url -> enum Endpoint
        switch type{
        case .topStories:
            request(
                url: url(
                    for: .topStores,
                       queryParams: ["category": "general"]
                ),
                expecting: [NewStoriesModel].self,
                completion: completion)
            
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 3))
            request(
                url: url(
                    for: .companyNews,
                       queryParams: ["symbol": symbol,
                                     "from": DateFormatter.newsFormatter.string(from: oneMonthBack),
                                     "to": DateFormatter.newsFormatter.string(from: today)
                                    ]
                ),
                expecting: [NewStoriesModel].self,
                completion: completion)
        }
        
        
    }
    
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse,Error>) -> Void)
    {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
   
        request(url: url(
            for: .marketData,
            queryParams: [
                "symbol" : symbol,
                "resolution" : "1",
                "from":"\(Int(prior.timeIntervalSince1970))",
                "to": "\(Int(today.timeIntervalSince1970))"]),
                expecting: MarketDataResponse.self,
                completion: completion)
        
        
    }
    
    
    // MARK: - PRIVATE
    private init()
    {
        
    }
    


    
    private enum Endpoint : String {
        case search
        case topStores = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
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
//        print("\n\(urlString)\n")
        return URL(string: urlString)
    }
    
    //generic way to make api calls
    
    /*
     *Function - request
     *@params - url , Generic type, completion (closure returns a Generic type or Error)
     *
     * summary - 
     *
     *@returns - N/A void method
     */
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
