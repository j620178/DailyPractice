//
//  MainViewController.swift
//  PassValue
//
//  Created by littlema on 2019/8/20.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var tableView: UITableView = {
        let tabelView = UITableView()
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        tabelView.register(ItemTableViewCell.self, forCellReuseIdentifier: String(describing: ItemTableViewCell.self))
        return tabelView
    }()
    
    var data = ["2", "3", "4", "5", "6", "7", "8"] {
        didSet {
            print(data)
        }
    }
    
    var updateIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickAddutton(_:)))
        self.navigationItem.rightBarButtonItem = item1
                
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: tableView.leftAnchor),
            view.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])

    }
    
    @objc func clickAddutton(_ button: UIButton) {
        
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        else { return }
        
        nextVC.insertDataHelper = { [weak self] text in
            
            guard let strongSelf = self else { return }
            
            strongSelf.data.append(text)
            
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.data.count - 1, section: 0)], with: .automatic)
            strongSelf.tableView.endUpdates()
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func clickDeleteButton(_ button: UIButton) {
        print("Delete by addTarget")
        guard var view = button.superview else { return }
        
//        while let tempView = view.superview  {
//
//            view = tempView
//
//            if let itemCell = view as? ItemTableViewCell {
//
//                guard let indexPath = tableView.indexPath(for: itemCell) else { return }
//                data.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                break
//            }
//        }
        repeat {
            
            if let itemCell = view as? ItemTableViewCell {
                guard let indexPath = tableView.indexPath(for: itemCell) else { return }
                data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                return
            }
            
            guard let tempView = view.superview else { return }
            
            view = tempView
            
        } while view.superview != nil
        
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ItemTableViewCell.self), for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        guard let itemCell = cell as? ItemTableViewCell else { return cell }
        
        switch indexPath.row % 3 {
        case 0: itemCell.deleteButton.addTarget(self, action: #selector(clickDeleteButton(_:)), for: .touchUpInside)
        case 1: itemCell.delegate = self
        case 2:
            itemCell.deletePassHelper = { cell in
                print("Delete by closure")
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                self.data.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
        }
        
        return itemCell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        else { return }
        
        updateIndexPath = indexPath
        
        nextVC.delegate = self
        nextVC.preloadData = data[indexPath.row]
        
        nextVC.updateDataHelper = { [weak self] text in
            
            guard let strongSelf = self else { return }
            strongSelf.data[indexPath.row] = text
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension MainViewController: DataPassHelper {
    func insertData(text: String) {
        
        self.data.append(text)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: self.data.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func updateData(text: String) {
        
        guard let updateIndexPath = updateIndexPath else { return }

        self.data[updateIndexPath.row] = text
        
        tableView.reloadRows(at: [updateIndexPath], with: .automatic)
        
        self.updateIndexPath = nil
    }
}

extension MainViewController: DeleteHelper {
    
    func deleteData(cell: UITableViewCell) {
        
        print("Delete by delegate")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

    }
}
