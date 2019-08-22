//
//  ViewController.swift
//  MemoryManagement
//
//  Created by littlema on 2019/8/21.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var nextVC: NextViewController?
    
    var passHandler: ((String) -> Void)?
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Conform", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(clickClearButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextVC = storyboard?.instantiateViewController(withIdentifier: "NextViewController") as? NextViewController
        nextVC?.delegate = self
        
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickRightItemButton))
        navigationItem.rightBarButtonItem = rightBarItem
        
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(clickleftItemButton))
        navigationItem.leftBarButtonItem = leftBarItem
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        print("passHandler")
        passHandler?("Hello")
    }
    
    @objc func clickRightItemButton(_ button: UIButton) {
        guard let nextVC = nextVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func clickleftItemButton(_ button: UIButton) {
        guard let nextVC = nextVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func clickClearButton(_ button: UIButton) {
        if nextVC == nil {
            print("I'm dead")
        } else {
            print("I'm alive")
            print("RetainCount: \(CFGetRetainCount(nextVC))")
        }
        
    }
    
    deinit {
        print("ViewController deinit")
    }
    
}

extension ViewController: Helper {
    
    func passSelf(vc: NextViewController) {
        self.nextVC = vc
    }
    
    func saySomething() {
        print("Hi")
    }
    
}
