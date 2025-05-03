//
//  UserRowView.swift
//  UserList
//
//  Created by Perez William on 03/05/2025.
//

import SwiftUI

// UserRow représente une seule ligne dans la liste des utilisateurs.
struct UserRow: View {
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

// --- Preview (Optionnel mais utile pour UserRow) ---
struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        // Crée un utilisateur factice pour la prévisualisation
         let previewUser = User(
            user: UserListResponse.User(
                name: .init(title: "Ms", first: "Jane", last: "Smith"),
                dob: .init(date: "1985-11-20T14:00:00.000Z", age: 38),
                picture: .init(
                    large: "https://randomuser.me/api/portraits/women/75.jpg",
                    medium: "https://randomuser.me/api/portraits/med/women/75.jpg",
                    thumbnail: "https://randomuser.me/api/portraits/thumb/women/75.jpg"
                )
            )
        )
        UserRow(user: previewUser)
            .padding() // Ajoute du padding pour mieux voir dans le canvas de preview
            .previewLayout(.sizeThatFits) // Ajuste la taille de la preview au contenu
    }
}
