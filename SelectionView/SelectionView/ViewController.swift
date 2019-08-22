//
//  ViewController.swift
//  SelectionViewDemo
//
//  Created by littlema on 2019/8/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct ColorItem {
    let name: String
    let color: UIColor
}

class ViewController: UIViewController {
    
    var topData = [
        ColorItem(name: "Red", color: .red),
        ColorItem(name: "Yellow", color: .yellow)]
    
    let bottomData = [
        ColorItem(name: "Red", color: .red),
        ColorItem(name: "Yellow", color: .yellow),
        ColorItem(name: "Blue", color: .blue)]
    
    var topSelectionView: SelectionView? {
        didSet {
            guard let topSelectionView = topSelectionView else { return }
            topSelectionView.dataSource = self
            topSelectionView.delegate = self
        }
    }
    
    var topContent: UIView?
    
    var bottomSelectionView: SelectionView? {
        didSet {
            guard let bottomSelectionView = bottomSelectionView else { return }
            bottomSelectionView.dataSource = self
            bottomSelectionView.delegate = self
        }
    }
    
    var bottomContent: UIView?
    
    let updateButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ReloadData", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(updateData(_:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        view.backgroundColor = .black
        
        topSelectionView = SelectionView(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 45))
        topContent = UIView(frame: CGRect(x: 0, y: 125, width: UIScreen.main.bounds.width, height: 100))
        bottomSelectionView = SelectionView(frame: CGRect(x: 0, y: 225, width: UIScreen.main.bounds.width, height: 45))
        bottomContent = UIView(frame: CGRect(x: 0, y: 270, width: UIScreen.main.bounds.width, height: 100))
        
        guard let topSelectionView = topSelectionView,
            let topContent = topContent,
            let bottomSelectionView = bottomSelectionView,
            let bottomContent = bottomContent
        else { return }
        
        self.view.addSubview(topSelectionView)
        self.view.addSubview(topContent)
        self.view.addSubview(bottomSelectionView)
        self.view.addSubview(bottomContent)
        

        self.view.addSubview(updateButton)
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func updateData(_ button: UIButton) {
        topData = [
            ColorItem(name: "Red", color: .red),
            ColorItem(name: "Yellow", color: .yellow),
            ColorItem(name: "Purple", color: .purple)
        ]
        
        //topSelectionView?.dataSource = nil
        
        topSelectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
    }
    
    deinit {
        print("ViewController deinit")
    }
    
}

extension ViewController: SelectionViewDataSource {
    
    func titleOfRowAt(selectionView: SelectionView, index: Int) -> String {
        return selectionView == topSelectionView ? topData[index].name : bottomData[index].name
    }
    
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int {
        return selectionView == topSelectionView ? topData.count : bottomData.count
    }
    
}

extension ViewController: SelectionViewDelegate {
    
    func didSelectButton(selectionView: SelectionView, index: Int) {
        if selectionView == topSelectionView {
            topContent?.backgroundColor = topData[index].color
        } else {
            bottomContent?.backgroundColor = bottomData[index].color
        }
    }
    
    func shouldSelectButton(selectionView: SelectionView, index: Int) -> Bool {
        return selectionView == topSelectionView ? true : (topSelectionView?.currentIndex == 0 ? true : false )
    }

}
