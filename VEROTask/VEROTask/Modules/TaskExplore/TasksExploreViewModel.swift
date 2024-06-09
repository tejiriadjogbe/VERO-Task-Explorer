//
//  ExploreViewModel.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//

import Foundation
import Combine
import Network

class TasksExploreViewModel {
    var service = BauBuddyServiceImpl()
    var taskData: [TaskResponse]?
    
    enum Input {
        case getTasks
    }
    
    enum Output {
        case getTasksFailed(ErrorResponse)
        case getTasksSuccess
    }
    
    var output = PassthroughSubject<Output, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    func transform(input: PassthroughSubject<Input, Never>) {
        let cancellable = input.sink { [weak self] event in
            switch event {
            case .getTasks:
                self?.getTasks()
            }
        }
        cancellable.store(in: &cancellables)
    }
    
    func getTasks() {
        service.getTasks {[weak self] result in
            switch result {
            case .success(let data):
                self?.taskData = data
                self?.output.send(.getTasksSuccess)
            case .failure(let error):
                self?.output.send(.getTasksFailed(error))
            }
        }
    }
}
