//
//  ViewController.swift
//  PSSSegmentControl-Swift
//
//  Created by 山和霞 on 17/5/2.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: 存储属性
    let dataArr: [String] = ["00000000", "111", "222", "3333333", "44444", "5555555", "666666", "777777777"]
    
    
    // MARK: 私有属性
    private var segmentC: PSSSegmentControl!
    private var scrollView: UIScrollView!
    
    // MARK: 重写方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addSegmentC()
        self.addScrollView()
        
    }
    // MARK: 私有方法
    private func addSegmentC() {
        let segmentC = PSSSegmentControl.init(frame: CGRect.init(x: 0, y: 20, width: kScreenWidth, height: 40), titleArray: dataArr);
        segmentC.normalColor = UIColor.lightGray
        segmentC.selectedColor = UIColor.orange
        segmentC.backgroundColor = UIColor.white
        segmentC.pss_font = UIFont.systemFont(ofSize: 17)
        segmentC.pss_margin = 20
        segmentC.pss_duration = 0.2
        segmentC.pss_scale = 1.2
        segmentC.selectedIndex = 0 // 这个需要给定初始值
        self.view.addSubview(segmentC)
        self.segmentC = segmentC
        
        weak var weakSelf = self
        // segmentC点击事件
        segmentC.clickBlock = {
            (index: NSInteger) in
            weakSelf?.scrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * kScreenWidth, y: 0), animated: true)
            
        }
    }
    private func addScrollView() {
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.segmentC.pss_height + 20, width: kScreenWidth, height: kScreenHeight - self.segmentC.pss_height - 20))
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize.init(width: kScreenWidth * CGFloat(self.dataArr.count), height: kScreenHeight - self.segmentC.pss_height - 20)
        scrollView.delegate = self;
        for i in 0..<self.dataArr.count {
            let scrollViewItem = PSSScrollViewItem.init(frame: CGRect.init(x: CGFloat(i) * kScreenWidth, y: 0, width: kScreenWidth, height: scrollView.pss_height), string: "\(i)")
            scrollView.addSubview(scrollViewItem)
        }
    }
    // MARK: 代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.segmentC.selectedIndex = NSInteger(scrollView.contentOffset.x / kScreenWidth)
    }
}

