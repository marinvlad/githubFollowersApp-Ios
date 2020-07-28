//
//  UIView+Ext.swift
//  GitHub
//
//  Created by Vlad on 7/28/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(views : UIView...){
        for view in views {
            addSubview(view)
        }
    }
}
