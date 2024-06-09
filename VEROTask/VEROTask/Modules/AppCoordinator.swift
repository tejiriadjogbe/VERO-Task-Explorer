//
//  AppCoordinator.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    override func start() {
        goToWelcome()
    }
    
    func goToWelcome() {
        let vc: WelcomeViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func goToTasks() {
        let vc: TasksExploreViewController = .fromNib()
        vc.coordinator = self
        navigationController = BaseNavigationController(rootViewController: vc)
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    func launchScanner(_ callback: @escaping (String) -> Void) {
        let vc: ScannerViewController = .fromNib()
        vc.onCompleted = callback
        vc.modalPresentationStyle = .fullScreen
        present(viewController: vc)
    }
}
