//
//  GetCityNames.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

class GetCityNames {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetCityNames: AbstractRequestFactory {
    typealias EndPoint = CityNamesResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetCityNames: GetCityNamesFactory {
    func getCityNames(completionHandler: @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {
        let route = CityNamesResource()
        request(route, withCompletion: completionHandler)
    }

}

//let rf = RequestFactory()
//        let gn = rf.makeGetCityNameFactory()
//        gn.getCityNames { response in
//            switch response {
//            case .success(let cityNames):
//                cityNames.forEach { print($0.name)}
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
