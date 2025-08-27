//
//  UserData.swift
//  Tamagochiz
//
//  Created by Lee on 8/26/25.
//

import Foundation

struct UserData: Codable {
    var tamagochi: Int
    var tamagochiName: String
    var nickname: String
    var level: Int
    var food: Int
    var water: Int
}
