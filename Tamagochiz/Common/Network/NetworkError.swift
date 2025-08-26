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
    case serverError(message: String)
    case queryError

    var title: String {
        switch self {
        case .failDecoding: "디코딩 실패입니다"
        case .failEncoding: "인코딩 실패입니다"
        case .noData: "데이터가 없습니다"
        case .serverError(let message): message
        case .queryError: "날짜 형식(YYYYMMDD)이 아닙니다 다시 확인해주세요"
        }
    }
}
