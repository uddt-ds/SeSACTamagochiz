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
        case tama1: return UIImage(named: "\(tama1.rawValue)-\(level)")
        case tama2: return UIImage(named: "\(tama2.rawValue)-\(level)")
        case tama3: return UIImage(named: "\(tama3.rawValue)-\(level)")
        }
    }
}
