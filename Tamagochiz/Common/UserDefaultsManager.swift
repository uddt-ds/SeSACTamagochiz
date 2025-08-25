//
//  UserDefaultsManager.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

final class UserDefaultsManager {

    static var tamagochi: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.tamagochi.rawValue)
        }
    }

    static var tamagochiName: String {
        get {
            UserDefaults.standard.string(forKey: Key.tamagochiName.rawValue) ?? "준비 중"
        }
    }

    static var tamagochiModel: TamagochiModel = .init(tamaCategory: .tama1, name: "", image: "", tamaMessage: "")

    static var nickname: String {
        get {
            UserDefaults.standard.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
    }

    static var level: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.level.rawValue)
        }
    }

    static var food: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.food.rawValue)
        }
    }

    static var water: Int {
        get {
            UserDefaults.standard.integer(forKey: Key.water.rawValue)
        }
    }

    static func setData<T>(_ value: T, key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func reset() {
        setData(0, key: .tamagochi)
        setData("", key: .tamagochiName)
        setData("", key: .nickname)
        setData(0, key: .level)
        setData(0, key: .food)
        setData(0, key: .water)
    }
}

extension UserDefaultsManager {
    enum Key: String {
        case food
        case water
        case level
        case nickname
        case tamagochi
        case tamagochiName
    }
}
