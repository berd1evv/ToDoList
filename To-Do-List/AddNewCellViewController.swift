//
//  AddNewCellViewController.swift
//  To-Do-List
//
//  Created by Eldiiar on 1/3/22.
//

import UIKit


class AddNewCellViewController: UIViewController  {
    
    var list = [ToDoListModel]()
    
    var textValue: String = ""
    
    let textField1: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text here!"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let textField2: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text here!"
        textField.textAlignment = .natural
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
                
        view.addSubview(textField1)
        view.addSubview(textField2)
        
        textField1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(340)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(340)
            make.height.equalTo(450)
        }
    }
    
    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonPressed() {
        list.append(ToDoListModel(title: textField1.text ?? "", description: textField2.text ?? ""))
        let name = Notification.Name("addNotification")
        NotificationCenter.default.post(name: name, object: list)

        
        dismiss(animated: true, completion: nil)
    }
}
