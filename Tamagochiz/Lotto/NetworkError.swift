//
//  NetworkError.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

enum NetworkError: Error {
    case failEncoding
    case failDecoding
    case noData
    case serverError

    var title: String {
        switch self {
        case .failDecoding: "디코딩 실패입니다"
        case .failEncoding: "인코딩 실패입니다"
        case .noData: "데이터가 없습니다"
        case .serverError: "서버 에러입니다"
        }
    }
}
