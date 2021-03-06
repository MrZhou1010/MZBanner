//
//  MZBannerViewFlowLayout.swift
//  MZBanner
//
//  Created by Mr.Z on 2019/11/16.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

class MZBannerViewFlowLayout: UICollectionViewFlowLayout {
    
    /// 比例
    public var scale: CGFloat = 1.0 {
        didSet {
            if self.scale > 1.0 {
                self.invalidateLayout()
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        if let collectionView = self.collectionView {
            if self.scrollDirection == .horizontal {
                let offset = (collectionView.frame.size.width - self.itemSize.width) / 2.0
                self.sectionInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
            } else {
                let offset = (collectionView.frame.size.height - self.itemSize.height) / 2.0
                self.sectionInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect), let collectionView = self.collectionView {
            let attriArr = NSArray(array: attributes, copyItems: true) as! [UICollectionViewLayoutAttributes]
            for attri in attriArr {
                var scale: CGFloat = 1.0
                var absOffset: CGFloat = 0
                let centerX = collectionView.bounds.size.width * 0.5 + collectionView.contentOffset.x
                let centerY = collectionView.bounds.size.height * 0.5 + collectionView.contentOffset.y
                if self.scrollDirection == .horizontal {
                    absOffset = abs(attri.center.x - centerX)
                    let distance = self.itemSize.width + self.minimumLineSpacing
                    if absOffset < distance {
                        scale = (1.0 - absOffset / distance) * (self.scale - 1.0) + 1.0
                        attri.zIndex = 1
                    }
                } else {
                    absOffset = abs(attri.center.y - centerY)
                    let distance = self.itemSize.height + self.minimumLineSpacing
                    if absOffset < distance {
                        scale = (1.0 - absOffset / distance) * (self.scale - 1.0) + 1.0
                        attri.zIndex = 1
                    }
                }
                attri.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            return attriArr
        }
        return nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var minSpace = CGFloat.greatestFiniteMagnitude
        var offset = proposedContentOffset
        if let collectionView = self.collectionView {
            let centerX = offset.x + collectionView.bounds.size.width / 2.0
            let centerY = offset.y + collectionView.bounds.size.height / 2.0
            var visibleRect: CGRect
            if self.scrollDirection == .horizontal {
                visibleRect = CGRect(origin: CGPoint(x: offset.x, y: 0), size: collectionView.bounds.size)
            } else {
                visibleRect = CGRect(origin: CGPoint(x: 0, y: offset.y), size: collectionView.bounds.size)
            }
            if let attriArr = self.layoutAttributesForElements(in: visibleRect) {
                for attri in attriArr {
                    if self.scrollDirection == .horizontal {
                        if abs(minSpace) > abs(attri.center.x - centerX) {
                            minSpace = attri.center.x - centerX
                        }
                    } else {
                        if abs(minSpace) > abs(attri.center.y - centerY) {
                            minSpace = attri.center.y - centerY
                        }
                    }
                }
            }
            if self.scrollDirection == .horizontal {
                offset.x += minSpace
            } else {
                offset.y += minSpace
            }
        }
        return offset
    }
}
