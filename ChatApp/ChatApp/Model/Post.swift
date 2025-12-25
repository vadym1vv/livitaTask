//
//  Post.swift
//  ChatApp
//
//  Created by Vadym Vasylaki on 26.12.2025.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
