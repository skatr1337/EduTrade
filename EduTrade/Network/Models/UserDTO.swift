//
//  UserDTO.swift
//  EduTrade
//
//  Created by Filip Biegaj on 01/12/2024.
//

import Foundation

struct UserDTO: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
}

extension UserDTO {
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}
