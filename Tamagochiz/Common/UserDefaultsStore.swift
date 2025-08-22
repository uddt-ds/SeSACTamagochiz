//
//  UserDefaultManager.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation

class UserDefaultsStore {
    @BaseUserDefaults(key: UserDefaultKey.userData.rawValue, defaultValue: UserModel.init(nickname: "", level: 0, foodCount: 0, waterCount: 0))
    static var userData: UserModel
}
