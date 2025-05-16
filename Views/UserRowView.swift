//
//  UserRowView.swift
//  UserList
//
//  Created by Perez William on 03/05/2025.
//

import SwiftUI

// UserRow représente une seule ligne dans la liste des utilisateurs.
struct UserRowView: View {
        let user: User // Reçoit l'utilisateur à afficher
        
        var body: some View {
                HStack {
                        // Affiche l'image miniature de l'utilisateur
                        AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                                image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                        } placeholder: {
                                // Affiche une vue de progression pendant le chargement de l'image
                                ProgressView()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                        }
                        
                        // Affiche le nom et la date de naissance
                        VStack(alignment: .leading) {
                                Text("\(user.name.first) \(user.name.last)")
                                        .font(.headline)
                                // Affiche la date brute (pas de formatage ici)
                                Text("\(user.dob.date)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                        }
                }
        }
}
