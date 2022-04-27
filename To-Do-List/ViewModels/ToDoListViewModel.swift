//
//  ToDoListViewModel.swift
//  To-Do-List
//
//  Created by Eldiiar on 27/4/22.
//

import Foundation

protocol ToDoListProtocol {
    var model: [ToDoListModel] { get set }
    var listId: Int { get set }
}

class ToDoListViewModel: ToDoListProtocol {
    var model: [ToDoListModel] = []
    var listId = 0
    
}
