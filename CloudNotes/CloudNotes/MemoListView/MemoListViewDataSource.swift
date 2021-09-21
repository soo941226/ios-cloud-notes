//
//  MemoListViewDataSource.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewDataSource: NSObject, UITableViewDataSource {
    private var memoList = [Memo]()

    subscript(indexPath: IndexPath) -> Memo {
        return memoList[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memoListViewCell = tableView.dequeueReusableCell(
                withIdentifier: MemoListViewCell.identifier
        ) as? MemoListViewCell else {
            return UITableViewCell()
        }

        memoListViewCell.configure(with: memoList[indexPath.row])

        return memoListViewCell
    }
}

// MARK: - Managing memoList with MemoListViewController
extension MemoListViewDataSource {
    func tableView(_ tableView: UITableView, initializeMemoListWith memoList: [Memo]) {
        self.memoList = memoList
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, deleteRowAt indexPath: IndexPath) {
        memoList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, insertRowWith memo: Memo) {
        memoList.insert(memo, at: .zero)
        tableView.insertRows(at: [IndexPath(row: .zero, section: .zero)], with: .none)
    }

    func tableView(
        _ tableView: UITableView,
        updateRowAt indexPath: IndexPath,
        with memo: Memo
    ) {
        memoList[indexPath.row] = memo
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
