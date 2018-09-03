//
//  SelectCityService.swift
//  she
//
//  Created by she on 24/08/2018.
//  Copyright © 2018 she. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import RxSwift

final class SelectCityService {
    static let sharedInstance = SelectCityService()
    private init() {}
}
extension SelectCityService:Validator{
    ///获取省
    func getProvinces() -> Observable<[SelectCityModel]>{
        let provider = RxMoyaProvider<SelectCityRouter>()
        return provider
            .request(.getProvinces())
            .debugHttp(true)
            .validateJustReturn(to: [SelectCityModel.self])
    }
    func getCities(code:String) -> Observable<[SelectCityModel]> {
        let request:[String:Any] = ["code":code]
        let provider = RxMoyaProvider<SelectCityRouter>()
        return provider
            .request(.getCities(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: [SelectCityModel.self])
    }
    func getDistricts(code:String) -> Observable<[SelectCityModel]> {
        let request:[String:Any] = ["code":code]
        let provider = RxMoyaProvider<SelectCityRouter>()
        return provider
            .request(.getDistricts(parameters: request))
            .debugHttp(true)
            .validateJustReturn(to: [SelectCityModel.self])
    }
}
