//
//  ImageSet.swift
//  Tamagochiz
//
//  Created by Lee on 8/24/25.
//

import UIKit

enum TamaCategory: Int, Codable {
    case tama1 = 1
    case tama2
    case tama3
    case isReady

    func getImage(with level: Int) -> UIImage {

        switch self {
        case .tama1: return UIImage(named: "\(TamaCategory.tama1.rawValue)-\(level)") ?? ._1_9
        case .tama2: return UIImage(named: "\(TamaCategory.tama2.rawValue)-\(level)") ?? ._2_9
        case .tama3: return UIImage(named: "\(TamaCategory.tama3.rawValue)-\(level)") ?? ._3_9
        case .isReady: return .no
        }
    }
}
