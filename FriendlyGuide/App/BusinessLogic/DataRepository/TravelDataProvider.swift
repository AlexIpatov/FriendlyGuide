//
//  TravelDataRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation
import Kingfisher

class TravelDataProvider{
    
    let requestFactory: RequestFactory
    
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
    
    
    
    
    
}

extension TravelDataProvider: DataProvider {
    func getData(cityID: Int) -> [Event] {
        <#code#>
    }
    
    
}

