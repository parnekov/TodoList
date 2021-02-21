//
//  ViewController.swift
//  ToDoList
//
//  Created by Sasha on 21.02.2021.
//
import RealmSwift
import UIKit

class TodoListItem: Object {
    @objc dynamic var item: String = "";
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm();
    private var data = [TodoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad();
        
        data = realm.objects(TodoListItem.self).map({$0});
        // Do any additional setup after loading the view.
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self;
        table.dataSource = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        cell.textLabel?.text = data[indexPath.row].item
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let item = data[indexPath.row]
        // Open the screen where we can see the item
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return;
        };
        
        vc.item = item;
        vc.deletionHandler = {
            [weak self] in self?.refresh();
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never;
        
        vc.title = item.item;
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTabAddButton (){
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController  else {
            return;
        }
        vc.completetionHandler = {
            [weak self] in self?.refresh()
        }
        vc.title = "New Item";
        vc.navigationItem.largeTitleDisplayMode = .never;
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh () {
        data = realm.objects(TodoListItem.self).map({$0});
        table.reloadData();
    }


}

