//
//  RelativeViewController.swift
//  Topics
//
//  Created by PARMJIT SINGH KHATTRA on 14/6/20.
//  Copyright © 2020 PARMJIT SINGH KHATTRA. All rights reserved.
//

import UIKit

class RelativeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    
    var mainTopics = [MainTopics]()
    let constant = Constant()
    @IBOutlet weak var tableView: UITableView!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("relative.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Relativve"
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        loadItems()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTopics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constant.mainTopics , for: indexPath)
        cell.textLabel?.text = mainTopics[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainTopics.remove(at: indexPath.row)
        saveItem()
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Relative", message: "Name of Topics", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            var newTopic = MainTopics()
            newTopic.name = textField.text!
            self.mainTopics.append(newTopic)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Topics"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(mainTopics)
             try data.write(to: dataFilePath!)
        } catch  {
            print("Error\(error)")
        }
        tableView.reloadData()
    }
    func loadItems() {
        do {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            mainTopics = try decoder.decode([MainTopics].self, from: data)
            }
        } catch {
            print("Error\(error)")
        }
    }
}
