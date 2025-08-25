//
//  TamagochiPopupViewModel.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation

final class TamagochiPopupViewModel {

    var tamaData: TamagochiModel
    var buttonTitle: String

    init(tamaModel: TamagochiModel, buttonTitle: String) {
        tamaData = tamaModel
        self.buttonTitle = buttonTitle
    }
}
