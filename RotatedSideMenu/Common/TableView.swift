//
//  TableView.swift
//  RotatedSideMenu
//
//  Created by Ahmed on 11/25/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
import UIKit

class TableView: UITableView {
    override var contentSize: CGSize{
        didSet{ self.invalidateIntrinsicContentSize() }
    }
    
    override var intrinsicContentSize: CGSize{
        layoutIfNeeded()
        
        // Padding in normal cases will be 20 from top and 20
        // from bottom , so we get the value and multiply it by 2
        let padding = ((self.superview?.safeAreaInsets.top ?? 0) * 2)
        
        let height = UIScreen.main.bounds.height - padding
        let contentHeight = contentSize.height
        
        if contentHeight < height{
            return CGSize.init(width: UIView.noIntrinsicMetric, height: contentHeight)
        }else{
            return CGSize.init(width: UIView.noIntrinsicMetric, height: height)
        }
    }
}
