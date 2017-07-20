//
//  Extensions.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func convertServerTimeToDate() -> Date? {
        print("string time",self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dateFormatter:DateFormatter
        if appDelegate.dateFormatter == nil {
            appDelegate.dateFormatter = DateFormatter()
        }
        dateFormatter = appDelegate.dateFormatter!
        //        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
//        let date = dateFormatter.date(from: self)
//        print("converted time \(date)")
//        print("now date \(Date())")
        return dateFormatter.date(from: self)
    }
}

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
extension UIViewController {
    func popupAlert(title: String?, message: String?, style:UIAlertControllerStyle, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for (index, title) in actionTitles.enumerated() {
            var actionStyle:UIAlertActionStyle = .default
            if title?.lowercased() == "cancel" {
                actionStyle = .cancel
            }
            
            let action = UIAlertAction(title: title, style: actionStyle, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController:ContactBaseProtocol {
    var activityIndicator:UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        ai.hidesWhenStopped = true
        ai.center = self.view.center
        return ai
    }
    
    func setupViewLayout() {
        
    }
    
    func showLoadingIndicator() {
        self.view.addSubview(self.activityIndicator)
        self.view.bringSubview(toFront: self.activityIndicator)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.activityIndicator.removeFromSuperview()
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
