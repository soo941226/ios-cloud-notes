//
//  CloudNotes - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        setWindow(with: windowScene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (window?.rootViewController as? SplitViewController)?.saveContext()
    }

    private func setWindow(with windowScene: UIWindowScene) {
        let splitViewController = SplitViewController(style: .doubleColumn)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
    }

}
