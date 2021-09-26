//
//  Parser.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import Foundation

struct Parser {
    static func decode<Model>(
        from data: [String: Any],
        to model: Model.Type
    ) -> Result<Model, Error> where Model: Decodable {

        let decoder = JSONDecoder()

        do {
            let data = try decoder.decode(
                Model.self,
                from: JSONSerialization.data(withJSONObject: data)
            )

            return .success(data)
        } catch {
            return .failure(ErrorCases.notDecodable)
        }
    }

    enum ErrorCases: LocalizedError {
        case notDecodable
        case unknown

        var errorDescription: String? {
            switch self {
            case .notDecodable:
                return "Error: Not Decodable"
            default:
                return "Error: Unknown Error occured"
            }
        }
    }
}
