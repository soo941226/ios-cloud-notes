//
//  CloudNotes - SplitViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

class SplitViewController: UISplitViewController {

    private let listViewController = MemoListViewController()
    private let detailViewController = MemoDetailViewController()
    private let splitViewDelegator = SplitViewDelegate()
    private let coreDataManager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = splitViewDelegator

        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        setViewController(listViewController, for: .primary)
        setViewController(detailViewController, for: .secondary)

        listViewController.delegate = self
        detailViewController.delegate = self

        loadMemoList()
    }
}

// MARK: - Messenger Delegate
extension SplitViewController: DelegateBetweenController {
    func showActionSheet() {
        let share = NSLocalizedString("Share", comment: "")
        let delete = NSLocalizedString("Delete", comment: "")
        let cancel = NSLocalizedString("Cancel", comment: "")

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let shareAction = UIAlertAction(title: share, style: .default)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        let deleteAction = UIAlertAction(title: delete, style: .destructive) { _ in
            self.deleteMemo()
            self.show(.primary)
        }

        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: false, completion: nil)
    }

    func update(with memo: Memo?) {
        listViewController.upsertMemo(with: memo)
    }

    func showList() {
        show(.primary)
    }

    func deleteMemo() {
        listViewController.deleteMemo()
    }

    func createMemo(with memo: Memo) {
        coreDataManager.createMemo(with: memo) { result in
            switch result {
            case .success:
                print("success in creating memo")
            case .failure(let error):
                let placeholder = ""
                print(error.errorDescription ?? placeholder)
            }
        }
    }

    func updateMemo(with memo: Memo, at index: Int) {
        coreDataManager.updateMemo(with: memo, at: index) { result in
            switch result {
            case .success:
                print("success in updating memo")
            case .failure(let error):
                let placeholder = ""
                print(error.errorDescription ?? placeholder)
            }
        }

    }

    func deleteMemo(at index: Int) {
        coreDataManager.deleteMemo(at: index) { result in
            switch result {
            case .success:
                print("success in deleting memo")
            case .failure(let error):
                let placeholder = ""
                print(error.errorDescription ?? placeholder)
            }
        }
    }

    func showDetail(with memo: Memo?) {
        detailViewController.configure(with: memo)

        show(.secondary)
    }
}

// MARK: - Managing CoreData
extension SplitViewController {
    func saveContext() {
        coreDataManager.saveContext()
    }

    private func loadMemoList() {
        coreDataManager.retrieveMemoList { result in
            switch result {
            case .success(let memoList):
                self.listViewController.initializeMemoList(with: memoList)
            case . failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
