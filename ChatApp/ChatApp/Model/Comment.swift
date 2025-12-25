//
//  Comment.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 26.12.2025.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
