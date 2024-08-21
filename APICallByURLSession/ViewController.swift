//
//  ViewController.swift
//  APICallByURLSession
//
//  Created by sohamp on 21/08/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var sampleTableView: UITableView!
    private var viewModel: ViewModel
    
    // Dependency Injection
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchTodos()
    }
    
    
    private func setupBindings(){
        viewModel.onUpdate = { [weak self] in
            self?.sampleTableView.reloadData()
        }
        viewModel.onError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    
    
    private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todo.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell (style: .subtitle, reuseIdentifier: "cell")
        let todo = viewModel.todo[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.completed ? "Completed" : "Not Completed"
        return cell
    }

}

