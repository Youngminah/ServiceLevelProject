//
//  DynamicCollectionView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/14.
//

import UIKit

class DynamicCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}
