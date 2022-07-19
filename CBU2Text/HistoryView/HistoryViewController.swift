//
//  HistoryVC.swift
//  CBU2Text
//
//  Created by f0go on 25/05/2021.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    private var cbuList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let list = UserDefaults.standard.value(forKey: "cbuList") as? [String] {
            cbuList = list
            table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cbuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = cbuList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIPasteboard.general.string = cbuList[indexPath.row]
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let alert = UIAlertController(title: "✅", message: "El CBU \(cbuList[indexPath.row]) ya esta copiado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
