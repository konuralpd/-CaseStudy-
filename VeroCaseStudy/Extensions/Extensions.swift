//
//  Extensions.swift
//  VeroCaseStudy
//
//  Created by Mac on 10.02.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}
