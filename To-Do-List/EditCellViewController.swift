//
//  EditCellViewController.swift
//  To-Do-List
//
//  Created by Eldiiar on 1/3/22.
//

import UIKit

class EditCellViewController: UIViewController, UITextFieldDelegate  {
    
    var isRead = false
    
    let textField1: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text here!"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let textField2: UITextView = {
        let textField = UITextView()
        textField.textAlignment = .natural
        textField.font = .systemFont(ofSize: 17)
        textField.layer.borderWidth = 0.1
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
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
        let list = ToDoListModel(title: textField1.text ?? "", description: textField2.text ?? "", checkmark: isRead)
        let name1 = Notification.Name("editNotification")
        NotificationCenter.default.post(name: name1, object: list)
        
        dismiss(animated: true, completion: nil)
    }
}
