//
//  FeaturesViewController.swift
//  App
//
//  Created by Ivan Sapozhnik on 11.02.18.
//

import Foundation
import Vapor
import HTTP

final class FeaturesViewController {
    
    struct Keys {
        static let features = "features"
    }
    
    let drop: Droplet
    
    init(_ droplet: Droplet) {
        self.drop = droplet
    }
    
    func features(_ req: Request) throws -> ResponseRepresentable  {
        return try drop.view.make(Keys.features)
    }
}
