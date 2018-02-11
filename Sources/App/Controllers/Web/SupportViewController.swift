//
//  SupportViewController.swift
//  App
//
//  Created by Ivan Sapozhnik on 11.02.18.
//

import Foundation
import Vapor
import HTTP

final class SupportViewController {
    
    struct Keys {
        static let support = "support"
    }
    
    let drop: Droplet
    
    init(_ droplet: Droplet) {
        self.drop = droplet
    }
    
    func support(_ req: Request) throws -> ResponseRepresentable  {
        return try drop.view.make(Keys.support)
    }
}
