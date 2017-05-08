//
//  PSSSegmentControl.swift
//  PSSSegmentControl-Swift
//
//  Created by 山不在高 on 17/5/2.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

import UIKit

let PSS_TagBase: NSInteger = 200
typealias PSSClickBlock = (_ index: NSInteger)->Void

class PSSSegmentControl: UIView, PSSItemViewDelegate {
    
    // MARK: 开放属性
    var selectedIndex: NSInteger = 0 {
        willSet {
            let item0 = self.itemArray[self.selectedIndex]
            let item1 = self.itemArray[newValue]
            item0.pss_selected = false
            item1.pss_selected = true
            if self.ingoreSet {
                self.ingoreSet = false
                return
            }
            self.scrollTo(index: newValue)
        }
    }
    var normalColor = UIColor.darkGray {
        didSet {
            for item in self.itemArray {
                item.pss_normalColor = normalColor
            }
        }
    }
    var selectedColor = UIColor.red {
        didSet {
            for item in self.itemArray {
                item.pss_selectedColor = selectedColor
            }
        }
    }
    var pss_duration: CGFloat = 0.1 {
        didSet {
            for item in self.itemArray {
                item.pss_duration = self.pss_duration
            }
        }
    }
    var pss_scale: CGFloat = 1.1 {
        didSet {
            for item in self.itemArray {
                item.pss_scale = self.pss_scale
            }
        }
    }
    
    var pss_margin: CGFloat = 15 {
        didSet {
            self.layoutSubviews()
        }
    }
    var pss_font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            for item in self.itemArray {
                item.pss_font = pss_font
            }
            self .layoutSubviews()
        }
    }
    // 点击事件回调
    var clickBlock: PSSClickBlock!
    
    
    
    // MARK: 只读属性
    private(set) var titleArray: [String]!
    private(set) var itemArray:[PSSItemView] = [PSSItemView]()
    
    // MARK: 私有属性
    private var scrollView: UIScrollView!
    private var ingoreSet: Bool = false
    
    // MARK: 构造方法
    init(frame: CGRect, titleArray: [String]) {
        super.init(frame: frame)
        self.titleArray = titleArray
        for i in 0..<self.titleArray.count {
            let text = self.titleArray[i]
            let item = PSSItemView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: self.pss_height), title: text as NSString, font:self.pss_font)
            item.tag = i + PSS_TagBase
            self.itemArray.append(item)
            item.pss_normalColor = self.normalColor
            item.pss_selectedColor = self.selectedColor
            item.pss_delegate = self
        }
        self.addSomeViews()
        self.layoutGradientLayer()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: 开放方法
    
    // MARK: 代理方法
    func item(_ item: PSSItemView, didSelectAt index: NSInteger) {
        self.scrollTo(index: index)
        self.ingoreSet = true
        self.selectedIndex = index
        if let block = self.clickBlock {
            block(index)
        }
    }
    
    // MARK: 重写方法
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        let totalW = self.totalWidth()
        self.scrollView.contentSize = CGSize.init(width: totalW > self.pss_width ? totalW : self.pss_width, height: self.pss_height)
        self.scrollView.bounces = (totalW > self.pss_width)
        var margin = (self.pss_width - totalW + self.pss_margin * CGFloat(self.itemArray.count + 1)) / CGFloat(self.itemArray.count + 1)
        var x: CGFloat = totalW <= self.pss_width ? margin : self.pss_margin
        self.scrollView.showsHorizontalScrollIndicator = false
        margin = x
        for i in 0..<self.itemArray.count {
            let item = self.itemArray[i]
            let wid = item.itemWidth
            item.frame = CGRect.init(x: x, y: 0, width: wid, height: self.pss_height)
            x += (wid + margin)
        }
    }
    // MARK: 私有方法
    private func addSomeViews() {
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(self.scrollView)
        for item in self.itemArray {
            self.scrollView.addSubview(item)
        }
    }
    private func totalWidth() -> CGFloat {
        var totalWid: CGFloat = self.pss_margin
        for item in self.itemArray {
            totalWid += (item.itemWidth + self.pss_margin)
        }
        return totalWid;
    }
    private func scrollTo(index: NSInteger) {
        let itemV = self.itemArray[index]
        let centerX = itemV.pss_centerX
        if centerX <= self.pss_width / 2 {
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        } else if centerX >= self.scrollView.contentSize.width - self.pss_width / 2 {
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentSize.width - self.pss_width, y: 0), animated: true)
        } else {
            let x = centerX - self.pss_width / 2
            scrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)
        }
    }
    private func layoutGradientLayer() {
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.cgColor
        ]
        let margin = 0.02
        let gradient = 0.05
        let locations = [
            margin,
            margin + gradient,
            1 - (margin + gradient),
            1 - margin
        ]
        gradientLayer.locations = locations as [NSNumber]?
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    deinit {
        print("PSSSegmentControll - 被销毁了")
    }
}

extension UIView {
    var pss_x: CGFloat {
        return self.frame.origin.x
    }
    var pss_y: CGFloat {
        return self.frame.origin.y
    }
    var pss_height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    var pss_width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    var pss_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            let rect = self.frame
            let width = newValue - rect.origin.x
            self.frame = CGRect.init(x: self.pss_x, y: self.pss_y, width: width, height: self.pss_height)
        }
    }
    var pss_centerX: CGFloat {
        get {
            return self.pss_x + self.pss_width / 2
        }
    }
    var pss_boundsCenter: CGPoint {
        get {
            return CGPoint.init(x: self.pss_width / 2, y: self.pss_height / 2)
        }
    }
    
    
}





