//
//  UserController.swift
//  App
//
//  Created by Ivan Sapozhnik on 07.02.18.
//

import Foundation
import Vapor
import HTTP

final class UserViewController: UserController {
    struct Keys {
        static let register = "register"
        static let login = "login"
    }
    
    func register(_ req: Request) throws -> ResponseRepresentable  {
        return try drop.view.make(Keys.register)
    }
    
    func login(_ req: Request) throws -> ResponseRepresentable  {
        return try drop.view.make(Keys.login)
    }
}
