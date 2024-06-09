//
//  ProfileCardView.swift
//
//
//  Created by Adjogbe  Tejiri on 01/01/2024.
//

import UIKit

public class ProfileCardView: BaseXib {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var taskdecription: RegularLabel!
    @IBOutlet weak var title: SemiBoldLabel!
    @IBOutlet weak var task: SemiBoldLabel!
    
    public var model: ProfileCardViewModel = ProfileCardViewModel() {
        didSet {
            setup()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        colorView.layer.cornerRadius = 25
        colorView.backgroundColor = UIColor(hex: model.color)
        title.text = model.title
        taskdecription.text = model.description
        task.text = model.task
    }
}

