//
//  ShareModels.swift
//  UserList
//
//  Created by Perez William on 23/04/2025.
//
// Les éléments ici étaient répetés dans User et UserListResponse

import Foundation

// Name.swift
struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

// Dob.swift
struct Dob: Codable {
    let date: String
    let age: Int
}

// Picture.swift
struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
