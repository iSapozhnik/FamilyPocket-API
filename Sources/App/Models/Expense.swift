//
//  Expense.swift
//  App
//
//  Created by Ivan Sapozhnik on 02.02.18.
//

import Vapor
import FluentProvider
import HTTP
import Foundation

final class Expense: Model, NodeRepresentable {
    let storage = Storage()
    
    var categoryId: String
    var expense: Double
    var date: Date
    
    struct Keys {
        static let id = "id"
        static let categoryId = "categoryId"
        static let expense = "expense"
        static let date = "date"
    }
    
    init(categoryId: String, expense: Double, date: Date) {
        self.categoryId = categoryId
        self.expense = expense
        self.date = date
    }
    
    init(row: Row) throws {
        categoryId = try row.get(Expense.Keys.categoryId)
        expense = try row.get(Expense.Keys.expense)
        date = try row.get(Expense.Keys.date)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Expense.Keys.categoryId, categoryId)
        try row.set(Expense.Keys.expense, expense)
        try row.set(Expense.Keys.date, Expense.dateFormatter.string(from: date))
        return row
    }
    
    private static var _df: DateFormatter?
    private static var dateFormatter: DateFormatter {
        if let df = _df {
            return df
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        _df = df
        return df
    }
}

extension Expense: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Expense.Keys.expense)
            builder.string(Expense.Keys.categoryId)
            builder.date(Expense.Keys.date)
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
            expense: try json.get(Expense.Keys.expense),
            date: Date()
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Expense.Keys.id, id)
        try json.set(Expense.Keys.categoryId, categoryId)
        try json.set(Expense.Keys.expense, expense)
        try json.set(Expense.Keys.date, Expense.dateFormatter.string(from: date))
        return json
    }
}

extension Expense: ResponseRepresentable { }
