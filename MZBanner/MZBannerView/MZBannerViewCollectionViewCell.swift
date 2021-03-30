//
//  MZBannerViewCollectionViewCell.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit
import Kingfisher

class MZBannerViewCollectionViewCell: UICollectionViewCell {
    
    public var imageView: UIImageView!
    
    public var titleLabel: UILabel!
    
    public var titleImageView: UIImageView!
    
    public var titleContainerView: UIView!
    
    public var titleContainerViewH: CGFloat = 25.0
    
    // MARK: - 初始化和UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
        self.setupTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.imageView = UIImageView.init(frame: self.contentView.bounds)
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
    }
    
    private func setupTitleLabel() {
        self.titleContainerView = UIView.init(frame: CGRect(x: 0, y: self.contentView.bounds.size.height - self.titleContainerViewH, width: self.contentView.bounds.size.width, height: self.titleContainerViewH))
        self.titleContainerView.isHidden = true
        self.contentView.addSubview(self.titleContainerView)
        self.titleImageView = UIImageView.init()
        self.titleContainerView.addSubview(self.titleImageView)
        self.titleLabel = UILabel.init()
        self.titleLabel.clipsToBounds = true
        self.titleContainerView.addSubview(self.titleLabel)
    }
    
    // MARK: - Function
    /// 设置本地图或者网络图
    public func imageUrl(_ imageUrl: String?, placeholder: UIImage?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.imageView.image = placeholder
            return
        }
        self.imageView.kf.setImage(with: url, placeholder: placeholder)
    }
    
    /// 设置描述文本及图标
    public func attributeString(_ attributeString: NSAttributedString?, titleImageUrl: String? = nil, titleImage: UIImage? = nil, titleImageSize: CGSize? = nil) {
        self.titleLabel.attributedText = attributeString
        self.titleContainerView.frame = CGRect(x: 0, y: self.contentView.bounds.size.height - self.titleContainerViewH, width: self.contentView.bounds.size.width, height: self.titleContainerViewH)
        self.titleContainerView.isHidden = (attributeString == nil || attributeString?.string == "") ? true : false
        let containerViewSize = self.titleContainerView.bounds.size
        if let imageSize = titleImageSize {
            self.titleImageView.frame = CGRect(x: 5, y: (containerViewSize.height - imageSize.height) / 2.0, width: imageSize.width, height: imageSize.height)
            self.titleLabel.frame = CGRect(x: 8 + imageSize.width, y: 0, width: containerViewSize.width - 8 - imageSize.width - 5, height: containerViewSize.height)
        } else {
            self.titleImageView.frame = CGRect.zero
            self.titleLabel.frame = CGRect(x: 5, y: 0, width: containerViewSize.width - 10, height: containerViewSize.height)
        }
        if titleImageUrl != nil {
            if let url = URL(string: titleImageUrl!) {
                self.titleImageView.kf.setImage(with: url)
            }
        } else {
            self.titleImageView.image = titleImage
        }
    }
}
