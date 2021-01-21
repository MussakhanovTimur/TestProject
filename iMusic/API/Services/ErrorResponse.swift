//
//  ErrorResponse.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import Foundation

class ErrorResponse {
    
    public class var sharedInstance: ErrorResponse {
        struct Singleton {
            static let instance : ErrorResponse = ErrorResponse()
        }
        return Singleton.instance
    }
    
    func receiveError(_ error: Any) -> String? {
        guard let error = error as? NSError else { return nil }
        var message = ""
        switch error.code {
        case -1001:
            message = "Время ожидания ответа от сервера истекло. Попробуйте еще раз."
        case -1005, -1009:
            message = "Отсутствует интернет соединение"
        default:
            message = "Ошибка сервера. Попробуйте, пожалуйста, позже."
        }
        return message
    }
}
