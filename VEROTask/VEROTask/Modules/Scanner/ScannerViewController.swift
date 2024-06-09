//
//  ScannerViewController.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var qrView: QrScanner!
    
    var onCompleted: (String) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("", for: .normal)
        qrView.onCompleted = { [weak self] in
            self?.onCompleted($0)
            self?.dismiss(animated: true)
        }
    }

    @IBAction func onDismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
