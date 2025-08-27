//
//  TabBarController.swift
//  Tamagochiz
//
//  Created by Lee on 8/25/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var firstVC = UIViewController()
    var secondVC = LottoViewController()
    var thirdVC = BoxOfficeViewController()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupTapBarUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let tamagochi = UserDefaultsManager.getData().tamagochi

        if tamagochi == 0 {
            let vc = TamagochiViewController()
            let nav = UINavigationController(rootViewController: vc)
            firstVC = nav
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
            let nav = UINavigationController(rootViewController: vc)
            firstVC = nav
        }

    }

    private func setupTapBarUI() {
        firstVC.tabBarItem = UITabBarItem(title: "First", image: UIImage(systemName: "lasso.badge.sparkles"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "LOTTO", image: UIImage(systemName: "l.circle"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "BOXOFFICE", image: UIImage(systemName: "popcorn.circle"), tag: 2)

        viewControllers = [firstVC, secondVC, thirdVC]
    }

}
