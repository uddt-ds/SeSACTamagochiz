//
//  BaseUserDefaults.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import Foundation

@propertyWrapper struct BaseUserDefaults<T: Codable> {
    let key: String
    let defaultValue: T
    let storage = UserDefaults.standard

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let data = storage.data(forKey: key) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch {
                    print(UserDefaultError.failDecoding.rawValue)
                }
            }
            return defaultValue
        }

        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                storage.set(data, forKey: key)
            } catch {
                print(UserDefaultError.failEncoding.rawValue)
            }
        }
    }
}

extension BaseUserDefaults {
    enum UserDefaultError: String, Error {
        case failDecoding = "UserDefaults 디코딩에 실패했습니다"
        case failEncoding = "UserDefaults 인코딩에 실패했습니다"
    }
}


enum UserDefaultKey: String {
    case userData
}
