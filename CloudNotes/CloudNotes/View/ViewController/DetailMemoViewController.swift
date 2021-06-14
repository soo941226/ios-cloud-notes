//
//  DetailMemoViewController.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/01.
//

import UIKit

class DetailMemoViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var memoTextView = UITextView()
    var memoMain = UITextView()
    var indexPath: IndexPath?
    var memoListViewController: MemoListViewController?
    
    lazy var rightNvigationItem: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        memoTextView.delegate = self
        memoTextView.contentInsetAdjustmentBehavior = .automatic
        memoTextView.textAlignment = NSTextAlignment.justified
        memoTextView.contentOffset = CGPoint(x: 0,y: 0)
    }
    
    private func presentAlertForActionSheet(
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .actionSheet,
                      with actions: UIAlertAction ...) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteMemo(indexPath: IndexPath) {
        CoreData.shared.deleteMemoListItem(item: MemoCache.shared.memoData[indexPath.row])
        DropboxManager.shared.uploadData(files: CoreData.shared.persistenceSqliteFiles, directoryURL: CoreData.shared.directoryURL)
        self.memoListViewController?.tableView.reloadData()
        self.configure(with: nil, indexPath: nil)
    }
    
    private func presentAlertForDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            self?.deleteMemo(indexPath: indexPath)
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func shareMemo(indexPath: IndexPath) {
        let activity = UIActivityViewController(activityItems: [self.memoTextView.text], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    
    @objc private func showActionSheet(_ sender: Any) {
        guard let indexPath = self.indexPath else {
            return
        }
        let editAction = UIAlertAction(title: "Share...", style: .default) { [weak self] action in
            self?.shareMemo(indexPath: indexPath)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            self?.presentAlertForDelete(indexPath: indexPath)
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        presentAlertForActionSheet(isCancelActionIncluded: true, preferredStyle: .actionSheet, with: editAction, deleteAction)
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNvigationItem)
        self.view.addSubview(memoTextView)
        setUpMemoTextView()
    }
        
    private func setUpMemoTextView() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.memoTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            self.memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
        ])
    }

    func configure(with memo: MemoListItem?, indexPath: IndexPath?) {
        memoTextView.contentOffset = CGPoint(x: 0,y: 0)
        guard let memo = memo, let allText = memo.allText else {
            memoTextView.text = ""
            return
        }
        guard let indexPath = indexPath else {
            return
        }
        memoTextView.text = allText
        self.indexPath = indexPath
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        var title = ""
        var body = ""
        guard let indexPath = self.indexPath else {
            return
        }
        guard let allText = textView.text else {
            return
        }
        var text = textView.text.components(separatedBy: "\n")
        guard text.count > 0 else {
            updateMemoData(indexPath: indexPath, title: "", body: "", allText: allText)
            return
        }
        while text[0] == "" {
            text.remove(at: 0)
            if text.count == 0 {
                updateMemoData(indexPath: indexPath, title: "", body: "", allText: allText)
                return
            }
        }
        title = text.remove(at: 0)
        while text.count > 0, text[0] == "" {
            text.remove(at: 0)
            if text.count == 0 {
                updateMemoData(indexPath: indexPath, title: title, body: "", allText: allText)
                return
            }
        }
        body = text.joined(separator: "\n")
        updateMemoData(indexPath: indexPath, title: title, body: body, allText: allText)
    }
    
    private func updateMemoData(indexPath: IndexPath, title: String, body: String, allText: String) {
        MemoCache.shared.memoData[indexPath.row].title = title
        MemoCache.shared.memoData[indexPath.row].body = body
        MemoCache.shared.memoData[indexPath.row].lastModifiedDate = Date()
        MemoCache.shared.memoData[indexPath.row].allText = allText
        memoListViewController?.tableView.reloadData()
        CoreData.shared.updateMemoListItem(item: MemoCache.shared.memoData[indexPath.row])
        DropboxManager.shared.uploadData(files: CoreData.shared.persistenceSqliteFiles, directoryURL: CoreData.shared.directoryURL)
    }
}

