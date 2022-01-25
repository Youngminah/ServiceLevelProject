//
//  AppAppearance.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/19.
//

import UIKit

final class AppAppearance {

    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        //appearance.backButtonAppearance = UIBarButtonItemAppearance().
        let backImage = UIImage(named: "backNarrow")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .label
        UINavigationBar.appearance().barTintColor = .label
    }
}
