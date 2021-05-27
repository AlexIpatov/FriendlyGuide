//
//  ErrorParser.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}
