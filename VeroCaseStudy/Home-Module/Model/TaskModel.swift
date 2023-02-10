//
//  TaskModel.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation

struct TaskResponseElement: Codable {
    let task, title, description, sort: String?
    let wageType: String?
    let businessUnitKey: BusinessUnit?
    let businessUnit: BusinessUnit?
    let parentTaskID: ParentTaskID?
    let preplanningBoardQuickSelect: JSONNull?
    let colorCode: String?
    let workingTime: JSONNull?
    let isAvailableInTimeTrackingKioskMode: Bool?

    enum CodingKeys: String, CodingKey {
        case task, title, description, sort, wageType
        case businessUnitKey = "BusinessUnitKey"
        case businessUnit, parentTaskID, preplanningBoardQuickSelect, colorCode, workingTime, isAvailableInTimeTrackingKioskMode
    }
}

enum BusinessUnit: String, Codable {
    case empty = ""
    case gerüstbau = "Gerüstbau"
}

enum ParentTaskID: String, Codable {
    case empty = ""
    case the10Aufbau = "10 Aufbau"
}

typealias TaskResponse = [TaskResponseElement]


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

