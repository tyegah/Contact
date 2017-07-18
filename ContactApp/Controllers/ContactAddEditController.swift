//
//  ContactAddEditController.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import UIKit

class ContactAddEditController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let cellId = "AddEditCell"
    let tableFields = ["First Name", "Last Name", "mobile", "email"]
    var contact:Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popViewController))
        let saveBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveContact))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        tableView.register(AddEditCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = Color.backgroundColor
    }
    
    //actions
    func saveContact() {
        if let _ = self.contact {
            // Update contact
        }
        else {
            // Add new contact
        }
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ContactAddEditController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = AddEditHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 260))
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddEditCell
        cell.titleLabel.text = tableFields[indexPath.row]
        return cell
    }
}

class AddEditCell:DetailCell {
    fileprivate lazy var textField:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentLabel.isHidden = true
        self.addSubview(textField)
        self.addConstraintsWithFormat(format: "H:|-20-[v0(80)]-16-[v1]-20-|", views:titleLabel, textField)
        self.addConstraintsWithFormat(format: "V:[v0(40)]", views: textField)
        addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddEditHeaderView:UIView {
    lazy var imageBackgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var profileImgView:UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "missing"))
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var cameraImgView:UIImageView = {
        let imageView = UIImageView(image:UIImage(named: "camera"))
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        backgroundColor = UIColor.black
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let topColor = UIColor(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 223/255.0, green: 243.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        addSubview(imageBackgroundView)
        addConstraintsWithFormat(format: "H:[v0(100)]", views: imageBackgroundView)
        addConstraintsWithFormat(format: "V:[v0(100)]", views: imageBackgroundView)
        addConstraint(NSLayoutConstraint(item: imageBackgroundView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageBackgroundView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        imageBackgroundView.addSubview(profileImgView)
        imageBackgroundView.addSubview(cameraImgView)
        imageBackgroundView.addConstraintsWithFormat(format: "H:[v0(100)]", views: profileImgView)
        imageBackgroundView.addConstraintsWithFormat(format: "V:[v0(100)]", views: profileImgView)
        imageBackgroundView.addConstraintsWithFormat(format: "H:[v0(40)]|", views: cameraImgView)
        imageBackgroundView.addConstraintsWithFormat(format: "V:[v0(40)]|", views: cameraImgView)
        imageBackgroundView.addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerX, relatedBy: .equal, toItem: imageBackgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        imageBackgroundView.addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerY, relatedBy: .equal, toItem: imageBackgroundView, attribute: .centerY, multiplier: 1, constant: 0))
        
//        addConstraint(NSLayoutConstraint(item: cameraImgView, attribute: ., relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
//        addConstraint(NSLayoutConstraint(item: cameraImgView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
