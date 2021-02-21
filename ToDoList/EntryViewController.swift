//
//  EntryViewController.swift
//  ToDoList
//
//  Created by Sasha on 21.02.2021.
//
import RealmSwift
import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    private let realm = try! Realm();
    public var completetionHandler: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder();
        textField.delegate = self;
        datePicker.setDate(Date(), animated: true)
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels;
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
    }
    
    @objc func saveButton () {
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date;
            
            realm.beginWrite();
            
            let newItem = TodoListItem();
            newItem.date = date;
            newItem.item = text;
            
            realm.add(newItem);
            try! realm.commitWrite();
            
            completetionHandler?()
            
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Add something...")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder();
        return true;
    }

}
