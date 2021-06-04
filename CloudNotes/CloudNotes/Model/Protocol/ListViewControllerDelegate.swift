//
//  ListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/04.
//

import Foundation

protocol ListViewControllerDelegate: AnyObject {
  func didTapMenuItem(at index: Int, model memoInfo: MemoInfo)
}
