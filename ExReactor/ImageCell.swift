//
//  ImageCell.swift
//  ExReactor
//
//  Created by LEE on 2023/05/17.
//


import UIKit
import PinLayout
import FlexLayout
import Then

class ImageCell: UICollectionViewCell {
    fileprivate let lbTitle:UILabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initLayout() {
        self.backgroundColor = .yellow
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
    
    
    func configure(_ text:String?) {
        self.lbTitle.text = text
        self.lbTitle.flex.markDirty()
        self.needUpdate()
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        performLayout()
        return contentView.frame.size
    }
}
 
