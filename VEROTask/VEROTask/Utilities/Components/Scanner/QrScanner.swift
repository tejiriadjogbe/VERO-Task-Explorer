//
//  Scanner.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import UIKit
import AVFoundation

class QrScanner: BaseXib {
    @IBOutlet weak var flipBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var scannerView: UIView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoCaptureDevice: AVCaptureDevice!
    var onCompleted: (String) -> Void = { _ in }
    var onError: (String, String) -> Void = {_, _ in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setupSession()
        layer.cornerRadius = 10
        flipBtn.setTitle("", for: .normal)
        flashBtn.setTitle("", for: .normal)
    }
    
    @IBAction func flashTapped(_ sender: Any) {
        toggleFlash()
    }
    
    @IBAction func flipTapped(_ sender: Any) {
        flipCamera()
    }
    
    deinit {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
}

extension QrScanner: AVCaptureMetadataOutputObjectsDelegate {
    func setupSession() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scannerView.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.captureSession.startRunning()
        }
    }
    
    func failed() {
        onError("Scanning not supported", "Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            onCompleted(stringValue)
        }
    }
    
    func found(code: String) {
        print(code)
    }
    
    func flipCamera() {
        guard let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        
        let newDevice: AVCaptureDevice?
        if currentInput.device.position == .back {
            newDevice = camera(with: .front)
        } else {
            newDevice = camera(with: .back)
        }
        
        guard let device = newDevice else {
            captureSession.commitConfiguration()
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: device)
            captureSession.removeInput(currentInput)
            
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            } else {
                captureSession.addInput(currentInput)
            }
        } catch {
            captureSession.addInput(currentInput)
        }
        
        captureSession.commitConfiguration()
    }

    func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        return devices.first { $0.position == position }
    }
    
    func toggleFlash() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }

        if videoCaptureDevice.hasTorch {
            do {
                try videoCaptureDevice.lockForConfiguration()
                if videoCaptureDevice.torchMode == .on {
                    videoCaptureDevice.torchMode = .off
                } else {
                    try videoCaptureDevice.setTorchModeOn(level: 1.0)
                }
                videoCaptureDevice.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
