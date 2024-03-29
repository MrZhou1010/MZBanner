//
//  MZBannerView.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

public enum MZBannerResourceType {
    case image
    case imageUrl
    case text
}

class MZBannerView: UIView {
    
    /// 自动轮播,默认为true
    public var isAutomatic: Bool = true
    
    /// 无穷值,默认为true
    public var isInfinite: Bool = true {
        didSet {
            if self.isInfinite == false {
                self.itemsCount = self.realDataCount <= 1 || !self.isInfinite ? self.realDataCount : self.realDataCount * 200
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(.zero, animated: false)
                self.dealFirstPage()
            }
        }
    }
    
    /// 轮播时间间隔,默认为2.0s
    public var timeInterval: TimeInterval = 2.0
    
    /// 轮播方向,默认为水平
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            self.flowLayout.scrollDirection = self.scrollDirection
        }
    }
    
    /// 占位图(url图片未加载前显示的图)
    public var placeholderImage: UIImage? = nil {
        didSet {
            self.placeholderImageView.image = self.placeholderImage
        }
    }
    
    // MARK: - Item
    /// item的大小
    public var itemSize: CGSize? {
        didSet {
            if self.resourceType == .text {
                return
            }
            if let itemSize = self.itemSize {
                let width = min(self.bounds.size.width, itemSize.width)
                let height = min(self.bounds.size.height, itemSize.height)
                self.flowLayout.itemSize = CGSize(width: width, height: height)
            }
        }
    }
    
    /// 中间item的放大比例,默认为1.0
    public var itemZoomScale: CGFloat = 1.0 {
        didSet {
            if self.resourceType == .text {
                return
            }
            self.flowLayout.scale = self.itemZoomScale
        }
    }
    
    /// item的间距,默认为0.0
    public var itemSpacing: CGFloat = 0.0 {
        didSet {
            if self.resourceType == .text {
                return
            }
            self.flowLayout.minimumLineSpacing = self.itemSpacing
        }
    }
    
    /// item的圆角,默认为0.0
    public var itemCornerRadius: CGFloat = 0.0
    
    /// item的边框,默认为0.0
    public var itemBorderWidth: CGFloat = 0.0
    
    /// item的边框颜色,默认为clear
    public var itemBorderColor: UIColor = UIColor.clear
    
    /// 图片的填充模式,默认为scaleToFill
    public var imageContentMode: UIView.ContentMode = .scaleToFill
    
    // MARK: - Title
    /// 文本高度,默认为25.0
    public var titleViewHeight: CGFloat = 25.0
    
    /// 文本颜色,默认为white
    public var titleColor: UIColor = UIColor.white
    
    /// 文本字体,默认为13
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    /// 文本对齐方式,默认为left
    public var titleAlignment: NSTextAlignment = .left
    
    /// 文本背景颜色,默认为0.5的black
    public var titleBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    /// 文本默认为单行显示
    public var titleNumberOfLines: Int = 1
    
    /// 文本的breakMode
    public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping
    
    // MARK: - PageControl
    /// 是否显示pageControl,默认为false
    public var isShowPageControl = false {
        didSet {
            self.pageControl.isHidden = !self.isShowPageControl
        }
    }
    
    /// 是否可以点击pageControl的page,默认为true
    public var pageControlIsClickEnable: Bool = true {
        didSet {
            self.pageControl.isClickEnable = self.pageControlIsClickEnable
        }
    }
    
    /// 是否可以点击pageControl的page,默认为true
    public var pageControlIsAnimationEnable: Bool = false {
        didSet {
            self.pageControl.isAnimationEnable = self.pageControlIsAnimationEnable
        }
    }
    
    /// pageControl的高度,默认为25.0
    public var pageControlHeight: CGFloat = 25.0 {
        didSet {
            self.pageControl.frame = CGRect(x: 0, y: self.bounds.height - self.pageControlHeight, width: self.bounds.width, height: self.pageControlHeight)
            self.pageControl.updateFrame()
        }
    }
    
    /// pageControl的page间隔,默认为8.0
    public var pageControlSpacing: CGFloat = 8.0 {
        didSet {
            self.pageControl.pageSpacing = self.pageControlSpacing
        }
    }
    
    /// pageControl的page位置,默认为center
    public var pageControlAlignment: MZPageControlAlignment = .center {
        didSet {
            self.pageControl.alignment = self.pageControlAlignment
        }
    }
    
    /// pageControl的page大小,默认为(8.0,8.0)
    public var pageControlSize = CGSize(width: 8.0, height: 8.0) {
        didSet {
            self.pageControl.pageSize = self.pageControlSize
        }
    }
    
    /// pageControl的当前page大小
    public var pageControlCurrentSize: CGSize? {
        didSet {
            self.pageControl.currentPageSize = self.pageControlCurrentSize
        }
    }
    
    /// pageControl的page颜色,默认为gray
    public var pageControlIndictorColor = UIColor.gray {
        didSet {
            self.pageControl.pageIndicatorTintColor = self.pageControlIndictorColor
        }
    }
    
    /// pageControl的当前page颜色,默认为white
    public var pageControlCurrentIndictorColor = UIColor.white {
        didSet {
            self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentIndictorColor
        }
    }
    
    /// pageControl的page圆角
    public var pageControlRadius: CGFloat? {
        didSet {
            self.pageControl.pageCornerRadius = self.pageControlRadius
        }
    }
    
    /// pageControl的当前page圆角
    public var pageControlCurrentRadius: CGFloat? {
        didSet {
            self.pageControl.currentPageCornerRadius = self.pageControlCurrentRadius
        }
    }
    
    /// pageControl的page图片
    public var pageControlIndictorImage: UIImage? {
        didSet {
            self.pageControl.pageImage = self.pageControlIndictorImage
        }
    }
    
    /// pageControl的当前page图片
    public var pageControlCurrentIndictorImage: UIImage? {
        didSet {
            self.pageControl.currentPageImage = self.pageControlCurrentIndictorImage
        }
    }
    
    /// 选中item的事件回调
    public var didSelectedItem: ((_ index: Int) -> ())?
    
    /// 滚动到某一位置的事件回调
    public var didScrollToIndex: ((_ index: Int) -> ())?
    
    // MARK: - Lazy
    private lazy var placeholderImageView: UIImageView = {
        let placeholderImageView = UIImageView(frame: self.bounds)
        placeholderImageView.image = self.placeholderImage
        return placeholderImageView
    }()
    
    private lazy var flowLayout: MZBannerViewFlowLayout = {
        let flowLayout = MZBannerViewFlowLayout()
        flowLayout.itemSize = self.itemSize != nil ? self.itemSize! : self.bounds.size
        flowLayout.minimumInteritemSpacing = 10000
        flowLayout.minimumLineSpacing = self.itemSpacing
        flowLayout.scrollDirection = self.scrollDirection
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.0)
        collectionView.register(MZBannerCollectionViewCell.self, forCellWithReuseIdentifier: "bannerViewCellId")
        return collectionView
    }()
    
    private lazy var pageControl: MZPageControl = {
        let pageControl = MZPageControl(frame: CGRect(x: 0, y: self.bounds.height - self.pageControlHeight, width: self.bounds.width, height: self.pageControlHeight))
        pageControl.pageClickBlock = { [weak self] (index) in
            guard let `self` = self else {
                return
            }
            let targetIndex = self.isInfinite ? self.itemsCount / 2 + index : index
            self.scrollToItem(at: IndexPath(item: targetIndex, section: 0))
        }
        return pageControl
    }()
    
    /// item的个数
    private var itemsCount: Int = 0
    /// 实际数据的个数
    private var realDataCount: Int = 0
    /// 轮播类型(本地图片、网络图片、文本)
    private var resourceType: MZBannerResourceType = .image
    /// 定时器
    private var timer: Timer?
    /// 本地图片数组
    private var imagesGroup = [UIImage]()
    /// 网络图片地址数组
    private var imageUrlsGroup = [String]()
    /// 文本数组
    private var titlesGroup = [NSAttributedString]()
    /// 描述本地图标数组
    private var titleImagesGroup = [UIImage]()
    /// 描述网络图标地址数组
    private var titleImageUrlsGroup = [String]()
    /// 描述图标大小数组
    private var titleImageSizeGroup = [CGSize]()
    
    // MARK: - 初始化和UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            self.startTimer()
        } else {
            self.endTimer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flowLayout.itemSize = self.itemSize != nil ? self.itemSize! : self.bounds.size
        self.collectionView.frame = self.bounds
        self.collectionView.setContentOffset(.zero, animated: false)
        self.pageControl.frame = CGRect(x: 0, y: self.bounds.height - self.pageControlHeight, width: self.bounds.width, height: self.pageControlHeight)
        self.pageControl.updateFrame()
        self.dealFirstPage()
    }
    
    private func setupUI() {
        self.addSubview(self.placeholderImageView)
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
    }
}

// MARK: - 设置数据
extension MZBannerView {
    
    /// 设置本地轮播图片
    /// - Parameters:
    ///   - imagesGroup: 轮播图片数组
    ///   - titlesGroup: 描述文字数组
    ///   - attributedTitlesGroup: 描述文字数组
    public func setImagesGroup(_ imagesGroup: [UIImage]?, titlesGroup: [String]? = nil, attributedTitlesGroup: [NSAttributedString]? = nil) {
        if imagesGroup == nil || imagesGroup!.count == 0 {
            return
        }
        self.resourceType = .image
        self.realDataCount = imagesGroup!.count
        self.imagesGroup = imagesGroup!
        self.setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    
    /// 设置网络轮播图片
    /// - Parameters:
    ///   - urlsGroup: 轮播图片地址数组
    ///   - titlesGroup: 描述文字数组
    ///   - attributedTitlesGroup: 描述文字数组
    public func setImageUrlsGroup(_ urlsGroup: [String]?, titlesGroup: [String]? = nil, attributedTitlesGroup: [NSAttributedString]? = nil) {
        if urlsGroup == nil || urlsGroup!.count == 0 {
            return
        }
        self.resourceType = .imageUrl
        self.realDataCount = urlsGroup!.count
        self.imageUrlsGroup = urlsGroup!
        self.setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    
    /// 设置轮播文字
    /// - Parameters:
    ///   - titlesGroup: 轮播文字数组
    ///   - attributedTitlesGroup: 轮播文字数组
    public func setTitlesGroup(_ titlesGroup: [String]?, attributedTitlesGroup: [NSAttributedString]? = nil) {
        if attributedTitlesGroup == nil && titlesGroup == nil {
            return
        }
        self.resourceType = .text
        if attributedTitlesGroup != nil {
            if attributedTitlesGroup!.count == 0 {
                return
            }
            self.realDataCount = attributedTitlesGroup!.count
        } else {
            if titlesGroup!.count == 0 {
                return
            }
            self.realDataCount = titlesGroup!.count
        }
        self.setResource(titlesGroup, attributedTitlesGroup: attributedTitlesGroup)
    }
    
    /// 设置本地描述图标
    /// - Parameters:
    ///   - titleImagesGroup: 描述图标数组
    ///   - sizeGroup: 描述图标尺寸数组
    public func setTitleImagesGroup(_ titleImagesGroup: [UIImage]?, sizeGroup: [CGSize]?) {
        if titleImagesGroup == nil || sizeGroup == nil {
            return
        }
        self.titleImagesGroup = titleImagesGroup!
        self.titleImageSizeGroup = sizeGroup!
        self.collectionView.reloadData()
    }
    
    /// 设置网络描述图标
    /// - Parameters:
    ///   - titleImageUrlsGroup: 描述图标数组
    ///   - sizeGroup: 描述图标尺寸数组
    public func setTitleImageUrlsGroup(_ titleImageUrlsGroup: [String]?, sizeGroup:[CGSize]?) {
        if titleImageUrlsGroup == nil || sizeGroup == nil {
            return
        }
        self.titleImageUrlsGroup = titleImageUrlsGroup!
        self.titleImageSizeGroup = sizeGroup!
        self.collectionView.reloadData()
    }
    
    private func setResource(_ titlesGroup: [String]?, attributedTitlesGroup: [NSAttributedString]?) {
        self.placeholderImageView.isHidden = true
        self.itemsCount = self.realDataCount <= 1 || !self.isInfinite ? self.realDataCount : self.realDataCount * 200
        if attributedTitlesGroup != nil {
            self.titlesGroup = attributedTitlesGroup ?? []
        } else {
            let titles = titlesGroup?.map {
                return NSAttributedString(string: $0)
            }
            self.titlesGroup = titles ?? []
        }
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: false)
        self.dealFirstPage()
        self.pageControl.numberOfPages = self.realDataCount
        self.pageControl.currentPage = self.currentIndex() % self.realDataCount
        if self.resourceType == .text  {
            self.isShowPageControl = false
        }
        if self.isAutomatic {
            self.startTimer()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MZBannerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerViewCellId", for: indexPath) as! MZBannerCollectionViewCell
        let index = indexPath.item % self.realDataCount
        switch self.resourceType {
        case .image:
            cell.imageView.image = self.imagesGroup[index]
            cell.layer.borderWidth = self.itemBorderWidth
            cell.layer.borderColor = self.itemBorderColor.cgColor
            cell.layer.cornerRadius = self.itemCornerRadius
            cell.layer.masksToBounds = true
        case .imageUrl:
            cell.imageUrl(self.imageUrlsGroup[index], placeholder: self.placeholderImage)
            cell.layer.borderWidth = self.itemBorderWidth
            cell.layer.borderColor = self.itemBorderColor.cgColor
            cell.layer.cornerRadius = self.itemCornerRadius
            cell.layer.masksToBounds = true
        case .text:
            break
        }
        cell.titleContainerViewH = self.resourceType == .text ? collectionView.bounds.height : self.titleViewHeight
        cell.titleContainerView.backgroundColor = self.titleBackgroundColor
        cell.titleLabel.font = self.titleFont
        cell.titleLabel.textColor = self.titleColor
        cell.titleLabel.textAlignment = self.titleAlignment
        cell.titleLabel.numberOfLines = self.titleNumberOfLines
        let title = index < self.titlesGroup.count ? self.titlesGroup[index] : nil
        let titleImage = index < self.titleImagesGroup.count ? self.titleImagesGroup[index] : nil
        let titleImageUrl = index < self.titleImageUrlsGroup.count ? self.titleImageUrlsGroup[index] : nil
        let titleImageSize = index < self.titleImageSizeGroup.count ? self.titleImageSizeGroup[index] : nil
        cell.attributeString(title, titleImageUrl: titleImageUrl, titleImage: titleImage, titleImageSize: titleImageSize)
        cell.imageView.contentMode = self.imageContentMode
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let centerViewPoint = self.convert(collectionView.center, to: collectionView)
        if let centerIndex = collectionView.indexPathForItem(at: centerViewPoint) {
            if indexPath.item == centerIndex.item {
                let index = indexPath.item % self.realDataCount
                if self.didSelectedItem != nil {
                    self.didSelectedItem!(index)
                }
            } else {
                self.scrollToItem(at: indexPath)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MZBannerView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isAutomatic {
            self.endTimer()
            self.dealFirstPage()
            self.dealLastPage()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.isAutomatic {
            self.startTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = self.currentIndex() % self.realDataCount
        self.pageControl.currentPage = index
        if self.didScrollToIndex != nil {
            self.didScrollToIndex!(index)
        }
    }
}

// MARK: - 处理第一页和最后一页
extension MZBannerView {
    
    /// 获取当前页
    private func currentIndex() -> Int {
        let itemWH = self.scrollDirection == .horizontal ? self.flowLayout.itemSize.width + self.itemSpacing : self.flowLayout.itemSize.height + self.itemSpacing
        let offsetXY = self.scrollDirection == .horizontal ? self.collectionView.contentOffset.x : self.collectionView.contentOffset.y
        if itemWH == 0 {
            return 0
        }
        let index = round(offsetXY / itemWH)
        return Int(index)
    }
    
    /// 处理第一页
    private func dealFirstPage() {
        if self.currentIndex() == 0 && self.itemsCount > 1 && self.isInfinite {
            let targetIndex = self.itemsCount / 2
            self.scrollToItem(at: IndexPath(item: targetIndex, section: 0), animated: false)
            if self.didScrollToIndex != nil {
                self.didScrollToIndex!(0)
            }
        }
    }
    
    /// 处理最后一页
    private func dealLastPage() {
        if self.currentIndex() == self.itemsCount - 1 && self.itemsCount > 1 && self.isInfinite {
            let targetIndex = self.itemsCount / 2 - 1
            self.scrollToItem(at: IndexPath(item: targetIndex, section: 0), animated: false)
        }
    }
    
    /// 滚动到某一项
    private func scrollToItem(at indexPath: IndexPath, animated: Bool = true) {
        let scrollPosition: UICollectionView.ScrollPosition = self.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}

// MARK: - Timer
extension MZBannerView {
    
    /// 开启定时器
    private func startTimer() {
        // 非自动轮播或者页数只有一页
        if !self.isAutomatic || self.itemsCount <= 1 {
            return
        }
        self.endTimer()
        self.timer = Timer(timeInterval: self.timeInterval, target: self, selector: #selector(timeRepeatAction), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    /// 结束定时器
    private func endTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    /// 定时器任务
    @objc func timeRepeatAction() {
        let currentIndex = self.currentIndex()
        var targetIndex = currentIndex + 1
        if currentIndex == self.itemsCount - 1 {
            if self.isInfinite == false {
                return
            }
            self.dealLastPage()
            targetIndex = self.itemsCount / 2
        }
        self.scrollToItem(at: IndexPath(item: targetIndex, section: 0))
    }
}
