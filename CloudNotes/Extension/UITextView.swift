//
//  UITextView.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/05.
//

import UIKit

extension UITextView {
    func clear() {
        self.accessibilityLabel = nil
        self.accessibilityValue = nil
        self.text = nil
    }
}
