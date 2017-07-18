//
//  Extensions.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(format:String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UITableViewController {
    func showEmptyView(_ image:UIImage, text:String) {
        let containerView = UIView(frame: tableView.bounds)
        containerView.tag = 999
        tableView.addSubview(containerView)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        containerView.addSubview(label)
        containerView.addSubview(imageView)
        containerView.addConstraintsWithFormat(format: "H:[v0(150)]", views: imageView)
        containerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: label)
        containerView.addConstraintsWithFormat(format: "V:|-100-[v0(150)]-16-[v1]", views: imageView, label)
        containerView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0))
        containerView.backgroundColor = Color.backgroundColor
    }
    
    func hideEmptyView() {
        let views = tableView.subviews.filter { $0.tag == 999}
        if views.count > 0 {
            let v = views[0]
            v.removeFromSuperview()
        }
    }
}
