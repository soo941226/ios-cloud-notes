//
//  MemoListTableViewController.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    weak var delegate: MemoListSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        fetchMemo()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo))
    }
    
    private func setupTableView() {
        self.tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "memoCell")
    }

    // 메모 추가 버튼 클릭
    @objc func addMemo() {
        // 빈 메모 생성
        saveMemo()
        // 빈 메모로 textView 변경
        moveToMemoDetailViewController(with: MemoModel.shared.list.startIndex)
        // 빈 메모 cell 추가
        insertFirstCell()
    }
    
    private func moveToMemoDetailViewController(with memoIndex: Int) {
        if let memoDetailViewController = delegate as? MemoDetailViewController,
           (traitCollection.horizontalSizeClass == .compact && traitCollection.userInterfaceIdiom == .phone) {
            memoDetailViewController.index = memoIndex
            let memoDetailNavigationController = UINavigationController(rootViewController: memoDetailViewController)
            splitViewController?.showDetailViewController(memoDetailNavigationController, sender: nil)
        }
    }
    
    // MARK: MemoModel Method
    private func saveMemo() {
        do {
            try MemoModel.shared.save(title: nil, body: nil)
        } catch {
            showError(MemoError.saveMemo, okHandler: nil)
        }
    }
    
    private func fetchMemo() {
        do {
            try MemoModel.shared.fetch()
            self.tableView.reloadData()
            if MemoModel.shared.list.count > 0 {
                self.delegate?.memoCellSelect(MemoModel.shared.list.startIndex)
            }
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoModel.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.setupMemoCell(with: MemoModel.shared.list[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.memoCellSelect(indexPath.row)
        self.moveToMemoDetailViewController(with: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, _) in
            self.deleteMemoObject(with: indexPath.row)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteMemoObject(with index: Int) {
        do {
            try MemoModel.shared.delete(index: index)
            self.deleteMemo(indexRow: index)
        } catch {
            self.showError(error, okHandler: nil)
        }
    }
}

extension MemoListTableViewController: MemoDetailDelegate {
    func insertFirstCell() {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func deleteMemo(indexRow: Int) {
        self.tableView.deleteRows(at: [IndexPath(row: indexRow, section: 0)], with: .automatic)
    }
    
    func updateMemo(indexRow: Int) {
        self.tableView.moveRow(at: IndexPath(row: indexRow, section: 0), to: IndexPath(row: 0, section: 0))
        self.tableView.reloadRows(at: [IndexPath(row: indexRow, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    func addEmptyMemo() {
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
}

protocol MemoListSelectDelegate: class {
    func memoCellSelect(_ index: Int?)
    func addMemo()
}
