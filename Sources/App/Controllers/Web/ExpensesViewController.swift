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
import Paginator

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
        let expenses = try Expense
            .makeQuery()
            .sort("date", .descending)
            .all()
        let paginator = try expenses.paginator(10, request: req)

        return try drop.view.make(Keys.expenses, expensesNode(data: paginator.data!, paginator: paginator))
    }
    
    private func expensesNode(data: [Expense], paginator: Paginator<Expense>) throws -> [String: Node] {
        var tableNode: [String: Node] = [:]
        
        tableNode["categories"] = try categoriesNode()
        
        let tableHeader = ExpensesHeader.cases()
        tableNode["tableHeader"] = try tableHeader.map { $0.rawValue }.makeNode(in: nil)
        var rows = [[String: Node]]()
        
        try data.forEach { expense in
            var row: [String: Node] = [:]
            row["id"] = try expense.id.makeNode(in: nil)
            do {
                row["category"] = try Category.find(expense.categoryId)?.name.makeNode(in: nil)
            } catch {
                row["category"] = "-".makeNode(in: nil)
            }
            let formattedAmount = ExpensesViewController.priceFormatter.string(for: expense.expense)
            row["amount"] = try formattedAmount.makeNode(in: nil)
            row["date"] = ExpensesViewController.dateFormatter.string(from: expense.date).makeNode(in: nil)
            rows.append(row)
        }
        
        tableNode["tableRows"] = try rows.makeNode(in: nil)
        
        tableNode["pages"] = try paginatorNode(paginator: paginator)
        return tableNode
    }
    
    private func paginatorNode(paginator: Paginator<Expense>) throws -> Node {
        var pages = [[String: Node]]()
        for i in 1..<paginator.totalPages! + 1 {
            var page: [String: Node] = [:]
            page["name"] = i.makeNode(in: nil)
            page["disabled"] = i == paginator.currentPage ? "disabled" : ""
            page["link"] = ("?page=\(i)").makeNode(in: nil)
            pages.append(page)
        }
        return try pages.makeNode(in: nil)
    }
    
    private func categoriesNode() throws -> Node {
        let categories = try Category
            .makeQuery()
            .sort("name", .ascending)
            .all()
        return try categories.map { $0.name }.makeNode(in: nil)
    }
}
