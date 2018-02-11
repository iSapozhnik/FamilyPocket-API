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
    var iconName: String
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
    }
    
    required init(row: Row) throws {
        name = try row.get("name")
        iconName = try row.get("iconName")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name",name)
        try row.set("iconName",iconName)
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
            builder.string("iconName")

        }
        try generateCanegories()
    }
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
    static func generateCanegories() throws {
        
        guard try Category.all().count == 0 else { return }
        
        let fileName = "categories.json"
        let path = Config.workingDirectory() + "ImportData/" + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let categories = jsonResult["categories"] as? [Dictionary<String, Any>] {
    
                try categories.filter { $0["name"] != nil }.forEach {
                    try Category(name: $0["name"] as! String, iconName: $0["iconName"] as! String).save()
                }
            }
        }
    }
}

extension Category: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            name: json.get("name"),
            iconName: json.get("iconName")
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name",name)
        try json.set("name",iconName)
        return json
    }
}
