//
//  Category.swift
//  App
//
//  Created by Ivan Sapozhnik on 10.02.18.
//

import Foundation
import FluentProvider
import Fluent

final class Category: Model, NodeRepresentable {
    let storage = Storage()
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    required init(row: Row) throws {
        name = try row.get("name")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name",name)
        return row
    }
}

extension Category: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Player
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name")
        }
        try generateCanegories()
    }
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
    private static func generateCanegories() throws {
        if try Category.all().count == 0 {
            try Category(name: "Shopping").save()
            try Category(name: "Food").save()
            try Category(name: "Auto").save()
            try Category(name: "Transport").save()
            try Category(name: "Gym").save()
        }
    }
}

extension Category: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name",name)
        return json
    }
}
