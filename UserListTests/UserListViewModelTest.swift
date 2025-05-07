//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Perez William on 06/05/2025.
//

import XCTest
import Combine
@testable import UserList

@MainActor
final class UserListViewModelTests: XCTestCase {
    // MARK: - Properties
    var viewModel: UserListViewModel!
    var mockData: MockData!
    var repository: UserListRepository!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockData = MockData()
        mockData.isValidResponse = true
        repository = UserListRepository(executeDataRequest: mockData.executeRequest)
        viewModel = UserListViewModel(repository: repository)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        repository = nil
        mockData = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchInitialUsersIfNeededLoadsUsers() {
        // Given
        XCTAssertTrue(viewModel.users.isEmpty)
        let expectation = expectation(description: "Users loaded")

        // Listen only to the first actual update
        viewModel.$users
            .dropFirst()      // skip initial empty
            .first()          // take only the first update
            .sink { users in
                XCTAssertEqual(users.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.fetchInitialUsersIfNeeded()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testReloadUsersClearsAndReloads() {
        // Perform initial load and take only first update
        let initialExpectation = expectation(description: "Initial load")
        viewModel.$users
            .dropFirst()      // skip initial empty
            .first()          // take only the first update
            .sink { users in
                XCTAssertEqual(users.count, 2)
                initialExpectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchInitialUsersIfNeeded()
        wait(for: [initialExpectation], timeout: 1.0)

        // Then clear subscriptions and test reload
        cancellables.removeAll()

        let reloadExpectation = expectation(description: "Reload users")
        viewModel.$users
            .dropFirst(2)     // skip current state + clear
            .first()          // take only the reload update
            .sink { users in
                XCTAssertEqual(users.count, 2)
                reloadExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.reloadUsers()
        wait(for: [reloadExpectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadMoreContentIfNeededTriggersLoadAtEnd() {
        // Initial load, take only first update
        let initialExpectation = expectation(description: "Initial load")
        viewModel.$users
            .dropFirst()
            .first()
            .sink { users in
                XCTAssertEqual(users.count, 2)
                initialExpectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchInitialUsersIfNeeded()
        wait(for: [initialExpectation], timeout: 1.0)

        // Load more, take only one update after
        let moreExpectation = expectation(description: "Load more")
        viewModel.$users
            .dropFirst(1)     // skip the first load
            .first()          // take only the second append
            .sink { users in
                XCTAssertEqual(users.count, 4)
                moreExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMoreContentIfNeeded(currentItem: viewModel.users.last)
        wait(for: [moreExpectation], timeout: 1.0)
    }

    func testLoadMoreContentIfNeededDoesNotTriggerIfNotLast() {
        // Initial load, take only first update
        let initialExpectation = expectation(description: "Initial load")
        viewModel.$users
            .dropFirst()
            .first()
            .sink { users in
                XCTAssertEqual(users.count, 2)
                initialExpectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.fetchInitialUsersIfNeeded()
        wait(for: [initialExpectation], timeout: 1.0)

        // Expect no further loading
        let noLoadExpectation = expectation(description: "No additional load")
        noLoadExpectation.isInverted = true
        viewModel.$users
            .dropFirst()
            .sink { _ in
                noLoadExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMoreContentIfNeeded(currentItem: viewModel.users.first)
        wait(for: [noLoadExpectation], timeout: 1.0)
    }
}
