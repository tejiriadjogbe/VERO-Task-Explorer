//
//  UIView+Extension.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

public extension UIView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
