//
//  LottoModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

struct LottoModel: Decodable {
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

extension LottoModel {
    var totalTitle: String {
        return "\(drwtNo1), \(drwtNo2), \(drwtNo3), \(drwtNo4), \(drwtNo5), \(drwtNo6), 보너스 \(bnusNo)"
    }
}
