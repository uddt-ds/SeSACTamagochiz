//
//  BoxOfficeModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

struct BoxOfficeModel: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeResult]
}

struct DailyBoxOfficeResult: Decodable {
    let movieNm: String
}
