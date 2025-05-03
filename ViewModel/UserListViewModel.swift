//
//  UserListViewModel.swift
//  UserList
//
//  Created by Perez William on 20/04/2025.
//

import Foundation
final class UserListViewModel: ObservableObject {
        // TODO: - The property should be declared in the viewModel
        private let repository = UserListRepository()
        // pour pouvoir tester mon viewModel, je dois initialiser mon reposotory
        @Published var users: [User] = []
        @Published  var isLoading = false
        @Published  var isGridView = false
        
        
        
}
