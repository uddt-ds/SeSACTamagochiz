//
//  CustomError.swift
//  Sesac7Week2Day1
//
//  Created by Lee on 7/8/25.
//

import UIKit

enum CustomError {
    case foodFull
    case waterFull
    case wrongInput

    var title: String {
        switch self {
        case .foodFull: return "배가 불러서 밥을 먹을 수가 없어요"
        case .waterFull: return "배가 불러서 물을 먹을 수가 없어요"
        case .wrongInput: return "잘못된 입력입니다"
        }
    }
}
