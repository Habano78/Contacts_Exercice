import SwiftUI

struct UserListView: View {
        @StateObject private var viewModel = UserListViewModel()
        
        var body: some View {
                // NavigationView encadre la vue et fournit une barre de navigation
                NavigationView {
                        // Utilisation d'un ternaire pour basculer entre listView et gridView
                        (
                                viewModel.displayMode == .list
                                ? AnyView(listView)  // Si displayMode == .list, on affiche la liste
                                : AnyView(gridView)
                        )
                        .navigationTitle("Users")
                        .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                        Picker("Display", selection: $viewModel.displayMode) {
                                                Image(systemName: "list.bullet")
                                                        .tag(UserListViewModel.DisplayMode.list)
                                                        .accessibilityLabel(Text("List view"))
                                                Image(systemName: "rectangle.grid.1x2.fill")
                                                        .tag(UserListViewModel.DisplayMode.grid)
                                                        .accessibilityLabel(Text("Grid view"))
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // Style segmenté pour le Picker
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                        Button(action: viewModel.reloadUsers) {
                                                Image(systemName: "arrow.clockwise")
                                                        .imageScale(.large)
                                        }
                                        .disabled(viewModel.isLoading) // Désactivé pendant le chargement
                                }
                        }
                }
                .onAppear {
                        // À l'apparition de la vue, on charge les utilisateurs initiaux si nécessaire
                        viewModel.fetchInitialUsersIfNeeded()
                }
        }
        
        // MARK: - Vue Liste
        /// Liste déroulante d'utilisateurs
        private var listView: some View {
                List {
                        ForEach(viewModel.users) { user in
                                // Chaque ligne est un NavigationLink vers la vue de détails
                                NavigationLink(destination: UserDetailView(user: user)) {
                                        UserRowView(user: user) // Vue custom pour afficher les infos de l'utilisateur
                                }
                                .onAppear {
                                        // Si on atteint le dernier élément, on déclenche le chargement de la suite
                                        viewModel.loadMoreContentIfNeeded(currentItem: user)
                                }
                        }
                }
        }
        
        // MARK: - Vue Grille
        /// Grille adaptative d'utilisateurs
        private var gridView: some View {
                ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                                ForEach(viewModel.users) { user in
                                        NavigationLink(destination: UserDetailView(user: user)) {
                                                UserGridView(user: user) // Vue custom pour un affichage en cellule
                                        }
                                        .onAppear {
                                                // Chargement infini si on arrive en bas de la grille
                                                viewModel.loadMoreContentIfNeeded(currentItem: user)
                                        }
                                }
                        }
                        .padding() // Espace autour de la grille
                }
        }
}
struct UserListView_Previews: PreviewProvider {
        static var previews: some View {
                UserListView()
        }
}
