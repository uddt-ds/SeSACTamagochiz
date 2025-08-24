//
//  ImageSet.swift
//  Tamagochiz
//
//  Created by Lee on 8/24/25.
//

import UIKit

enum TamaCategory: Int {
    case tama1 = 1
    case tama2
    case tama3

    func getImage(with level: Int) -> UIImage {
        switch self {
        case .tama1: return UIImage(named: "\(TamaCategory.tama1.rawValue)-\(level)") ?? UIImage()
        case .tama2: return UIImage(named: "\(TamaCategory.tama2.rawValue)-\(level)") ?? UIImage()
        case .tama3: return UIImage(named: "\(TamaCategory.tama3.rawValue)-\(level)") ?? UIImage()
        }
    }
}
