//
//  PSSItemView.swift
//  PSSSegmentControl-Swift
//
//  Created by 山不在高 on 17/5/3.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

import UIKit

protocol PSSItemViewDelegate: NSObjectProtocol {
    func item(_ item: PSSItemView, didSelectAt index: NSInteger)
}

class PSSItemView: UIButton {

    let pss_inset: CGFloat = 10
    var pss_duration: CGFloat = 0.1
    var pss_scale: CGFloat = 1.1
    // MARK: 公开属性
    weak var pss_delegate: PSSItemViewDelegate!
    var pss_selected = false {
        didSet {
            UIView.animate(withDuration: TimeInterval(pss_duration)) {
                self.pss_textColor = self.pss_selected ? self.pss_selectedColor : self.pss_normalColor
            }
            if self.pss_selected {
                let anima = CABasicAnimation.init(keyPath: "transform.scale")
                anima.fromValue = 1.0
                anima.toValue = self.pss_scale
                anima.isRemovedOnCompletion = false
                anima.fillMode = kCAFillModeForwards
                anima.duration = CFTimeInterval(self.pss_duration)
                self.layer.add(anima, forKey: nil)
            } else {
                let anima = CABasicAnimation.init(keyPath: "transform.scale")
                anima.fromValue = self.pss_scale
                anima.toValue = 1
                anima.isRemovedOnCompletion = false
                anima.fillMode = kCAFillModeForwards
                anima.duration = CFTimeInterval(self.pss_duration)
                self.layer.add(anima, forKey: nil)
            }
        }
    }
    var pss_normalColor = UIColor.darkGray {
        didSet {
            if pss_selected == false {
                self.pss_textColor = self.pss_normalColor
            }
        }
    }
    var pss_selectedColor = UIColor.red {
        didSet {
            if pss_selected == true {
                self.pss_textColor = self.pss_selectedColor
            }
        }
    }
    
    var pss_font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            self.pss_label.font = pss_font
            self.layoutSubviews()
        }
    }
    var pss_textColor = UIColor.black {
        didSet {
            self.pss_label.textColor = pss_textColor
        }
    }
    
    
    // MARK: 只读属性
    private var pss_title: NSString!
    var itemWidth: CGFloat {
        let attr = [NSFontAttributeName:self.pss_font]
        let titleSize = self.pss_title.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(50)), options: .usesFontLeading, attributes: attr, context: nil)
        return titleSize.width + 2 * pss_inset
    }
    
    
    // MARK: 私有属性
    private var pss_label: UILabel!
    // MARK: 构造方法
    init(frame: CGRect, title: NSString, font: UIFont) {
        super.init(frame: frame)
        self.pss_title = title
        self.pss_font = font
        self.addSomeView()
        self.addTarget(self, action: #selector(clickItem(btn:)), for: .touchUpInside)
                
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 公开方法
    
    
    // MARK: 私有方法
    private func addSomeView() {
        self.pss_label = UILabel.init()
        self.addSubview(self.pss_label)
        self.pss_label.text = self.pss_title as String?
        self.pss_label.font = self.pss_font
    }
    @objc private func clickItem(btn: UIButton) {
        self.pss_delegate.item(self, didSelectAt: self.tag - PSS_TagBase)
    }
    
    
    // MARK: 一般方法
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pss_label.frame = CGRect.init(x: 0, y: 0, width: self.itemWidth, height: self.pss_height)
        self.pss_label.textAlignment = .center
        self.pss_label.center = CGPoint.init(x:self.pss_width / 2, y: self.pss_height / 2)
    }
    
    
    deinit {
        print("PSSItemView - 被销毁了")
    }
    
    
    
    
    
    
}
