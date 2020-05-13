//
//  MZPageControl.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

public enum MZPageControlAlignment {
    case left
    case center
    case right
}

class MZPageControl: UIControl {
    
    /// page个数
    public var numberOfPages: Int = 0 {
        didSet {
            self.setupPages()
        }
    }
    
    /// page间隔
    public var pageSpacing: CGFloat = 8.0 {
        didSet {
            self.updateFrame()
        }
    }
    
    /// page大小
    public var pageSize: CGSize = CGSize(width: 8.0, height: 8.0) {
        didSet {
            self.updateFrame()
        }
    }
    
    /// 当前page大小
    public var currentPageSize: CGSize? {
        didSet {
            self.updateFrame()
        }
    }
    
    /// page位置
    public var alignment: MZPageControlAlignment = .center {
        didSet {
            self.updateFrame()
        }
    }
    
    /// page圆角
    public var pageCornerRadius: CGFloat? {
        didSet {
            self.updateFrame()
        }
    }
    
    /// 当前page圆角
    public var currentPageCornerRadius: CGFloat? {
        didSet {
            self.updateFrame()
        }
    }
    
    /// 当前page
    public var currentPage: Int = 0 {
        didSet {
            self.changeColor()
            self.updateFrame()
            self.updatePageNumber()
        }
    }
    
    /// page颜色
    public var pageIndicatorTintColor: UIColor = UIColor.gray {
        didSet {
            self.changeColor()
        }
    }
    
    /// 当前page颜色
    public var currentPageIndicatorTintColor: UIColor = UIColor.white {
        didSet {
            self.changeColor()
        }
    }
    
    /// 以image作为page
    public var pageImage: UIImage? {
        didSet {
            self.changeColor()
        }
    }
    
    /// 当前page的image
    public var currentPageImage: UIImage? {
        didSet {
            self.changeColor()
        }
    }
    
    /// 是否显示page的序号
    public var showPageNumber: Bool = false {
        didSet {
            if showPageNumber {
                self.setupPageNumbers()
            }
        }
    }
    
    /// page的序号文字颜色
    public var pageNumberColor: UIColor = UIColor.lightGray {
        didSet {
            self.updatePageNumber()
        }
    }
    
    /// page的序号文字字体
    public var pageNumberFont: UIFont = UIFont.systemFont(ofSize: 8.0) {
        didSet {
            self.updatePageNumber()
        }
    }
    
    /// 当前page的序号文字颜色
    public var currentPageNumberColor: UIColor = UIColor.black {
        didSet {
            self.updatePageNumber()
        }
    }
    
    /// 当前page的序号文字字体
    public var currentPageNumberFont: UIFont = UIFont.systemFont(ofSize: 8.0) {
        didSet {
            self.updatePageNumber()
        }
    }
    
    /// 是否可以点击page,默认为true
    public var isClickEnable: Bool = true {
        didSet {
            for page in self.pages {
                page.isUserInteractionEnabled = self.isClickEnable
            }
        }
    }
    
    /// 点击page的回调
    public var pageClickBlock: ((_ index: Int) -> ())?
    
    /// page试图
    private var pages = [UIImageView]()
    
    /// page序号
    private var pageNumbers = [UILabel]()
    
    private func setupPages() {
        if self.pages.count > 0 {
            for page in self.pages {
                page.removeFromSuperview()
            }
            self.pages.removeAll()
        }
        for i in 0 ..< self.numberOfPages {
            let frame = self.getFrame(index: i)
            let imageView = UIImageView(frame: frame)
            imageView.tag = 1000 + i
            imageView.isUserInteractionEnabled = self.isClickEnable
            let tap = UITapGestureRecognizer(target: self, action: #selector(pageClick(tap:)))
            imageView.addGestureRecognizer(tap)
            self.addSubview(imageView)
            self.pages.append(imageView)
        }
        // 单个page隐藏
        self.isHidden = self.numberOfPages <= 1 ? true : false
    }
    
    private func getFrame(index: Int) -> CGRect {
        let pageW = self.pageSize.width + self.pageSpacing
        if self.currentPageSize == nil {
            self.currentPageSize = self.pageSize
        }
        let currentPageW = self.currentPageSize!.width + self.pageSpacing
        let totalW = pageW * CGFloat(self.numberOfPages - 1) + currentPageW + self.pageSpacing
        var pageX: CGFloat = 0
        switch self.alignment {
        case .left:
            pageX = self.pageSpacing
        case .right:
            pageX = self.frame.size.width - totalW - self.pageSpacing
        default:
            pageX = (self.frame.size.width - totalW) / 2.0 + self.pageSpacing
        }
        let width = index == self.currentPage ? self.currentPageSize!.width : self.pageSize.width
        let height = index == self.currentPage ? self.currentPageSize!.height : self.pageSize.height
        let x = index <= self.currentPage ? pageX + pageW * CGFloat(index) : pageX + pageW * CGFloat(index - 1) + currentPageW
        let y = (self.frame.size.height - height) / 2.0
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public func updateFrame() {
        for (index, page) in self.pages.enumerated() {
            let frame = self.getFrame(index: index)
            page.frame = frame
            var radius = self.pageCornerRadius == nil ? frame.size.height / 2.0 : self.pageCornerRadius!
            if index == self.currentPage {
                if self.currentPageImage != nil {
                    radius = 0
                }
                page.layer.cornerRadius = self.currentPageCornerRadius == nil ? radius : self.currentPageCornerRadius!
            } else {
                if self.pageImage != nil {
                    radius = 0
                }
                page.layer.cornerRadius = radius
            }
            page.layer.masksToBounds = true
        }
    }
    
    private func changeColor() {
        for (index, page) in self.pages.enumerated() {
            if index == self.currentPage {
                page.backgroundColor = self.currentPageImage == nil ? self.currentPageIndicatorTintColor : UIColor.clear
                page.image = self.currentPageImage
                if self.currentPageImage != nil {
                    page.layer.cornerRadius = 0
                }
            } else {
                page.backgroundColor = self.pageImage == nil ? self.pageIndicatorTintColor : UIColor.clear
                page.image = self.pageImage
                if self.pageImage != nil {
                    page.layer.cornerRadius = 0
                }
            }
        }
    }
    
    private func setupPageNumbers() {
        for (index, page) in self.pages.enumerated() {
            let numberLbl = UILabel(frame: page.bounds)
            numberLbl.text = "\(index + 1)"
            numberLbl.textColor = index == self.currentPage ? self.currentPageNumberColor : self.pageNumberColor
            numberLbl.font = index == self.currentPage ? self.currentPageNumberFont : self.pageNumberFont
            numberLbl.textAlignment = .center
            page.addSubview(numberLbl)
            self.pageNumbers.append(numberLbl)
        }
    }
    
    private func updatePageNumber() {
        for (index, pageNumber) in self.pageNumbers.enumerated() {
            pageNumber.frame = CGRect(x: 0, y: 0, width: self.getFrame(index: index).width, height: self.getFrame(index: index).height)
            pageNumber.textColor = index == self.currentPage ? self.currentPageNumberColor : self.pageNumberColor
            pageNumber.font = index == self.currentPage ? self.currentPageNumberFont : self.pageNumberFont
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
    @objc private func pageClick(tap: UITapGestureRecognizer) {
        let index = tap.view!.tag - 1000
        self.currentPage = index
        if self.pageClickBlock != nil {
            self.pageClickBlock!(index)
        }
    }
}
