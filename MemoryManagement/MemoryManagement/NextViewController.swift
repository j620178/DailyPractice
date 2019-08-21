//
//  NextViewController.swift
//  MemoryManagement
//
//  Created by littlema on 2019/8/21.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol Helper {
    func saySomething()
    
    func passSelf(vc: NextViewController)
}

class NextViewController: UIViewController {
    
    var delegate: Helper?
    
    var textData: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popButton(_:)))
        navigationItem.leftBarButtonItem = leftBarItem
        
        delegate?.saySomething()
        
        delegate?.passSelf(vc: self)
        
        print("RetainCount: \(CFGetRetainCount(self))")
    }

    @objc func popButton(_ button: UIButton) {
        
        let VC = self.navigationController!.viewControllers[0] as! ViewController
        VC.passHandler = { [weak self] text in
            self?.textData = text
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    deinit {
        print("NextViewController deinit")
    }
    
}
