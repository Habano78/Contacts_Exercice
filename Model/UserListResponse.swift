import Foundation
// Modèle Réseau : représenter la structure des données telles qu'elles arrivent du réseau. 
struct UserListResponse: Codable {
    let results: [User]

    // MARK: - User
    struct User: Codable {
        let name: Name // Name partagé
        let dob: Dob // Dob partagé
        let picture: Picture // Picture Partagé

    }
}
