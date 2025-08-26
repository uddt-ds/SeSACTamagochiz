//
//  BoxOfficeErrorModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/26/25.
//

import Foundation

struct BoxOfficeServerError: Decodable {
    let faultInfo: FaultInfo
}

struct FaultInfo: Decodable {
    let message: String
    let errorCode: String
}
