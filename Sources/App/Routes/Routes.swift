import Vapor
import AuthProvider
import Sessions
import HTTP

struct APIConfig {
    let path: String
    let version: String
}

extension Droplet {
    static let apiConfig = APIConfig(path: "api/", version: "v1/")
    
    func setupRoutes() throws {
        
        let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
        let authed = self.grouped(tokenMiddleware)
        
//        get("hello") { req in
//            var json = JSON()
//            try json.set("hello", "world")
//            return json
//        }
//
//        get("plaintext") { req in
//            return "Hello, world!"
//        }

        // response to requests to /info domain
        // with a description of the request
//        get("info") { req in
//            return req.description
//        }

//        get("description") { req in return req.description }
        
        let apiPath = Droplet.apiConfig.path + Droplet.apiConfig.version
        
        try authed.resource(apiPath+"posts", PostController.self)
        try authed.resource(apiPath+"expenses", ExpenseController.self)
        
        get { req in
            return try self.view.make("login")
        }
        
        get("register") { req in
            return try self.view.make("register")
        }
        
        get("login") { req in
            return try self.view.make("login")
        }
    
        UserRoutes.setupRoutes(droplet: self, protectedRouter: authed, apiPath: apiPath)
        
    }
}
