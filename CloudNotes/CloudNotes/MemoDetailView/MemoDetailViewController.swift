//
//  MemoDetailViewController.swift
//  CloudNotes
//
//  Created by kjs on 2021/08/31.
//

import UIKit

final class MemoDetailViewController: UIViewController {

    private let textView = UITextView()
    private var textViewBottomAnchor: NSLayoutConstraint?
    private var textViewHeightAnchor: NSLayoutConstraint?
    private var dispatchItemToUpdateMemo: DispatchWorkItem?

    private var isCreatingNewMemo = false {
        didSet {
            if isCreatingNewMemo {
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }

    weak var delegate: DetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground

        textView.delegate = self

        configureActionButton()
        configureTextView()
        configureKeyboardSetting()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        resetOffsetOfTextViewWithLock()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        unlockTextView()
    }

    func configure(with memo: Memo?) {
        guard let memo = memo else {
            textView.clear()
            isCreatingNewMemo = true
            return
        }

        let titlePrefix = "제목 : "
        let descriptionPrefix = "내용 : "
        let doubledNewLine = "\n\n"

        textView.accessibilityLabel = titlePrefix + memo.title
        textView.accessibilityValue = descriptionPrefix + memo.body
        textView.text = memo.title + doubledNewLine + memo.body

        isCreatingNewMemo = false
    }
}

// MARK: - TextView Delegate
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard !isCreatingNewMemo else {
            return
        }

        dispatchItemToUpdateMemo?.cancel()
        dispatchItemToUpdateMemo = DispatchWorkItem(block: updateMemo)
        guard let dispatchItemToUpdateMemo = dispatchItemToUpdateMemo else {
            return
        }

        let delay = 0.3
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay,
            execute: dispatchItemToUpdateMemo
        )
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard isCreatingNewMemo else {
            return
        }

        updateMemo()
        delegate?.showList()
    }

    private func updateMemo() {
        let separator = "\n\n"
        var outputStrings = textView.text.components(separatedBy: separator)

        guard let titleText = outputStrings.first,
              titleText.isEmpty == false else {
            delegate?.update(with: nil)
            return
        }

        let title = outputStrings.removeFirst().description
        let description = outputStrings.joined(separator: separator)
        let now = Date().timeIntervalSince1970
        let memo = Memo(title: title, body: description, lastUpdatedTime: now)
        delegate?.update(with: memo)
    }
}

// MARK: - Keyboard setting
extension MemoDetailViewController {
    private func configureKeyboardSetting() {
        let keyboardToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(closeKeyboard)
        )
        keyboardToolbar.items = [doneButton]
        keyboardToolbar.sizeToFit()
        textView.inputAccessoryView = keyboardToolbar

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openKeyboard),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(closeKeyboard),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }

    @objc private func closeKeyboard() {
        textViewHeightAnchor?.isActive = false
        textViewBottomAnchor?.isActive = true
        textView.endEditing(true)

        if let heightAnchor = textViewHeightAnchor {
            textView.removeConstraint(heightAnchor)
        }
    }

    @objc private func openKeyboard(_ notification: NSNotification) {
        let keyboardKey = UIWindow.keyboardFrameEndUserInfoKey
        guard let keyboard = notification.userInfo?[keyboardKey] as? NSValue else {
            return
        }

        let textViewTargetHeight = view.safeAreaLayoutGuide.layoutFrame.height - keyboard.cgRectValue.height

        textViewBottomAnchor?.isActive = false
        textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: textViewTargetHeight)
        textViewHeightAnchor?.isActive = true
    }
}

// MARK: - Draw View
extension MemoDetailViewController {
    private func resetOffsetOfTextViewWithLock() {
        let beginnningPosition = textView.beginningOfDocument
        textView.isScrollEnabled = false
        textView.selectedTextRange = textView.textRange(from: beginnningPosition, to: beginnningPosition)
    }

    private func unlockTextView() {
        textView.isScrollEnabled = true
    }

    private func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        view.addSubview(textView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        textViewBottomAnchor = textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        textViewHeightAnchor?.isActive = false
        textViewBottomAnchor?.isActive = true
    }

    private func configureActionButton() {
        let circleImage = UIImage(systemName: "ellipsis.circle")
        let moreButton = UIBarButtonItem(
            image: circleImage,
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )

        moreButton.accessibilityValue = "메모 관리"
        navigationItem.rightBarButtonItem = moreButton
    }

    @objc private func showActionSheet() {
        delegate?.showActionSheet()
    }
}
