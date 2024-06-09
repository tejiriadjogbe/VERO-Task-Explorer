//
//  WelcomeViewController.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//


import UIKit
import Combine

class WelcomeViewController: BaseViewController {
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var slider: Slider!
    
    var coordinator: AppCoordinator?
    
    let vm = WelcomeViewModel()
    let input = PassthroughSubject<WelcomeViewModel.Input, Never>()
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        bindVm()
    }
    
    @IBAction func getStartedTapped(_ sender: Any) {
        LoadingModal.show(title: "Anmeldeanfrage wird ausgeführt...")
        input.send(.login)
    }
    
    func setupSlider() {
        let sliderModels = [
            ImageDescriptionViewModel(
                tilte: "Willkommen bei BauBuddy",
                subtitle: "Nahtlos erkunden, zusammenarbeiten und Ihre Projekte aufwerten",
                image: Assets.slider1.image),
            ImageDescriptionViewModel(
                tilte: "Möglichkeiten erkunden",
                subtitle: "Navigieren, zusammenarbeiten und mit BauBuddy kreieren",
                image: Assets.slider2.image),
            ImageDescriptionViewModel(
                tilte: "Verbessern Sie Ihre BauBuddy-Reise",
                subtitle: "Mühelose Innovation und Zusammenarbeit erwartet Sie mit BauBuddy",
                image: Assets.slider3.image)
        ]
        
        let views = sliderModels.map {
            let sliderPage = ImageDescriptionView(frame: slider.bounds)
            sliderPage.model = $0
            return sliderPage
        }
        
        slider.configure(with: views, pageControl: pageCtrl)
    }
}

extension WelcomeViewController {
    func bindVm() {
        vm.transform(input: input)
        cancellable = vm.output.receive(on: DispatchQueue.main).sink {[weak self] event in
            LoadingModal.dismiss()
            switch event {
            case .loginSuccess:
                self?.coordinator?.goToTasks()
            case .loginFailed(let error):
                self?.showAlert(title: "Error", message: error.message)
            }
        }
    }
}
