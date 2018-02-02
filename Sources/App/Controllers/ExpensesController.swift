//
//  ExpensesController.swift
//  App
//
//  Created by Ivan Sapozhnik on 02.02.18.
//

import Vapor
import HTTP

final class ExpenseController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Expense.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let expense = try req.expense()
        try expense.save()
        return expense
    }
    
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: store
        )
    }
}

extension Request {
    func expense() throws -> Expense {
        guard let json = json else {
            throw Abort.badRequest
        }
        return try Expense(json: json)
    }
}

extension ExpenseController: EmptyInitializable { }
