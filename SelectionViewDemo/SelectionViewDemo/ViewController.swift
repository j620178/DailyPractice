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
    
    let topData = [
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
    var topContent: UIView? {
        didSet {
            guard let topContent = topContent else { return }
            topContent.backgroundColor = .red
        }
    }
    var bottomSelectionView: SelectionView? {
        didSet {
            guard let bottomSelectionView = bottomSelectionView else { return }
            bottomSelectionView.dataSource = self
            bottomSelectionView.delegate = self
        }
    }
    var bottomContent: UIView? {
        didSet {
            guard let bottomContent = bottomContent else { return }
            bottomContent.backgroundColor = .red
        }
    }
    var buttomIsEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        view.backgroundColor = .black
        
        topSelectionView = SelectionView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 45))
        topContent = UIView(frame: CGRect(x: 0, y: 85, width: UIScreen.main.bounds.width, height: 100))
        bottomSelectionView = SelectionView(frame: CGRect(x: 0, y: 185, width: UIScreen.main.bounds.width, height: 45))
        bottomContent = UIView(frame: CGRect(x: 0, y: 230, width: UIScreen.main.bounds.width, height: 100))
        
        guard let topSelectionView = topSelectionView,
            let topContent = topContent,
            let bottomSelectionView = bottomSelectionView,
            let bottomContent = bottomContent
        else { return }
        
        self.view.addSubview(topSelectionView)
        self.view.addSubview(topContent)
        self.view.addSubview(bottomSelectionView)
        self.view.addSubview(bottomContent)

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
            buttomIsEnable = index == 0 ? true : false
        } else {
            bottomContent?.backgroundColor = bottomData[index].color
        }
    }
    
    func shouldSelectButton(selectionView: SelectionView, index: Int) -> Bool {
        return selectionView == topSelectionView ? true : buttomIsEnable
    }

}
