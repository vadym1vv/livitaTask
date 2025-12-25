//
//  User.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 26.12.2025.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
