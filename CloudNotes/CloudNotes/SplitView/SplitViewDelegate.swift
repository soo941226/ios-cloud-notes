//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

final class SplitViewDelegate: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
