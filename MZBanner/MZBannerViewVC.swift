//
//  MZBannerViewVC.swift
//  MZBanner
//
//  Created by 木木 on 2019/11/27.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class MZBannerViewVC: UIViewController {
    
    public var type: Int = 0 {
        didSet {
            
        }
    }
    
    private lazy var bannerView: MZBannerView = {
       let bannerView: MZBannerView = MZBannerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 160));
        bannerView.placeholderImage = UIImage(named: "placeholder");
        return bannerView;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.bannerView)
    }

}
