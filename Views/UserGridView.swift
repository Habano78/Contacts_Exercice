//
//  UserGridView.swift
//  UserList
//
//  Created by Perez William on 03/05/2025.
//

import SwiftUI

// UserGrid représente un seul item dans la grille des utilisateurs.
struct UserGridView: View {
        let user: User // Reçoit l'utilisateur à afficher
        
        var body: some View {
                VStack {
                        // Affiche l'image moyenne de l'utilisateur
                        AsyncImage(url: URL(string: user.picture.medium)) { image in
                                image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120) // Taille adaptée à la grille
                                        .clipShape(Circle())
                        } placeholder: {
                                // Affiche une vue de progression pendant le chargement de l'image
                                ProgressView()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                        }
                        
                        // Affiche le nom complet, centré et potentiellement sur plusieurs lignes
                        Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(2) // Limite à 2 lignes pour éviter les textes trop longs
                                .padding(.top, 4) // Petit espace entre l'image et le texte
                }
                .padding(.bottom) // Espace sous l'item dans la grille
        }
}
