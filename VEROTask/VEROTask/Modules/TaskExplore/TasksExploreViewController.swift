//
//  TasksExploreViewController.swift
//  VEROTask
//
//  Created by Adjogbe  Tejiri on 09/06/2024.
//


import UIKit
import Combine

class TasksExploreViewController: BaseViewController {
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var searchField: SearchInputView!
    @IBOutlet weak var profileListView: ListView!
    
    private var refreshControl = UIRefreshControl()
    var filteredTaskData: [TaskResponse]?
    
    let vm = TasksExploreViewModel()
    let input = PassthroughSubject<TasksExploreViewModel.Input, Never>()
    var cancellable: AnyCancellable?
    
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupPulltoRefresh()
        loadTasks()
        setupSearchField()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func dismissKeyboard() {
        searchField.resignFirstResponder()
    }
    
    func onScanCompleted(code: String) {
        searchField.text = code
        handleFilter(code)
    }
    
    func loadTasks() {
        LoadingModal.show(title: "Aufgaben werden geladen...")
        input.send(.getTasks)
    }
    
    func setupPulltoRefresh() {
        refreshControl.tintColor = .AppPrimary
        scrollview.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    func setupSearchField() {
        searchField.qrTapped = { [weak self] in
            self?.coordinator?.launchScanner(self!.onScanCompleted)
        }
        
        searchField.textChanged = { [weak self] textField, range, string in
            let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            self?.handleFilter(searchText)
        }
    }
    
    func handleFilter(_ text: String) {
        let titleFilter = vm.taskData?.filter({
            if let title = $0.title?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
        
        let taskFilter = vm.taskData?.filter({
            if let title = $0.task?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
        
        let descriptionFilter = vm.taskData?.filter({
            if let title = $0.description?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
        
        let wageFilter = vm.taskData?.filter({
            if let title = $0.wageType?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
        
        let busUnitFilter = vm.taskData?.filter({
            if let title = $0.businessUnit?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
        
        var uniqueData = Set(titleFilter ?? [])
        uniqueData.formUnion(taskFilter ?? [])
        uniqueData.formUnion(descriptionFilter ?? [])
        uniqueData.formUnion(wageFilter ?? [])
        uniqueData.formUnion(busUnitFilter ?? [])
        
        filteredTaskData = Array(uniqueData)
        
        if text.isEmpty {
            initListView(with: vm.taskData)
        } else {
            initListView(with: filteredTaskData)
        }
    }
    
    func filterItem(_ text: String) -> [TaskResponse] {
        guard let taskData = vm.taskData else { return [] }
        return taskData.filter({
            if let title = $0.title?.lowercased() {
                return title.contains(text.lowercased())
            }
            return false
        })
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadTasks()
    }
    
    func initListView(with data: [TaskResponse]?) {
        if let data = data {
            var model = ListViewModel()
            model.count = data.count
            model.height = 92
            model.cellForRowAt = { cell, index in
                let profileCard = ProfileCardView(frame: cell.bounds)
                let cardModel = ProfileCardViewModel(
                    title: data[index.row].title ?? "",
                    description: data[index.row].description ?? "",
                    task: data[index.row].task ?? "",
                    color: data[index.row].colorCode ?? ""
                )
                profileCard.model = cardModel
                cell.applyView(view: profileCard)
                return cell
            }
            profileListView.model = model
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

extension TasksExploreViewController {
    func bind() {
        vm.transform(input: input)
        cancellable = vm.output.receive(on: DispatchQueue.main).sink {[weak self] event in
            LoadingModal.dismiss()
            switch event {
            case .getTasksSuccess:
                self?.refreshControl.endRefreshing()
                self?.initListView(with: self?.vm.taskData)
            case .getTasksFailed(let error):
                self?.refreshControl.endRefreshing()
                self?.showAlert(title: "Error", message: error.message)
            }
        }
    }
}
