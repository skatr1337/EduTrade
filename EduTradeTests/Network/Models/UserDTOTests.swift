//
//  UserDTOTests.swift
//  EduTradeTests
//
//  Created by Filip Biegaj on 19.01.2025.
//

@testable import EduTrade
import Testing

class UserDTOTests {
    @Test(
        "Test initials",
        arguments: zip(
            [
                UserDTO(id: "123", fullname: "John Smith", email: "test@test.ch"),
                UserDTO(id: "123", fullname: "John Smith Junior", email: "test@test.ch"),
                UserDTO(id: "123", fullname: "John", email: "test@test.ch"),
                UserDTO(id: "123", fullname: "", email: "test@test.ch")
            ] as [UserDTO],
            [
                "JS",
                "JS",
                "J",
                ""
            ] as [String]
        )
    )
    func fetchList(user: UserDTO, initials: String) async throws {
        #expect(user.initials == initials)
    }
}
