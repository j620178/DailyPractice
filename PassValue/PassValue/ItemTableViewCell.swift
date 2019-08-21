//
//  ItemTableViewCell.swift
//  PassValue
//
//  Created by littlema on 2019/8/20.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol DeleteHelper {
    
    func deleteData(cell: UITableViewCell)
    
}

class ItemTableViewCell: UITableViewCell {
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        return button
    }()
    
    var deletePassHelper: ((UITableViewCell) -> Void)? {
        didSet {
            deleteButton.addTarget(self, action: #selector(clickDeleteButton(_:)), for: .touchUpInside)
        }
    }
    var delegate: DeleteHelper? {
        didSet {
            deleteButton.addTarget(self, action: #selector(clickDeleteButton(_:)), for: .touchUpInside)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.addSubview(deleteButton)
        
        contentView.topAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 10).isActive = true
        contentView.rightAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: 16).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: getSizeFromString(string: "Delete").width + 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        deleteButton.layoutIfNeeded()
        
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 4
        
    }

    func getSizeFromString(string: String, withFont font: UIFont = .systemFont(ofSize: 15)) -> CGSize{
        
        let textSize = NSString(string: string).size(withAttributes: [NSAttributedString.Key.font: font])
        return textSize
        
    }
    
    @objc func clickDeleteButton(_ button: UIButton) {
        
        deletePassHelper?(self)
        delegate?.deleteData(cell: self)
        
    }
    
}
