//
//  UserRoutes.swift
//  App
//
//  Created by Ivan Sapozhnik on 07.02.18.
//

import Foundation

final class UserRoutes {
    struct Endpoints {
        static let register = "register"
        static let users = "users"
        static let login = "login"
    }
    
    class func setupRoutes(droplet: Droplet, protectedRouter: RouteBuilder, apiPath: String) {
        let userController = UserController(droplet)
        droplet.post(apiPath + Endpoints.register, handler: userController.createUser)
        droplet.post(apiPath + Endpoints.login, handler: userController.loginUser)
        droplet.post("test", handler: userController.test)
        
        // Protected
        protectedRouter.get(apiPath + Endpoints.users, handler: userController.users)
        protectedRouter.get("me") { req in
            return try req.user().name
        }
    }
}
