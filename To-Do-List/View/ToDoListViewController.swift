//
//  ViewController.swift
//  To-Do-List
//
//  Created by Eldiiar on 28/2/22.
//

import UIKit
import SnapKit

class ToDoListViewController: UIViewController {
    
    private var viewModel: ToDoListProtocol
    
    init(vm: ToDoListProtocol = ToDoListViewModel()) {
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Create a new list by tapping on add button"
        label.textColor = .black
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 25
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var tableView = UITableView()
    
    let addNotification = Notification.Name("addNotification")
    let editNotification = Notification.Name("editNotification")
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isEditing = false
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        view.addSubview(label)
        view.addSubview(editButton)
        view.addSubview(addButton)
        
        createObservers()
        setUpConstraints()
        
        viewModel.model.append(ToDoListModel(title: "To wash Dishes", description: "ASAP"))
        viewModel.model.append(ToDoListModel(title: "To take a shower", description: "After the lunch"))
        viewModel.model.append(ToDoListModel(title: "To do a homework", description: "Math, English"))
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addScreen(notification:)), name: addNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editScreen(notification:)), name: editNotification, object: nil)
    }
    
    @objc func addScreen(notification: NSNotification) {
        let name: [ToDoListModel] = notification.object as! [ToDoListModel]
        viewModel.model += name
        tableView.reloadData()
    }

    
    @objc func editScreen(notification: NSNotification) {
        let name: ToDoListModel = notification.object.unsafelyUnwrapped as! ToDoListModel
        viewModel.model[viewModel.listId] = name
        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(editing, animated: true)
    }
    
    @objc func editButtonTapped() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addButton.isHidden = false
        } else {
            tableView.setEditing(true, animated: true)
            editButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            addButton.isHidden = true
        }
        
    }
    
    @objc func addButtonTapped() {
        let destination = AddNewCellViewController()
        let navCon = UINavigationController(rootViewController: destination)
        navCon.modalTransitionStyle = .crossDissolve
        navCon.modalPresentationStyle = .overCurrentContext
        present(navCon, animated: true, completion: nil)
    }

    
    func setUpConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(addButton.snp.top).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }

}

// MARK: TableView

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            viewModel.model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if viewModel.model.count == 0 {
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = viewModel.model[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }
        label.isHidden = true
        cell?.accessoryType = .detailDisclosureButton
        cell?.textLabel?.text = index.title
        cell?.detailTextLabel?.text = index.description
        cell?.imageView?.image = index.checkmark ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        cell?.imageView?.tintColor = .systemYellow
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destination = EditCellViewController()
        let navCon = UINavigationController(rootViewController: destination)
        navCon.modalTransitionStyle = .crossDissolve
        navCon.modalPresentationStyle = .overCurrentContext
        destination.textField1.text = viewModel.model[indexPath.row].title
        destination.textField2.text = viewModel.model[indexPath.row].description
        destination.viewModel.isRead = viewModel.model[indexPath.row].checkmark
        viewModel.listId = indexPath.row
        
        present(navCon, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = viewModel.model[sourceIndexPath.row]
        viewModel.model.remove(at: sourceIndexPath.row)
        viewModel.model.insert(movedObject, at: destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.model[indexPath.row].checkmark {
            viewModel.model[indexPath.row].checkmark = false
        } else {
            viewModel.model[indexPath.row].checkmark = true
        }
        tableView.reloadData()
    }
}
