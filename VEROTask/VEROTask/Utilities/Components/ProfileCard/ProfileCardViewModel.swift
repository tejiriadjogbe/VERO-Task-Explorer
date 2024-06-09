//
//  ProfileCardViewModel.swift
//
//
//  Created by Adjogbe  Tejiri on 01/01/2024.
//

public struct ProfileCardViewModel {
    var title: String
    var description: String
    var task: String
    var color: String
    init(title: String = "", description: String = "", task: String = "", color: String = "") {
        self.title = title
        self.description = description
        self.task = task
        self.color = color
    }
}
