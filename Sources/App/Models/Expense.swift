//
//  Expense.swift
//  App
//
//  Created by Ivan Sapozhnik on 02.02.18.
//

import Vapor
import FluentProvider
import HTTP

final class Expense: Model {
    let storage = Storage()
    
    var categoryId: String
    var expense: Double
    
    struct Keys {
        static let id = "id"
        static let categoryId = "categoryId"
        static let expense = "expense"
    }
    
    init(categoryId: String, expense: Double) {
        self.categoryId = categoryId
        self.expense = expense
    }
    
    init(row: Row) throws {
        categoryId = try row.get(Expense.Keys.categoryId)
        expense = try row.get(Expense.Keys.expense)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Expense.Keys.categoryId, categoryId)
        try row.set(Expense.Keys.expense, expense)
        return row
    }
}

extension Expense: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Expense.Keys.categoryId)
            builder.string(Expense.Keys.expense)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Expense: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            categoryId: try json.get(Expense.Keys.categoryId),
            expense: try json.get(Expense.Keys.expense)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Expense.Keys.id, id)
        try json.set(Expense.Keys.categoryId, categoryId)
        try json.set(Expense.Keys.expense, expense)
        return json
    }
}

extension Expense: ResponseRepresentable { }

