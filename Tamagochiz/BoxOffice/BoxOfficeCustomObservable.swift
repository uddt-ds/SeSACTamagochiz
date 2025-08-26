//
//  BoxOfficeCustomObservable.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import Foundation
import RxSwift
import Alamofire

final class BoxOfficeCustomObservable {

    static func getBoxOfficeSingleData(query: String) -> Single<Result<[DailyBoxOfficeResult], NetworkError>> {
        return Single.create { value in
            let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=db57e192674e643639b0af1738f61186&targetDt=\(query)"
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BoxOfficeModel.self) { responseData in
                    switch responseData.result {
                    case .success(let model):
                        value(.success(.success(model.boxOfficeResult.dailyBoxOfficeList)))
                    case .failure(let error):
                        guard let data = responseData.data else { return }
                        do {
                            let decodedData = try JSONDecoder().decode(BoxOfficeServerError.self, from: data)
                            value(.success(.failure(.serverError(message: decodedData.faultInfo.message))))
                        } catch {
                            value(.success(.failure(.failDecoding)))
                        }
                        value(.success(.failure(.noData)))
                    }
                }
            return Disposables.create()
        }
    }

    static func getBoxOfficeData(query: String) -> Observable<[DailyBoxOfficeResult]> {
        return Observable.create { value in
            let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=db57e192674e643639b0af1738f61186&targetDt=\(query)"
            AF.request(url)
                .responseDecodable(of: BoxOfficeModel.self) { responseData in
                    switch responseData.result {
                    case .success(let data):
                        value.onNext(data.boxOfficeResult.dailyBoxOfficeList)
                    case .failure(let error):
                        value.onError(NetworkError.failDecoding)
                    }
                }
            return Disposables.create()
        }
    }

}
