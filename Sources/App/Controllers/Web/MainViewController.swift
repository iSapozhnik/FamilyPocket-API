//
//  MainViewController.swift
//  App
//
//  Created by Ivan Sapozhnik on 07.02.18.
//

import Foundation
import Vapor
import HTTP
//
//drop.get("tests") { request in
//    guard let baseUrl = request.baseUrl else { throw Abort.badRequest }
//    let todosUrl = baseUrl + "todos"
//    return Response(redirect: "http://todobackend.com/specs/index.html?\(todosUrl)")
//}
extension Request {
    var baseUrl: String? {
        guard let host = headers["Host"]?.finished(with: "/") else { return nil }
        return "\(uri.scheme)://\(host)"
    }
}

final class MainViewController {
    struct Keys {
        static let email = "email"
        static let password = "password"
        static let name = "name"
    }
    
    let drop: Droplet
    
    init(_ droplet: Droplet) {
        self.drop = droplet
    }
    
    func index(_ req: Request) throws -> ResponseRepresentable  {
//        do {
//            let user = try req.user()
//            return user.name
//        } catch {
//            guard let baseUrl = req.baseUrl else { throw Abort.badRequest }
//            let loginUrl = baseUrl + "login"
//            return Response(redirect: loginUrl)
//        }
        return try drop.view.make("welcome")
//        guard let baseUrl = req.baseUrl else { throw Abort.badRequest }
//        let loginUrl = baseUrl + "login"
//        return Response(redirect: loginUrl)
    }
}
