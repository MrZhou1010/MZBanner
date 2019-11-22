//
//  ViewController.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data: [String] =  ["MZPageControl", "MZBannerView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "MZBanner"
        self.setupUI()
    }
    
    private func setupUI() {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let bannerView = MZBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150))
        //bannerView.placeholderImage = #imageLiteral(resourceName: "placeholder");
        bannerView.setImageUrlsGroup(["http://t.cn/RYVfQep",
                                      "http://t.cn/RYVfgeI",
                                      "http://t.cn/RYVfsLo",
                                      "http://t.cn/RYMuvvn",
                                      "http://t.cn/RYVfnEO",
                                      "http://t.cn/RYVf1fd"])
        bannerView.pageControlSize = CGSize(width: 10, height: 10)
        bannerView.pageControlRadius = 5
        bannerView.pageControlAlignment = .right
        tableView.tableHeaderView = bannerView
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "identifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            //self.navigationController?.pushViewController(MZPageControlVC(), animated: true)
        } else if indexPath.row == 1 {
            //self.navigationController?.pushViewController(MZBannerVC(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == self.data.count ? 150 : 50
    }
}

