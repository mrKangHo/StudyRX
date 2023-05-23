//
//  TextCell.swift
//  ExReactor
//
//  Created by LEE on 2023/05/17.
//


import UIKit
import PinLayout
import FlexLayout
import Then
import NBModel

class TextCell: UICollectionViewCell,ConfigurableCell {
    
    
    
    fileprivate let lbTitle:UILabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initLayout() {
        self.backgroundColor = .blue
        contentView.flex.define { flex in
            flex.addItem(lbTitle)
        }
    }
    
    func performLayout() {
        contentView.flex.layout(mode: .adjustHeight)
        
    }
    
    func didPerformLayout() {
        
        
    }
    
    func needUpdate() {
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.performLayout()
        self.didPerformLayout()
        
    }
    
    func configure(data user: MainUser.User?) {
        self.lbTitle.text = user?.lastName
        self.lbTitle.flex.markDirty()
        self.needUpdate()
    }
 
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        performLayout()
        return contentView.frame.size
    }
}
 
