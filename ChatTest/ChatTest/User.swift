//
//  User.swift
//  ChatTest
//
//  Created by 장태현 on 2020/08/17.
//  Copyright © 2020 장태현. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: String
    var nickname: String
    var isConnected: Bool
}
