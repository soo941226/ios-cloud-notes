//
//  MessengerBetweenController.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/07.
//

import Foundation

protocol DetailViewControllerDelegate: AnyObject {
    func deleteMemo()
    func update(with memo: Memo?)
    func showList()
    func showActionSheet()
}

protocol ListViewControllerDelegate: AnyObject {
    func showDetail(with memo: Memo?)
    func updateMemo(with memo: Memo, at index: Int)
    func createMemo(with memo: Memo)
    func deleteMemo(at index: Int)
    func showActionSheet()
}

typealias DelegateBetweenController = ListViewControllerDelegate & DetailViewControllerDelegate
