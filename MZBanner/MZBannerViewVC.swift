//
//  MZBannerViewVC.swift
//  MZBanner
//
//  Created by 木木 on 2019/11/27.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class MZBannerViewVC: UIViewController {
    
    public var type: Int = 0
    
    private lazy var bannerView: MZBannerView = {
        let bannerView: MZBannerView = MZBannerView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: 160));
        bannerView.placeholderImage = UIImage(named: "placeholder");
        return bannerView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.addSubview(self.bannerView)
        
        switch self.type {
        case 0:
            let localImages: [UIImage] = [UIImage(named: "baner_pic1")!, UIImage(named: "baner_pic2")!, UIImage(named: "baner_pic3")!, UIImage(named: "baner_pic4")!]
            self.bannerView.setImagesGroup(localImages)
            self.bannerView.itemSize = CGSize(width: self.view.bounds.size.width - 100, height: (self.view.bounds.size.width - 100) * 300 / 750)
            self.bannerView.itemSpacing = 40
            self.bannerView.itemZoomScale = 1.2
            
            self.bannerView.itemBorderWidth = 1.0
            self.bannerView.itemBorderColor = UIColor.gray
            
            self.bannerView.didSelectedItem = {
                print("点击第\($0)个item")
            }
        case 1:
            let localImages: [UIImage] = [UIImage(named: "baner_local_1")!, UIImage(named: "baner_local_2")!, UIImage(named: "baner_local_3")!, UIImage(named: "baner_local_4")!, UIImage(named: "baner_local_5")!]
            let titles: [String] = ["正在直播·2017维密直播大秀\n天使惊艳合体性感开撩", "猎场-会员抢先看\n胡歌陈龙联手戳穿袁总阴谋", "我的！体育老师\n好样的！前妻献媚讨好 张嘉译一口回绝", "小宝带你模拟断案！\n开局平民，晋升全靠运筹帷幄", "【挑战极限·精华版】孙红雷咆哮洗车被冻傻"]
            let attributedTitles = titles.map { (str) -> NSAttributedString in
                let arr = str.components(separatedBy: "\n")
                let attriStr = NSMutableAttributedString(string:str as String)
                attriStr.addAttributes([.foregroundColor: UIColor.green, .font: UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, arr[0].count))
                if arr.count > 1 {
                    attriStr.addAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 11)], range: NSMakeRange(arr[0].count + 1, arr[1].count))
                }
                return attriStr
            }
            self.bannerView.setImagesGroup(localImages, titlesGroup: titles, attributedTitlesGroup: attributedTitles)
            self.bannerView.itemSize = CGSize(width: self.view.bounds.size.width - 50, height: (self.view.bounds.size.width - 50) * 300 / 750)
            self.bannerView.timeInterval = 3
            self.bannerView.itemSpacing = 10
            
            self.bannerView.titleBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            self.bannerView.titleNumberOfLines = 0
            self.bannerView.titleViewHeight = 40
            self.bannerView.itemBorderWidth = 1.0
            
            self.bannerView.showPageControl = false
            
            self.bannerView.didSelectedItem = {
                print("点击第\($0)个item")
            }
        case 2:
            let titles: [String] = ["更多title/item/pageControl使用方式，请参考API", "GitHub: https://github.com", "如有问题，欢迎issue或者联系邮箱", "欢迎star✨✨✨✨✨✨，谢谢支持!"]
            let titleImages = [#imageLiteral(resourceName: "activity"),#imageLiteral(resourceName: "activity"),#imageLiteral(resourceName: "activity")]
            let sizeGroup = [CGSize(width: 30, height: 15), CGSize(width: 30, height: 15), CGSize(width: 30, height: 15)]
            self.bannerView.setTitlesGroup(titles, attributedTitlesGroup: nil)
            self.bannerView.setTitleImagesGroup(titleImages, sizeGroup: sizeGroup)
            self.bannerView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: 30)
            self.bannerView.titleBackgroundColor = UIColor.white
            self.bannerView.titleColor = UIColor.red
            self.bannerView.scrollDirection = .vertical
            
            self.bannerView.didSelectedItem = {
                print("点击第\($0)个item")
            }
        case 3:
            let imageUrls: [String] = ["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",  "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",  "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"]
            self.bannerView.placeholderImage = UIImage(named: "placeholder")
            self.bannerView.setImageUrlsGroup(imageUrls, titlesGroup: nil, attributedTitlesGroup: nil)
            self.bannerView.pageControlIndictirColor = UIColor.green
            self.bannerView.pageControlCurrentIndictirColor = UIColor.red
            self.bannerView.scrollDirection = .vertical
            
            self.bannerView.didSelectedItem = {
                print("点击第\($0)个item")
            }
        case 4:
            let imageUrls: [String] = ["http://t.cn/RYMuvvn", "http://t.cn/RYVfnEO", "http://t.cn/RYVf1fd", "http://t.cn/RYVfgeI", "http://t.cn/RYVfsLo"]
            self.bannerView.placeholderImage = UIImage(named: "placeholder")
            self.bannerView.timeInterval = 3
            self.bannerView.setImageUrlsGroup(imageUrls, titlesGroup: nil, attributedTitlesGroup: nil)
            self.bannerView.pageControlSize = CGSize(width: 16, height: 4)
            self.bannerView.pageControlCurrentSize = CGSize(width: 16, height: 6)
            self.bannerView.pageControlIndictirColor = UIColor.red
            self.bannerView.pageControlCurrentIndictirColor = UIColor.blue
            
            self.bannerView.itemSize = CGSize(width: 240, height: 90)
            self.bannerView.itemZoomScale = 1.2
            self.bannerView.itemSpacing = 20
            
            self.bannerView.didSelectedItem = {
                print("点击第\($0)个item")
            }
        default:
            break
        }
    }
}
