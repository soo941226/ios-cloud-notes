//
//  MemoListViewDelegate.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/03.
//

import UIKit

final class MemoListViewDelegate: NSObject, UITableViewDelegate {
    private weak var owner: MemoListViewController?

    init(owner: MemoListViewController) {
        self.owner = owner
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        owner?.showDetailViewController(at: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = NSLocalizedString("Delete", comment: "")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: delete
        ) { _, _, _ in
            self.owner?.showActionSheet()
        }

        owner?.assignLastIndexPath(with: indexPath)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
