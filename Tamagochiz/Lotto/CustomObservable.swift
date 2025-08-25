//
//  CustomObservable.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class CustomObservable {

    static func fetchLottoData(query: String) -> Observable<LottoModel> {

        return Observable.create { value in
            let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(query)"
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LottoModel.self) { responseData in
                    switch responseData.result {
                    case .success(let data):
                        value.onNext(data)
                    case .failure(let error):
                        value.onError(NetworkError.failDecoding)
                    }
                }
            return Disposables.create()
        }
    }

}
