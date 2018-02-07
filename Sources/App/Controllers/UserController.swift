//
//  UserController.swift
//  App
//
//  Created by Ivan Sapozhnik on 07.02.18.
//

import Foundation
import Vapor
import HTTP

final class UserController {
    struct Keys {
        static let email = "email"
        static let password = "password"
        static let name = "name"
    }
    
    let drop: Droplet
    
    init(_ droplet: Droplet) {
        self.drop = droplet
    }
    
    func test(_ req: Request) throws -> ResponseRepresentable  {
        guard
            let password = req.formURLEncoded?[Keys.password]?.string, !password.isEmpty,
            let email = req.formURLEncoded?[Keys.email]?.string, !email.isEmpty else {
                return Response(status: .badRequest)
        }
        
        return Response(status: .ok)
    }
    
    func loginUser(_ req: Request) throws -> ResponseRepresentable  {
        guard
            let password = req.formURLEncoded?[Keys.password]?.string, !password.isEmpty,
            let email = req.formURLEncoded?[Keys.email]?.string, !email.isEmpty else {
                return Response(status: .badRequest)
        }
        
        guard let user = try User.makeQuery().filter(Keys.email, email).first() else {
            throw Abort(.badRequest, reason: "A user with such email not found.")
        }
        
        guard password == user.password else {
            throw Abort(.badRequest, reason: "Incorrect user password")
        }
        
        let token = try Token.generate(for: user)
        try token.save()
        return token
    }
    
    func createUser(_ req: Request) throws -> ResponseRepresentable  {
        guard let password = req.formURLEncoded?[Keys.password]?.string, !password.isEmpty else {
            throw Abort(.badRequest, reason: "Password is missing!")
        }
        guard let name = req.formURLEncoded?[Keys.name]?.string, !name.isEmpty else {
            throw Abort(.badRequest, reason: "Name is missing!")
        }
        guard let email = req.formURLEncoded?[Keys.email]?.string, !email.isEmpty else {
            throw Abort(.badRequest, reason: "Email is missing!")
        }
        
        let user = User(name: name, email: email, password: password)
        
        guard try User.makeQuery().filter(Keys.email, user.email).first() == nil else {
            throw Abort(.badRequest, reason: "A user with that email already exists.")
        }
        user.password = try drop.hash.make(password.makeBytes()).makeString()
        try user.save()
        return user
    }
    
    func users(_ req: Request) throws -> ResponseRepresentable {
        return try User.all().makeJSON()
    }
}
