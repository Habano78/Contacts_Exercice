//
//  UserListViewModelTest.swift
//  UserListTests
//
//  Created by Perez William on 05/05/2025.
//

import XCTest
@testable import UserList

final class UserListRepositoryTests: XCTestCase {
    
    //MARK: Properties
    var viewModel: UserListViewModel!
    var mockData = MockData()
    var repository: UserListRepository!
    
    override func setUp() {
        super.setUp()
        //S'execute au début de chaque tests
        mockData.isValidResponse = true
        repository = UserListRepository(executeDataRequest: mockData.executeRequest)
        viewModel = UserListViewModel(repository: repository)
    }
    
    override func tearDown() {
        //S'execute à la fin de chaque tests
        super.tearDown()
        viewModel = nil
        repository = nil
    }
    
    
    // Happy path test case
    func testFetchUsersSuccess() async throws {
        // Given
        let quantity = 2
        
        // When
        let users = try await repository.fetchUsers(quantity: quantity)
        
        // Then
        XCTAssertEqual(users.count, quantity)
        XCTAssertEqual(users[0].name.first, "John")
        XCTAssertEqual(users[0].name.last, "Doe")
        XCTAssertEqual(users[0].dob.age, 31)
        XCTAssertEqual(users[0].picture.large, "https://example.com/large.jpg")
        
        XCTAssertEqual(users[1].name.first, "Jane")
        XCTAssertEqual(users[1].name.last, "Smith")
        XCTAssertEqual(users[1].dob.age, 26)
        XCTAssertEqual(users[1].picture.medium, "https://example.com/medium.jpg")
    }
}
