//
//  UserListViewModel.swift
//
//  Created by Perez William on 20/04/2025.
//

import Foundation

@MainActor // Assure que les mises à jour des @Published se font sur le fil principal
final class UserListViewModel: ObservableObject {

    // --- Outputs---
    @Published var users: [User] = []
    @Published var isLoading: Bool = false

    // Le repository est maintenant atteignable par le ViewModel
    private let repository: UserListRepository

    // Injection de dépendance et valeur par défaut
    init(repository: UserListRepository = UserListRepository()) {
        self.repository = repository
    }

    // --- Inputs ---

    /// Charge la première série d'utilisateurs si la liste est vide.
    /// À appeler depuis .onAppear de la vue.
    func fetchInitialUsersIfNeeded() {
        // Ne charge que si la liste est vide pour éviter les rechargements multiples
        // lors des réapparitions de la vue.
        guard users.isEmpty else { return }
        fetchMoreUsers()
    }

    /// Recharge complètement la liste des utilisateurs.
    func reloadUsers() {
            // Évite les rechargements multiples si déjà en cours
        guard !isLoading else { return }

        users.removeAll() // Vide la liste
        fetchMoreUsers()  // Lance le chargement de la première page
    }

    /// Vérifie si l'élément actuel est le dernier et lance le chargement si nécessaire.
    func loadMoreContentIfNeeded(currentItem item: User?) {
        // S'assure qu'on a un item et que la liste n'est pas vide
        guard let item = item, let lastItem = users.last else {
            return
        }
        // Vérifie si l'item est le dernier ET qu'on n'est pas déjà en train de charger
        if item.id == lastItem.id && !isLoading {
            fetchMoreUsers()
        }
    }

    // --- Logique Privée ---

    /// Fonction principale pour récupérer (plus) d'utilisateurs.
    /// Encapsule la logique de l'ancienne fonction `fetchUsers` de la vue (TODO #3).
    private func fetchMoreUsers() {
        // Empêche les appels multiples si déjà en cours
        guard !isLoading else { return }

        isLoading = true

        Task {
            do {
                // Récupère 20 nouveaux utilisateurs (comme dans l'original)
                let newUsers = try await repository.fetchUsers(quantity: 20)

                // Ajoute les nouveaux utilisateurs à la liste existante
                self.users.append(contentsOf: newUsers)
                self.isLoading = false
            } catch {
                // Conformément à la demande de ne PAS ajouter la gestion d'erreur visible pour l'instant,
                // on se contente d'imprimer l'erreur et de remettre isLoading à false.
                print("Error fetching users: \(error.localizedDescription)")
                self.isLoading = false // Important de le faire même en cas d'erreur
            }
        }
    }
}
