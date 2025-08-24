//
//  SceneDelegate.swift
//  Tamagochiz
//
//  Created by Lee on 8/22/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let nickname = UserDefaults.standard.string(forKey: "nickname")

        //TODO: 분기 로직 수정 필요. "게스트"로 설정해두고 트리거로 쓰는 방식이 좋은 구조가 아님, 닉네임 설정을 하지 않고 넘어가면 자동으로 '대장'으로 설정됨
        if nickname == "게스트" {
            let vc = TamagochiViewController()
            let nav = UINavigationController(rootViewController: vc)
            //TODO: 이 설정 로직이 sceneDelegate에 있는게 적절한지 고민 필요
            UserDefaults.standard.set("대장", forKey: "nickname")
            window?.rootViewController = nav
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainViewController")
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

