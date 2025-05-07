//
//  MockUserListRepository.swift
//  UserListTests
//
//  Created by Perez William on 05/05/2025.
//

import Foundation
@testable import UserList

class MockData {

    //MARK: Properties
    let mockUser1: UserListResponse.User
    let mockUser2: UserListResponse.User
    let userListResponseMock: UserListResponse
    var isValidResponse: Bool = true


    init() {
        mockUser1 = UserListResponse.User(
            name: UserListResponse.User.Name(title: "Mr", first: "John", last: "Doe"), dob: UserListResponse.User.Dob(date: "1990-01-01", age: 31), picture: UserListResponse.User.Picture(large: "https://example.com/large.jpg", medium: "https://example.com/medium.jpg", thumbnail: "https://example.com/thumbnail.jpg"))
        mockUser2 = UserListResponse.User(
            name: UserListResponse.User.Name(title: "Ms", first: "Jane", last: "Smith"), dob: UserListResponse.User.Dob(date: "1995-02-15", age: 26), picture: UserListResponse.User.Picture(large: "https://example.com/large.jpg", medium: "https://example.com/medium.jpg", thumbnail: "https://example.com/thumbnail.jpg"))

        userListResponseMock = UserListResponse(results: [mockUser1, mockUser2])

    }

    private func encodeData(userListReponseMock: UserListResponse) throws -> Data {
        return try JSONEncoder().encode(userListReponseMock)
    }

    func executeRequest(request: URLRequest) async throws -> (Data, URLResponse) {
        if isValidResponse {
           return try await validMockResponse(request: request)
        } else {
            return try await invaliddMockResponse(request: request)
        }
    }

    private func validMockResponse(request: URLRequest) async throws -> (Data, URLResponse) {
        let data = try encodeData(userListReponseMock: userListResponseMock)
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }

    private func invaliddMockResponse(request: URLRequest) async throws -> (Data, URLResponse) {
        let invalidData = "JSON_CASSÉ".data(using: .utf8)!
        let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
        return (invalidData, response)
    }
}
