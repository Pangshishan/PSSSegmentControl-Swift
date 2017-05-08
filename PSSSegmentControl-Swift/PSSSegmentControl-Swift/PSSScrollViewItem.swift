//
//  PSSScrollViewItem.swift
//  PSSSegmentControl-Swift
//
//  Created by 山不在高 on 17/5/8.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

import UIKit

class PSSScrollViewItem: UIView {

    // MARK: 公开属性
    // MARK: 只读属性
    // MARK: 私有属性
    private var str: String!
    private var label: UILabel!
    
    // MARK: 构造方法
    init(frame: CGRect, string: String) {
        super.init(frame: frame)
        self.str = string
        self.label = UILabel.init()
        self.label.font = UIFont.systemFont(ofSize: 30)
        self.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: 公开方法
    // MARK: 私有方法
    // MARK: 重写方法
    override func layoutSubviews() {
        super.layoutSubviews()
        label.text = self.str
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.sizeToFit()
        label.center = self.pss_boundsCenter
    }
    

}
