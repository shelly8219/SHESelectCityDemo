//
//  SelectCityRouter.swift
//  she
//
//  Created by she on 24/08/2018.
//  Copyright © 2018 she. All rights reserved.
//

import UIKit
import Moya


enum SelectCityRouter {
    case getProvinces()
    case getCities(parameters:[String:Any])
    case getDistricts(parameters:[String:Any])
    
}
extension SelectCityRouter: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .getProvinces:
            return ""
        case .getCities:
            return ""
        case .getDistricts:
            return ""
        }
    }
    
    var method:  Moya.Method {
        switch self {
        case .getProvinces,.getCities,.getDistricts:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProvinces:
            return nil
        case .getCities(let parameters),.getDistricts(let parameters):
            return parameters
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getProvinces,.getCities,.getDistricts:
            return URLEncoding.default
        }
    }
    
    /// 请求类型 如普通请求，发送文件，下载文件
    var task: Task {
        return .request
    }
    /// 单元测试所需
    var sampleData: Data {
        return Data()
    }
    

}
