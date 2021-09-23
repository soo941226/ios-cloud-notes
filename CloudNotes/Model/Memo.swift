//
//  Memo.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import Foundation

final class Memo {
    static let associatedEntity = "CloudNote"

    let title: String
    let body: String
    let lastUpdatedTime: TimeInterval

    init(title: String, body: String, lastUpdatedTime: TimeInterval) {
        self.title = title
        self.body = body
        self.lastUpdatedTime = lastUpdatedTime
    }

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastUpdatedTime = "last_modified"
    }

    enum CoreDataKey: String {
        case title, body, lastUpdatedTime
    }
}
