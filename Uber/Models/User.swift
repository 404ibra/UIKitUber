//
//  User.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 6.02.2024.
//

import Foundation

struct User {
    let fullName: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String : Any]) {
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}
