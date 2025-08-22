//
//  UserModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation

//TODO: 다마고치 타입 추가 필요
struct UserModel: Codable {
    var nickname: String
    var level: Int
    var foodCount: Int
    var waterCount: Int
}
