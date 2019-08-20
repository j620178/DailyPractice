//
//  SelectionView.swift
//  SelectionViewDemo
//
//  Created by littlema on 2019/8/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol SelectionViewDataSource: NSObject {
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int
    func titleOfRowAt(selectionView: SelectionView, index: Int) -> String
    func indicatorColorOfSelectionButtons(selectionView: SelectionView) -> UIColor
    func titleColorOfSelectionButtons(selectionView: SelectionView) -> UIColor
    func backgroundColorOfSelectionButtons(selectionView: SelectionView) -> UIColor
    func fontOfSelectionButtons(selectionView: SelectionView) -> UIFont
}

extension SelectionViewDataSource {
    
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int {
        return 2
    }
    
    func indicatorColorOfSelectionButtons(selectionView: SelectionView) -> UIColor {
        return .white
    }
    
    func titleColorOfSelectionButtons(selectionView: SelectionView) -> UIColor {
        return .white
    }
    
    func backgroundColorOfSelectionButtons(selectionView: SelectionView) -> UIColor {
        return .black
    }
    
    func fontOfSelectionButtons(selectionView: SelectionView) -> UIFont {
        return .systemFont(ofSize: 18)
    }
    
}

@objc protocol SelectionViewDelegate {
    @objc optional func didSelectButton(selectionView: SelectionView, index: Int)
    
    @objc optional func shouldSelectButton(selectionView: SelectionView, index: Int) -> Bool
}

class SelectionView: UIView {

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let indicatorContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let indicatorView = UIView()
    
    weak var dataSource: SelectionViewDataSource? {
        didSet {
            print("dataSource")
            setupButton()
        }
    }
    
    weak var delegate: SelectionViewDelegate?
    
    var currentIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame")
        setupBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        setupBaseView()
    }
    
    func setupBaseView() {
        self.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
        self.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
        self.leftAnchor.constraint(equalTo: buttonStackView.leftAnchor),
        self.rightAnchor.constraint(equalTo: buttonStackView.rightAnchor),
        buttonStackView.heightAnchor.constraint(equalToConstant: self.frame.height - 2)])

        self.addSubview(indicatorContainerView)
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: indicatorContainerView.topAnchor),
            self.leftAnchor.constraint(equalTo: indicatorContainerView.leftAnchor),
            self.rightAnchor.constraint(equalTo: indicatorContainerView.rightAnchor),
            indicatorContainerView.heightAnchor.constraint(equalToConstant: 2)])
    }
    
    func setupButton() {
        guard let dataSource = dataSource else { return }
        
        indicatorView.backgroundColor = dataSource.indicatorColorOfSelectionButtons(selectionView: self)

        for index in 0..<dataSource.numberOfSelectionButtons(selectionView: self) {
            let button = UIButton()
            button.tag = index
            button.setTitle(dataSource.titleOfRowAt(selectionView: self, index: index), for: .normal)
            button.titleLabel?.font = dataSource.fontOfSelectionButtons(selectionView: self)
            button.setTitleColor(dataSource.titleColorOfSelectionButtons(selectionView: self), for: .normal)
            button.backgroundColor = dataSource.backgroundColorOfSelectionButtons(selectionView: self)
            button.addTarget(self, action: #selector(updataIndicatorPosition(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
        
        indicatorContainerView.addSubview(indicatorView)
    }
    
    @objc func updataIndicatorPosition(_ button: UIButton) {
        
        guard let delegate = delegate,
            let shouldSelectButton = delegate.shouldSelectButton,
            let didSelectButton = delegate.didSelectButton
        else { return }
        
        if shouldSelectButton(self, button.tag) {
            
            didSelectButton(self, button.tag)
            
            currentIndex = button.tag
            
            guard let btnLabel = button.titleLabel, let text = btnLabel.text else { return }
            
            let width = getSizeFromString(string: text, withFont: .systemFont(ofSize: 15)).width + 20
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                
                self?.indicatorView.frame = CGRect(x: button.center.x - (width / 2), y: 0, width: width, height: 2)
                
            }
        }
    }
    
    func getSizeFromString(string: String, withFont font: UIFont) -> CGSize{
        
        let textSize = NSString(string: string ).size(
    
            withAttributes: [NSAttributedString.Key.font:font])
        
        return textSize
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        
        buttonStackView.layoutIfNeeded()
        
        if buttonStackView.subviews.count > 0 {
            
            guard let firstView = buttonStackView.subviews.first,
                let btn = firstView as? UIButton,
                let btnLabel = btn.titleLabel,
                let text = btnLabel.text
            else { return }
            
            let width = getSizeFromString(string: text, withFont: .systemFont(ofSize: 15)).width + 20
            
            indicatorView.frame = CGRect(x: btn.center.x - (width / 2), y: 0, width: width, height: 2)
            
        }
    }
}
