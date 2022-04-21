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
    
    // MARK: - 属性
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
            if self.isAnimationEnable {
                self.updateFrame()
                if self.currentPage == oldValue || self.isAnimating {
                    return
                }
                if self.currentPage > oldValue {
                    self.changeColor(currentPage: oldValue)
                    self.startAnimationToRight(oldPage: oldValue, newPage: self.currentPage)
                } else {
                    self.changeColor(currentPage: oldValue)
                    self.startAnimationToLeft(oldPage: oldValue, newPage: self.currentPage)
                }
            } else {
                self.changeColor(currentPage: self.currentPage)
                self.updateFrame()
                self.updatePageNumbers()
            }
        }
    }
    
    /// page颜色
    public var pageIndicatorTintColor: UIColor = UIColor.gray {
        didSet {
            self.changeColor(currentPage: self.currentPage)
        }
    }
    
    /// 当前page颜色
    public var currentPageIndicatorTintColor: UIColor = UIColor.white {
        didSet {
            self.changeColor(currentPage: self.currentPage)
        }
    }
    
    /// 以image作为page
    public var pageImage: UIImage? {
        didSet {
            self.changeColor(currentPage: self.currentPage)
        }
    }
    
    /// 当前page的image
    public var currentPageImage: UIImage? {
        didSet {
            self.changeColor(currentPage: self.currentPage)
        }
    }
    
    /// 是否显示page的序号
    public var isShowPageNumber: Bool = false {
        didSet {
            self.setupPageNumbers()
        }
    }
    
    /// page的序号文字颜色
    public var pageNumberColor: UIColor = UIColor.lightGray {
        didSet {
            self.updatePageNumbers()
        }
    }
    
    /// page的序号文字字体
    public var pageNumberFont: UIFont = UIFont.systemFont(ofSize: 8.0) {
        didSet {
            self.updatePageNumbers()
        }
    }
    
    /// 当前page的序号文字颜色
    public var currentPageNumberColor: UIColor = UIColor.black {
        didSet {
            self.updatePageNumbers()
        }
    }
    
    /// 当前page的序号文字字体
    public var currentPageNumberFont: UIFont = UIFont.systemFont(ofSize: 8.0) {
        didSet {
            self.updatePageNumbers()
        }
    }
    
    /// 是否显示page的边框
    public var isShowPageBorder: Bool = false {
        didSet {
            self.updatePageBorder()
        }
    }
    
    /// page的边框宽度
    public var pageBorderWidth: CGFloat = 1.0 {
        didSet {
            self.updatePageBorder()
        }
    }
    
    /// page的边框颜色
    public var pageBorderColor: UIColor = UIColor.white {
        didSet {
            self.updatePageBorder()
        }
    }
    
    /// 当前page的边框宽度
    public var currentPageBorderWidth: CGFloat = 1.0 {
        didSet {
            self.updatePageBorder()
        }
    }
    
    /// 当前page的边框颜色
    public var currentPageBorderColor: UIColor = UIColor.gray {
        didSet {
            self.updatePageBorder()
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
    
    /// 是否动画,默认为false
    public var isAnimationEnable: Bool = false
    
    /// 点击page的回调
    public var pageClickBlock: ((_ index: Int) -> ())?
    
    /// page试图
    private var pages = [UIImageView]()
    
    /// page序号
    private var pageNumbers = [UILabel]()
    
    /// 是否在动画中
    private var isAnimating = false
    
    // MARK: - 方法
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(pageClicked(tap:)))
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
    
    /// 更新布局
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
    
    /// 更新颜色
    private func changeColor(currentPage: Int) {
        for (index, page) in self.pages.enumerated() {
            if index == currentPage {
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
    
    /// 设置序号数字
    private func setupPageNumbers() {
        if !self.isShowPageNumber {
            return
        }
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
    
    /// 更新序号数字
    private func updatePageNumbers() {
        for (index, pageNumber) in self.pageNumbers.enumerated() {
            pageNumber.frame = CGRect(x: 0, y: 0, width: self.getFrame(index: index).width, height: self.getFrame(index: index).height)
            pageNumber.textColor = index == self.currentPage ? self.currentPageNumberColor : self.pageNumberColor
            pageNumber.font = index == self.currentPage ? self.currentPageNumberFont : self.pageNumberFont
        }
    }
    
    /// 更新边框
    private func updatePageBorder() {
        if !self.isShowPageBorder {
            return
        }
        for (index, page) in self.pages.enumerated() {
            page.layer.borderColor = index == self.currentPage ? self.currentPageBorderColor.cgColor : self.pageBorderColor.cgColor
            page.layer.borderWidth = index == self.currentPage ? self.currentPageBorderWidth : self.pageBorderWidth
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
    @objc private func pageClicked(tap: UITapGestureRecognizer) {
        let index = tap.view!.tag - 1000
        self.currentPage = index
        if self.pageClickBlock != nil {
            self.pageClickBlock!(index)
        }
    }
    
    // MARK: - 动画
    /// 向右动画
    private func startAnimationToRight(oldPage: Int, newPage: Int) {
        guard let currentPageSize = self.currentPageSize else {
            return
        }
        let startView = self.pages[oldPage]
        self.bringSubviewToFront(startView)
        self.isAnimating = true
        UIView.animate(withDuration: 0.3) {
            // 当前选中的圆点,x不变,宽度增加,增加几个圆点和间隙距离
            let width = currentPageSize.width + (self.pageSize.width + self.pageSpacing) * CGFloat(newPage - oldPage)
            startView.frame = CGRect(x: startView.frame.minX, y: startView.frame.minY, width: width, height: startView.frame.height)
        } completion: { (finished) in
            let endView = self.pages[newPage]
            endView.backgroundColor = startView.backgroundColor
            endView.frame = startView.frame
            startView.backgroundColor = self.pageIndicatorTintColor
            for i in 0 ..< (newPage - oldPage) {
                let tempView = self.pages[oldPage + i]
                tempView.frame = CGRect(x: startView.frame.minX + (self.pageSize.width + self.pageSpacing) * CGFloat(i), y: tempView.frame.minY, width: self.pageSize.width, height: self.pageSize.height)
            }
            UIView.animate(withDuration: 0.3) {
                let y = (self.frame.size.height - currentPageSize.height) / 2.0
                endView.frame = CGRect(x: endView.frame.maxX - currentPageSize.width, y: y, width: currentPageSize.width, height: currentPageSize.height)
            } completion: { (finished) in
                endView.backgroundColor = self.currentPageIndicatorTintColor
                self.isAnimating = false
            }
        }
    }
    
    /// 向左动画
    private func startAnimationToLeft(oldPage: Int, newPage: Int) {
        guard let currentPageSize = self.currentPageSize else {
            return
        }
        let startView = self.pages[oldPage]
        self.bringSubviewToFront(startView)
        self.isAnimating = true
        UIView.animate(withDuration: 0.3) {
            // 当前选中的圆点,x向左移动,宽度增加,增加几个圆点和间隙距离
            let x = startView.frame.minX - (self.pageSize.width + self.pageSpacing) * CGFloat(oldPage - newPage)
            let width = currentPageSize.width + (self.pageSize.width + self.pageSpacing) * CGFloat(oldPage - newPage)
            startView.frame = CGRect(x: x, y: startView.frame.minY, width: width, height: startView.frame.height)
        } completion: { (finished) in
            let endView = self.pages[newPage]
            endView.backgroundColor = startView.backgroundColor
            endView.frame = startView.frame
            startView.backgroundColor = self.pageIndicatorTintColor
            for i in 0 ..< (oldPage - newPage) {
                let tempView = self.pages[oldPage - i]
                tempView.frame = CGRect(x: startView.frame.maxX - self.pageSize.width - (self.pageSize.width + self.pageSpacing) * CGFloat(i), y: tempView.frame.minY, width: self.pageSize.width, height: self.pageSize.height)
            }
            UIView.animate(withDuration: 0.3) {
                let y = (self.frame.size.height - currentPageSize.height) / 2.0
                endView.frame = CGRect(x: endView.frame.minX, y: y, width: currentPageSize.width, height: currentPageSize.height)
            } completion: { (finished) in
                endView.backgroundColor = self.currentPageIndicatorTintColor
                self.isAnimating = false
            }
        }
    }
}
