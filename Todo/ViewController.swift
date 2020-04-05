//
//  ViewController.swift
//  Todo
//
//  Created by ThinksysUser on 06/04/20.
//  Copyright © 2020 Littra. All rights reserved.
//

import UIKit
import FirebaseDatabase
//import

struct Todo {
    let text: String;
    
    func convert() -> NSDictionary {
        return ["text":text]
    }
}

class ViewController: UIViewController {

    @IBOutlet var TodoInput: UITextField!
    @IBAction func TodButtonClicked(_ sender: Any) {
        if(TodoInput.hasText){
            let text = TodoInput.text
            ref.child("todo").childByAutoId().setValue(Todo(text:text!).convert())
        }
    }
    @IBOutlet var TodoListView: UITableView!
    var todos: [Todo] = []
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TodoListView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        ref.child("todo").observe(.childAdded, with: {(snapshot) -> Void in
            if let value = snapshot.value {
                let o = value as! NSDictionary
                if let text = o.value(forKey: "text"){
                    self.todos.append(Todo(text:text as! String))
                    self.TodoListView.reloadData()
                }
                
            }
        })
    }


}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].text
        return cell
    }
}

