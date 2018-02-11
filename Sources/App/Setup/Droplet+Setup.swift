@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try Category.generateCanegories()
        try setupRoutes()
        // Do any additional droplet setup
    }
}
