import SwiftUI

struct UserListView: View {
    // Instantiation. The default initializer UserListViewModel() in turn creates a default UserListRepository()
    @StateObject private var viewModel = UserListViewModel()

    /// L'état pour le sélecteur List/Grid reste dans la Vue.
    @State private var isGridView = false

    var body: some View {
        NavigationView {
            Group {
                // Sélectionne la vue Liste ou Grille directement.
                    //PAS DE LOGIQUE
                if !isGridView {
                    listView
                } else {
                    gridView
                }
            }
            .navigationTitle("Users")
            .toolbar {
                // Sélecteur List/Grid
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Display", selection: $isGridView) {
                        Image(systemName: "list.bullet").tag(false)
                            .accessibilityLabel(Text("List view"))
                        Image(systemName: "rectangle.grid.1x2.fill").tag(true)
                            .accessibilityLabel(Text("Grid view"))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                // Bouton de rechargement
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Appelle la méthode reloadUsers du ViewModel
                    Button(action: viewModel.reloadUsers) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                    // Désactive le bouton pendant le chargement pour éviter les appels multiples
                    .disabled(viewModel.isLoading)
                }
            }
        }
        // Charge les utilisateurs initiaux lorsque la vue apparaît pour la première fois
        .onAppear {
            viewModel.fetchInitialUsersIfNeeded()
        }
    }

    // Vue extraite pour l'affichage en liste
    // Elle utilise maintenant UserRow défini dans un autre fichier
    private var listView: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    UserRowView(user: user) // Utilise la vue UserRow externe
                }
                .onAppear { ///.onAppear calls viewModel.fetchInitialUsersIfNeeded().
                    viewModel.loadMoreContentIfNeeded(currentItem: user)
                }
            }
        }
    }
    // Vue extraite pour l'affichage en grille
    // Elle utilise maintenant UserGrid défini dans un autre fichier
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        UserGridView(user: user) // Utilise la vue UserGridItem externe
                    }
                    .onAppear {
                        viewModel.loadMoreContentIfNeeded(currentItem: user)
                    }
                }
            }
            .padding()
        }
    }
}

// Les définitions de UserRow et UserGridItem ont été déplacées dans leurs propres fichiers.

// --- Preview ---
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
