//
//  ViewController.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data: [String] = ["MZPageControl", "MZBannerView"]
    var pageControlData = ["默认", "位置", "大小", "圆角", "图片"]
    var BannerViewData = ["本地图片", "网络图片", "文本", "本地图片+描述文本", "网络图片+描述文本"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "MZBanner"
        self.setupUI()
    }
    
    private func setupUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let bannerView = MZBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150))
        bannerView.placeholderImage = UIImage(named: "placeholder");
        bannerView.setImageUrlsGroup(["http://t.cn/RYVfQep", "http://t.cn/RYVfgeI", "http://t.cn/RYVfsLo", "http://t.cn/RYMuvvn", "http://t.cn/RYVfnEO", "http://t.cn/RYVf1fd"])
        bannerView.pageControlSize = CGSize(width: 10, height: 10)
        bannerView.pageControlCurrentSize = CGSize(width: 10, height: 10)
        bannerView.pageControlRadius = 5
        bannerView.pageControlCurrentRadius = 5
        bannerView.pageControlAlignment = .center
        tableView.tableHeaderView = bannerView
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.pageControlData.count
        } else if section == 1 {
            return self.BannerViewData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "identifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        if indexPath.section == 0 {
            cell?.textLabel?.text = self.pageControlData[indexPath.row]
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = self.BannerViewData[indexPath.row]
        }
        /*
        if indexPath.row < self.data.count {
            cell?.textLabel?.text = self.data[indexPath.row]
        } else if indexPath.row == self.data.count {
            let banner = MZBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150));
            banner.timeInterval = 3
            banner.setImageUrlsGroup(["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",
                                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",
                                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"])
            cell?.contentView.addSubview(banner)
        }
         */
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(MZPageControlVC(), animated: true)
        } else if indexPath.section == 1 {
            self.navigationController?.pushViewController(MZBannerViewVC(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 40))
        sectionView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        let titleLbl = UILabel(frame: CGRect(x: 12, y: 0, width: self.view.bounds.size.width - 20, height: 40))
        titleLbl.text = self.data[section]
        titleLbl.textColor = UIColor.black
        titleLbl.textAlignment = .left
        sectionView.addSubview(titleLbl)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

