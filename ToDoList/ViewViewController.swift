//
//  ViewViewController.swift
//  ToDoList
//
//  Created by Sasha on 21.02.2021.
//
import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    
    public var item: TodoListItem?
    private let realm = try! Realm();
    
    public var deletionHandler: (()-> Void)?;
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .medium;
        return dateFormatter;
    }()
    
    @IBOutlet var itemLabel: UILabel!;
    @IBOutlet var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = item?.item;
        print("Formatted", Self.dateFormatter.string(from: item!.date))
        dateLabel.text = Self.dateFormatter.string(from: item!.date);
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItem))
        // Do any additional setup after loading the view.
    }
    
    @objc func removeItem(){
        guard let currentItem = self.item else {
            return
        }
        
        realm.beginWrite();
        realm.delete(currentItem);
        
        try! realm.commitWrite();
        
        deletionHandler?();
        
        navigationController?.popToRootViewController(animated: true)
    }

}
