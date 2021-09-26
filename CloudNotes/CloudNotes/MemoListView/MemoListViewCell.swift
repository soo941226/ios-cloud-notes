//
//  MemoListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

final class MemoListViewCell: UITableViewCell {
    static let identifier = "MemoListViewCell"

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let dateFormatter = DateFormatter()
    private let half: CGFloat = 0.5

    required init?(coder: NSCoder) {
        fatalError("Error: Cell is created on wrong way")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isAccessibilityElement = true
        accessibilityLabel = ""
        accessibilityValue = ""

        accessoryType = AccessoryType.disclosureIndicator

        dateFormatter.dateFormat = "yyyy.MM.dd."

        configureTitleLabel()
        configureDateLabel()
        configureDescriptionLabel()
        configureLayout()
    }

    func configure(with memo: Memo) {
        let lastUpdatedTime = Date(timeIntervalSince1970: memo.lastUpdatedTime)
        let lastUpdatedDate = dateFormatter.string(from: lastUpdatedTime)

        titleLabel.text = memo.title
        descriptionLabel.text = memo.body
        dateLabel.text = lastUpdatedDate

        accessibilityLabel = "제목: " + memo.title
        accessibilityValue = "발행일: " + lastUpdatedDate
    }

}

// MARK: - Draw View
extension MemoListViewCell {
    private func configureTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.isAccessibilityElement = false
    }

    private func configureDateLabel() {
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateLabel.isAccessibilityElement = false
    }

    private func configureDescriptionLabel() {
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.isAccessibilityElement = false
    }

    private func configureLayout() {
        let innerStackView = createdStackView(
            with: dateLabel, descriptionLabel,
            axis: .horizontal,
            spacing: 12,
            distribution: .fillProportionally,
            alignment: .fill
        )

        let containerStackView = createdStackView(
            with: titleLabel, innerStackView,
            axis: .vertical,
            spacing: 6,
            distribution: .fill,
            alignment: .fill
        )

        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func createdStackView(
        with contents: UIView...,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        alignment: UIStackView.Alignment
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: contents)

        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment

        return stackView
    }
}
