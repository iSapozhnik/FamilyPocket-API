//
//  ExpensesViewController.swift
//  App
//
//  Created by Ivan Sapozhnik on 10.02.18.
//

import Foundation
import Vapor
import HTTP
import SMTP
import Transport

enum ExpensesHeader: String, EnumCollection {
    case id = "id"
    case category = "Category"
    case amount = "Amount"
    case date = "Date"
}

final class ExpensesViewController {

    struct Keys {
        static let expenses = "expenses"
    }
    
    let drop: Droplet
    
    init(_ droplet: Droplet) {
        self.drop = droplet
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    func expenses(_ req: Request) throws -> ResponseRepresentable  {
        var tableNode: [String: Node] = [:]
        let tableHeader = ExpensesHeader.cases()
        tableNode["tableHeader"] = try tableHeader.map { $0.rawValue }.makeNode(in: nil)
        
        let expenses = try Expense.all()
        var rows = [[String: Node]]()

        try expenses.forEach { expense in
            var row: [String: Node] = [:]
            row["id"] = try expense.id.makeNode(in: nil)
            row["category"] = expense.categoryId.makeNode(in: nil)
            let formattedAmount = ExpensesViewController.priceFormatter.string(for: expense.expense)
            row["amount"] = try formattedAmount.makeNode(in: nil)
            row["date"] = ExpensesViewController.dateFormatter.string(from: expense.date).makeNode(in: nil)
            rows.append(row)
        }
        
        tableNode["tableRows"] = try rows.makeNode(in: nil)
        
        return try drop.view.make(Keys.expenses, tableNode)
    }
}
