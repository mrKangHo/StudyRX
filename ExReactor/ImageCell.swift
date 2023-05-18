//
//  ImageCell.swift
//  ExReactor
//
//  Created by LEE on 2023/05/17.
//


import UIKit
import PinLayout
import FlexLayout

class ImageCell: UICollectionViewCell {
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
    
    
    func configure() {
        
        self.needUpdate()
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        performLayout()
        return contentView.frame.size
    }
}
 
