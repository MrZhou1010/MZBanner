//
//  MZPageControlVC.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/27.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class MZPageControlVC: UIViewController {
    
    public var type: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        let bannerView = MZBannerView(frame: CGRect(x: 0, y: kStatusNavBarHeight, width: self.view.bounds.size.width, height: 150.0))
        bannerView.timeInterval = 3.0
        bannerView.placeholderImage = UIImage(named: "icon_placeholder")
        bannerView.setImageUrlsGroup(["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",
                                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",
                                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"])
        bannerView.pageControlSize = CGSize(width: 10.0, height: 10.0)
        bannerView.pageControlCurrentSize = CGSize(width: 10.0, height: 10.0)
        bannerView.pageControlRadius = 5.0
        bannerView.pageControlCurrentRadius = 5.0
        bannerView.pageControlAlignment = .center
        bannerView.pageControlIsClickEnable = false
        self.view.addSubview(bannerView)
        switch self.type {
        case 0:
            bannerView.isShowPageControl = true
            bannerView.pageControlIsClickEnable = true
        case 1:
            bannerView.pageControlIndictorColor = UIColor.green
            bannerView.pageControlCurrentIndictorColor = UIColor.blue
        case 2:
            bannerView.pageControlCurrentSize = CGSize(width: 16.0, height: 8.0)
            bannerView.pageControlCurrentRadius = 4.0
            bannerView.pageControlIndictorColor = UIColor.green
            bannerView.pageControlCurrentIndictorColor = UIColor.blue
            bannerView.pageControlAlignment = .right
        case 3:
            bannerView.pageControlSize = CGSize(width: 12.0, height: 6.0)
            bannerView.pageControlCurrentSize = CGSize(width: 16.0, height: 8.0)
            bannerView.pageControlRadius = 3.0
            bannerView.pageControlCurrentRadius = 4.0
            bannerView.pageControlIndictorColor = UIColor.green
            bannerView.pageControlCurrentIndictorColor = UIColor.blue
        case 4:
            bannerView.pageControlSize = CGSize(width: 10.0, height: 6.0)
            bannerView.pageControlCurrentSize = CGSize(width: 20.0, height: 10.0)
            bannerView.pageControlRadius = 3.0
            bannerView.pageControlCurrentRadius = 5.0
            bannerView.pageControlIndictorColor = UIColor.green
            bannerView.pageControlCurrentIndictorColor = UIColor.blue
        case 5:
            bannerView.pageControlHeight = 30.0
            bannerView.pageControlSize = CGSize(width: 20.0, height: 20.0)
            bannerView.pageControlCurrentSize = CGSize(width: 25.0, height: 25.0)
            bannerView.pageControlIndictorImage = UIImage(named: "icon_page_normal")
            bannerView.pageControlCurrentIndictorImage = UIImage(named: "icon_page_selected")
        case 6:
            bannerView.pageControlIndictorColor = UIColor.green
            bannerView.pageControlCurrentIndictorColor = UIColor.blue
            bannerView.pageControlIsAnimationEnable = true
        default:
            break
        }
    }
}
