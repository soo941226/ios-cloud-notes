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
    
    private func presentAlertForDelete() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { action in
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func showActionSheet(_ sender: Any) {
        let editAction = UIAlertAction(title: "Share...", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            self.presentAlertForDelete()
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        presentAlertForActionSheet(isCancelActionIncluded: true, preferredStyle: .actionSheet, with: editAction,deleteAction)
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
        self.memoTextView.font = self.memoTextView.font?.withSize(20)
        NSLayoutConstraint.activate([
            self.memoTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            self.memoTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.memoTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            self.memoTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
        ])
    }

    func configure(with memo: Memo, indexPath: IndexPath) {
        memoTextView.resignFirstResponder()
        memoTextView.text = "\n\n" + memo.computedTitle + "\n\n" + memo.computedBody
        self.indexPath = indexPath
    }
}

extension DetailMemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let indexPath = self.indexPath else {
            return
        }
        var text = textView.text.components(separatedBy: "\n")
        while text[0] == "" {
            text.remove(at: 0)
        }
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedTitle = text.remove(at: 0)
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedBody = text.joined()
        JsonDataCache.shared.decodedJsonData[indexPath.row].computedlastModifiedDate = Int(Date().timeIntervalSince1970)
        memoListViewController?.tableView.reloadData()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}


