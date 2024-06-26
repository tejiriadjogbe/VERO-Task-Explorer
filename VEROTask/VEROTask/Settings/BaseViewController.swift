//
//  BaseViewController.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

class BaseViewController: UIViewController {
    let navigationBarAppearance = UINavigationBarAppearance()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.setBackIndicatorImage(Assets.backSpaced.image, transitionMaskImage: Assets.backSpaced.image)
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.backgroundImage = nil
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        navigationBarAppearance.titleTextAttributes = [
            .font: Fonts.getFont(name: .Bold, 20),
            .foregroundColor: UIColor.black,
            ]
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.backIndicatorImage = Assets.backSpaced.image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = Assets.backSpaced.image
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-4.5, for: .default)
        
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // Handle the OK button tap (if needed)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
