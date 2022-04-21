//
//  ViewController.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var data: [String] = ["MZPageControl", "MZBannerView"]
    
    private var pageControlData = ["默认", "颜色","位置", "大小", "圆角", "图片", "动画"]
    
    private var bannerViewData = ["本地图片", "本地图片+描述文本", "文本", "网络图片", "网络图片+描述文本"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MZBanner"
        self.setupUI()
    }
    
    private func setupUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        self.view.addSubview(tableView)
        let bannerView = MZBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150.0))
        bannerView.placeholderImage = UIImage(named: "icon_placeholder")
        bannerView.setImageUrlsGroup(["http://t.cn/RYVfQep",
                                      "http://t.cn/RYVfgeI",
                                      "http://t.cn/RYVfsLo",
                                      "http://t.cn/RYMuvvn",
                                      "http://t.cn/RYVfnEO",
                                      "http://t.cn/RYVf1fd"])
        bannerView.pageControlSize = CGSize(width: 10.0, height: 10.0)
        bannerView.pageControlCurrentSize = CGSize(width: 10.0, height: 10.0)
        bannerView.pageControlRadius = 5.0
        bannerView.pageControlCurrentRadius = 5.0
        bannerView.pageControlAlignment = .center
        bannerView.pageControlIsClickEnable = false
        tableView.tableHeaderView = bannerView
        tableView.tableFooterView = UIView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.pageControlData.count
        } else if section == 1 {
            return self.bannerViewData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.pageControlData[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = self.bannerViewData[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let pageControlVC = MZPageControlVC()
            pageControlVC.type = indexPath.row
            self.navigationController?.pushViewController(pageControlVC, animated: true)
        } else if indexPath.section == 1 {
            let bannerViewVC = MZBannerViewVC()
            bannerViewVC.type = indexPath.row
            self.navigationController?.pushViewController(bannerViewVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 40.0))
        sectionView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        let titleLbl = UILabel(frame: CGRect(x: 12.0, y: 0, width: self.view.bounds.size.width - 24.0, height: 40.0))
        titleLbl.text = self.data[section]
        titleLbl.textColor = UIColor.black
        titleLbl.textAlignment = .left
        sectionView.addSubview(titleLbl)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
