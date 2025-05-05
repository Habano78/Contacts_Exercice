//
//  MockUserListRepository.swift
//  UserListTests
//
//  Created by Perez William on 05/05/2025.
//

import Foundation
import UserList
@testable import UserList

class MockUserListRepository: UserListRepository {
        var fetchUsersCalled = false
        var fetchUsersReturnValue: Result<[User], Error> = .success([])
        
        func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
                fetchUsersCalled = true
                completion(fetchUsersReturnValue)
        }
}
