//
//  MVCDisignable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol MVCDisignable {
    associatedtype Model
    associatedtype View
    
    var customView: View { get }
    var model: Model { get }
    
    init(view: View, model: Model)
}
