//
//  AbstractRequestFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

protocol AbstractRequestFactory: AnyObject {
    associatedtype EndPoint: EndPointType
    var sessionManager      : URLSession { get }
    var encoder             : ParameterEncoder { get }
    func request(withCompletion completion: @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void)
}

extension AbstractRequestFactory {
    
    func request(_ route: EndPoint,
                 withCompletion completion: @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {
        do {
            let request = try self.buildRequest(from: route)
            let task = sessionManager.dataTask(with: request, completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                       if error != nil {
                           completion(.failure(NetworkingError.invalidRequest))
                       }
                       guard let data = data else {
                           completion(.failure(NetworkingError.badData))
                           return
                       }
                //###################################
                let json = try? JSONSerialization.jsonObject(with: data,
                                                             options: JSONSerialization
                                                                .ReadingOptions
                                                                .allowFragments)
                print(json ?? "enable to parse data")
                //###################################
                do {
                    let value = try self.decode(data)
                           completion(.success(value))
                       } catch {
                           completion(.failure(NetworkingError.parsingError))
                       }
                   })
                   task.resume()
        } catch {
            completion(.failure(NetworkingError.invalidRequest))
        }
        }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        let url = url(from: route)
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            try encoder.encode(urlRequest: &request, with: route.parameters)
        } catch {
            throw NetworkingError.encodingFailed
        }
        return request
    }
    
    fileprivate func url(from route: EndPoint) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = route.host.baseURL
        components.path = route.path.path
        components.queryItems = route.queryItems
        return components.url!
    }
    
    fileprivate func decode(_ data: Data) throws -> EndPoint.ModelType {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let value = try decoder.decode(EndPoint.ModelType.self, from: data)
        return value
    }
    
    }
