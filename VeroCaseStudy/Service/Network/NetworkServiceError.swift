//
//  NetworkServiceError.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation

//MARK: - URLSessionDataTaskError
enum NetworkServiceError: Error {
    case noData
    case dataParseError
}

extension NetworkServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataParseError:
            return "Error when parsing data."
        case .noData:
            return "No data."
        }
    }
}
