//
//  ViewController.swift
//  To-Do-List
//
//  Created by Eldiiar on 28/2/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var list: [String] = ["To wash Dishes", "To take a shower", "To do a homework"]
    var detailList: [String] = ["fdfdfd", "dfdfdf", "dfdfd"]
    
    var listId = 0
    var listId2 = 0
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
    let addNotification2 = Notification.Name("addNotification2")
    let editNotification = Notification.Name("editNotification")
    let editNotification2 = Notification.Name("editNotification2")
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "To Do List"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.navigationBar.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        tableView.allowsMultipleSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(label)
        view.addSubview(tableView)
        view.addSubview(editButton)
        view.addSubview(addButton)
        
        createObservers()
        
        setUpConstraints()
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(addScreen(notification:)), name: addNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addScreen2(notification:)), name: addNotification2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editScreen(notification:)), name: editNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editScreen2(notification:)), name: editNotification2, object: nil)
    }
    
    @objc func addScreen(notification: NSNotification) {
        let name: [String] = notification.object as! [String]
        list.insert(contentsOf: name, at: list.endIndex)
        tableView.reloadData()
    }
    
    @objc func addScreen2(notification: NSNotification) {
        let name: [String] = notification.object as! [String]
        detailList.insert(contentsOf: name, at: detailList.endIndex)
        tableView.reloadData()
    }
    
    @objc func editScreen(notification: NSNotification) {
        let name: String = notification.object.unsafelyUnwrapped as! String
        list[listId] = name
        tableView.reloadData()
    }
    
    @objc func editScreen2(notification: NSNotification) {
        let name: String = notification.object.unsafelyUnwrapped as! String
        detailList[listId] = name
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
    }
    
    @objc func addButtonTapped() {
        let destination = AddNewCellViewController()
        let navCon = UINavigationController(rootViewController: destination)
        navCon.modalTransitionStyle = .crossDissolve
        navCon.modalPresentationStyle = .overCurrentContext
        present(navCon, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }
        cell?.accessoryType = .detailDisclosureButton
        cell?.textLabel?.text = list[indexPath.row]
        cell?.detailTextLabel?.text = detailList[indexPath.row]
        cell?.imageView?.image = UIImage(systemName: "checkmark.circle")
        cell?.imageView?.tintColor = .systemYellow
        return cell!
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let destination = EditCellViewController()
        let navCon = UINavigationController(rootViewController: destination)
        navCon.modalTransitionStyle = .crossDissolve
        navCon.modalPresentationStyle = .overCurrentContext
        if let i = self.list.firstIndex(of: self.list[indexPath.row]) {
            destination.textField1.text = list[i]
            listId = i
        }
        if let i = self.detailList.firstIndex(of: self.detailList[indexPath.row]) {
            destination.textField2.text = detailList[i]
            
        }
        present(navCon, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.imageView?.image == UIImage(systemName: "checkmark.circle") {
                cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
            }
            else{
                cell.imageView?.image = UIImage(systemName: "checkmark.circle")
            }
        }
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

