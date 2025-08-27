//
//  UserDefaultsManager.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

final class UserDefaultsManager {

    static var tamagochiModel: TamagochiModel = .init(tamaCategory: .tama1, name: "", image: "", tamaMessage: "")

    private var userData: UserData = .init(tamagochi: 0, tamagochiName: "", nickname: "대장", level: 1, food: 0, water: 0)

    static func getData() -> UserData {
        if let data = UserDefaults.standard.data(forKey: Key.userData.rawValue) {
            do {
                let decodedData = try JSONDecoder().decode(UserData.self, from: data)
                return decodedData
            } catch {
                print(UserDefaultsError.failDecoding.rawValue)
            }
        }
        return .init(tamagochi: 0, tamagochiName: "", nickname: "대장", level: 1, food: 0, water: 0)
    }

    static func setData(value: UserData, key: Key) {
        if let encodedData = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
    }

    static func updateData(update: ((inout UserData) -> Void)) {
        var currentData = getData()
        update(&currentData)
        setData(value: currentData, key: .userData)
    }

    static func removeData(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

extension UserDefaultsManager {
    enum Key: String {
        case userData
    }

    enum UserDefaultsError: String, Error {
        case failDecoding = "Userdata 디코딩 실패입니다"
        case failEncoding = "Userdata 인코딩 실패입니다"
    }
}
