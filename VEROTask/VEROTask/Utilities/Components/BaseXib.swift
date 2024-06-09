//
//  BaseXib.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

public class BaseXib: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }
    
    
    func setupXib() {
        if let nibName = getNibName() {
            let nib = UINib(nibName: nibName, bundle: .main)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(view)
            view.frame = self.bounds
        }
    }
    
    func updateHeight() {
        constraints.filter({$0.firstAnchor == heightAnchor }).forEach{ $0.isActive = false }
        setNeedsDisplay()
    }
    
    func getNibName() -> String? { String(describing: Self.self) }
    func getContentView() -> UIView? { nil }
    func sizeToContent()-> Bool { false }
}

