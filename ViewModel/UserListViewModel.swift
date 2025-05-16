//
//  UserListViewModel.swift
//
//  Created by Perez William on 20/04/2025.
//

import Foundation
import Combine

final class UserListViewModel: ObservableObject {
        private let repository: UserListRepository
        
        init(repository: UserListRepository = .init()) {
                self.repository = repository
        }
        
        // --- Outputs ---
        @Published var users: [User] = []
        @Published var isLoading: Bool = false
        
        // Gestion du mode d’affichage List/Grid
        enum DisplayMode: Int, CaseIterable, Identifiable {
                case list, grid
                var id: Int { rawValue }
        }
        @Published var displayMode: DisplayMode = .list
        
        // --- Inputs ---
        /// Charge la première série d'utilisateurs si la liste est vide.
        /// À appeler depuis .onAppear de la vue.
        @MainActor
        func fetchInitialUsersIfNeeded() {
                guard users.isEmpty else { return }
                fetchMoreUsers()
        }
        
        /// Recharge complètement la liste des utilisateurs.
        @MainActor
        func reloadUsers() {
                guard !isLoading else { return }
                users.removeAll()
                fetchMoreUsers()
        }
        
        /// Vérifie si l'élément actuel est le dernier et lance le chargement si nécessaire.
        @MainActor
        func loadMoreContentIfNeeded(currentItem item: User?) {
                guard let item = item, let lastItem = users.last else { return }
                if item.id == lastItem.id && !isLoading {
                        fetchMoreUsers()
                }
        }
        
        // --- Logique privée ---
        /// Fonction principale pour récupérer (plus) d'utilisateurs.
        @MainActor
        private func fetchMoreUsers() {
                guard !isLoading else { return }
                isLoading = true
                
                Task {
                        do {
                                let newUsers = try await repository.fetchUsers(quantity: 20)
                                self.users.append(contentsOf: newUsers)
                                self.isLoading = false
                        } catch {
                                print("Error fetching users: \(error.localizedDescription)")
                                self.isLoading = false
                        }
                }
        }
}
