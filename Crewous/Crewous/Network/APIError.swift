//
//  APIError.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation

enum APIError: Int, Error {
    
    case success = 200 // 정상 동작 -> 데이터 모델 이상
    case code400 = 400
    case code401 = 401
    case code409 = 409
    
    // 공통 응답 코드
    case sesacKeyError = 420 // 새싹 키값 오류
    case serverOverCall = 429 // 서버 과호출
    case incorrectURL = 444 // 비정상 URL
    case unknownError = 500 // 정의되지 않은 오류
    
    func checkCommonError() -> Bool {
        
        switch self {
        case .sesacKeyError, .serverOverCall, .incorrectURL, .unknownError:
            return true
        default:
            return false
        }
    }
}