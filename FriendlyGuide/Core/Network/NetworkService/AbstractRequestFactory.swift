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
              //  self.log(data: data, response: response as? HTTPURLResponse, error: error)
                       if error != nil {
                           completion(.failure(NetworkingError.invalidRequest))
                       }
                       guard let data = data else {
                           completion(.failure(NetworkingError.badData))
                           return
                       }
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
                                 timeoutInterval: 20.0)
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

// MARK: - Debug methods
extension AbstractRequestFactory {
    
    fileprivate func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
    }

    fileprivate func log(data: Data?, response: HTTPURLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        print(responseLog)
    }
    
}
