//
//  AppAppearance.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit
import Toast

final class AppAppearance {

    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        let backImage = UIImage(named: "backNarrow")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().barTintColor = .label

        var style = ToastStyle()
        style.messageFont = .body4R12
        style.messageColor = .white
        style.backgroundColor = .black
        style.titleAlignment = .center
        ToastManager.shared.style = style
    }
}
