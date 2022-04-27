//
//  AddNewCellViewModel.swift
//  To-Do-List
//
//  Created by Eldiiar on 27/4/22.
//

import Foundation

protocol AddNewCellProtocol {
    var list: [ToDoListModel] { get set }
}

class AddNewCellViewModel: AddNewCellProtocol {
    var list = [ToDoListModel]()
    
}
