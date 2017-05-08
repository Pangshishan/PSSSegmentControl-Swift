# PSSSegmentControl-Swift
模仿网易新闻首页顶部多个按钮(Swift版), 相当于UISegmentControl功能


> 之前写过一个OC版的简易SegmentControl，按钮布局是平分的，样子是这个样子的(下图)
[demo地址](https://github.com/Pangshishan/PSSSegmentControl.git)

![图片](http://upload-images.jianshu.io/upload_images/5379614-6fb5e966ecdce7a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 今天这款 是Swift版本的，布局使按照文本的长度，如果按钮个数少的话，是平分的，并且不可以滑动。如果按钮个数多，是平分的，可有滑动，并且会把点击到的按钮尽量放置在中间。
[demo地址](https://github.com/Pangshishan/PSSSegmentControl-Swift.git)
效果图如下：

![图二](http://upload-images.jianshu.io/upload_images/5379614-f7dbe47dcb976d81.gif?imageMogr2/auto-orient/strip)

- 文件目录
![文件目录](http://upload-images.jianshu.io/upload_images/5379614-27a902a7664c790a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 使用方法
```Swift
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
```
- 代码实现

```Swift
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
```
**在这里简单的粘贴了一下，如果想看实现，[请下载demo](https://github.com/Pangshishan/PSSSegmentControl-Swift.git)**
