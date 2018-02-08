//
//  EmailSender.swift
//  App
//
//  Created by Ivan Sapozhnik on 08.02.18.
//

import Foundation
import SMTP
import Transport
import Sockets

class EmailSender {
    func send() {
        let credentials = SMTPCredentials(
            user: "sapozhnik.ivan@gmail.com",
            pass: "Asterix1988"
        )
        
        let from = EmailAddress(name: "FamilyPocket",
                                address: "sapozhnik.ivan@gmail.com")
        
        let to = EmailAddress(name: "Ivan",
                              address: "sapozhnik.ivan@gmail.com")
        
        let email = Email(
            from: from,
            to: to,
            subject: "Vapor SMTP - Simple",
            body: "Hello from Vapor SMTP 👋"
        )
        
        do {
            let stream = try TCPInternetSocket(
                scheme: "smtps",
                hostname: "smtp.gmail.com",
                port: 465
            )
            let client = try SMTPClient(stream)
            try client.send(email, using: credentials)
        } catch (let error) {
            print("Mail Error: \(error)")
        }
    }
}
