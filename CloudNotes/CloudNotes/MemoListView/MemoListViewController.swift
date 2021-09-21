//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

class MemoListViewController: UITableViewController {
    private let memoListDataSource = MemoListViewDataSource()
    private var memoListDelegator: MemoListViewDelegate?
    private var lastIndexPath: IndexPath?

    weak var delegate: ListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationTitle()
        configureNavigationRightBarButtonItem()
    }

    func showDetailViewController(at indexPath: IndexPath) {
        delegate?.showDetail(with: memoListDataSource[indexPath])
        lastIndexPath = indexPath
    }

    func assignLastIndexPath(with indexPath: IndexPath) {
        lastIndexPath = indexPath
    }
}

// MARK: - Managing DataSource with MessengerForListViewController
extension MemoListViewController {
    func showActionSheet() {
        delegate?.showActionSheet()
    }

    func initializeMemoList(with memoList: [Memo]) {
        memoListDataSource.tableView(tableView, initializeMemoListWith: memoList)
    }

    func upsertMemo(with memo: Memo?) {
        guard let memo = memo else {
            return
        }

        if let selectedIndexPath = lastIndexPath {
            delegate?.updateMemo(with: memo, at: selectedIndexPath)
        } else {
            delegate?.createMemo(with: memo)
        }
    }

    func deleteMemo() {
        guard let indexPath = lastIndexPath else {
            return
        }

        delegate?.deleteMemo(at: indexPath)
    }

    func applyInsertedMemo(with memo: Memo) {
        memoListDataSource.tableView(tableView, insertRowWith: memo)
    }

    func applyUpdatedMemo(with memo: Memo, at indexPath: IndexPath) {
        memoListDataSource.tableView(tableView, updateRowAt: indexPath, with: memo)
    }

    func applyDeletedMemo(at indexPath: IndexPath) {
        memoListDataSource.tableView(tableView, deleteRowAt: indexPath)
    }
}

// MARK: - Draw View
extension MemoListViewController {
    private func configureTableView() {
        let basicInset = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: .zero,
            right: .zero
        )
        let horizontalMargin: CGFloat = 10

        memoListDelegator = MemoListViewDelegate(owner: self)
        tableView.dataSource = memoListDataSource
        tableView.delegate = memoListDelegator
        tableView.register(
            MemoListViewCell.classForCoder(),
            forCellReuseIdentifier: MemoListViewCell.identifier
        )

        tableView.separatorColor = .darkGray
        tableView.separatorInset = basicInset
        tableView.contentInset = UIEdgeInsets(
            top: .zero,
            left: horizontalMargin,
            bottom: .zero,
            right: -horizontalMargin
        )
    }

    private func configureNavigationTitle() {
        let currentPageTitle = "메모"

        navigationItem.title = currentPageTitle
    }

    private func configureNavigationRightBarButtonItem() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showDetailViewControllerWithBlankPage)
        )

        addButton.accessibilityLabel = "신규 메모 추가"
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func showDetailViewControllerWithBlankPage() {
        delegate?.showDetail(with: nil)
        lastIndexPath = nil
    }
}
