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
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension ContactAddEditController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
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
        return cell
    }
}

class AddEditCell:DetailCell {
    fileprivate lazy var textField:UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
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
    lazy var profileImgView:CachedImageView = {
        let imageView = CachedImageView(cornerRadius: 50, emptyImage: UIImage(named: "missing"))
        imageView.shouldUseEmptyImage = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var profileBackgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 54
        return view
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Test Name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    lazy var messageButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "message"), for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var callButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "call"), for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var emailButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "email"), for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var favoriteButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.text = "message"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var callLabel:UILabel = {
        let label = UILabel()
        label.text = "call"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var emailLabel:UILabel = {
        let label = UILabel()
        label.text = "email"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var favoriteLabel:UILabel = {
        let label = UILabel()
        label.text = "favorite"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        return label
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
        
        addSubview(profileBackgroundView)
        addSubview(nameLabel)
        addSubview(messageButton)
        addSubview(callButton)
        addSubview(emailLabel)
        addSubview(emailButton)
        addSubview(favoriteLabel)
        addSubview(favoriteButton)
        addSubview(callLabel)
        addSubview(messageLabel)
        
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = UIColor.red
        stackView.clipsToBounds = true
        
        let buttonArray = [messageButton, callButton, emailButton, favoriteButton]
        let labelArray = [messageLabel, callLabel, emailLabel, favoriteLabel]
        for (index, button) in buttonArray.enumerated() {
            let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 56))
            buttonContainerView.addSubview(button)
            buttonContainerView.addSubview(labelArray[index])
            buttonContainerView.addConstraintsWithFormat(format: "V:|[v0(40)]-2-[v1]", views: button,  labelArray[index])
            buttonContainerView.addConstraintsWithFormat(format: "H:|-5-[v0(40)]-5-|", views: button)
            buttonContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: labelArray[index])
            stackView.addArrangedSubview(buttonContainerView)
        }
        
        addSubview(stackView)
        
        addConstraintsWithFormat(format: "H:|-44-[v0]-44-|", views: stackView)
        addConstraintsWithFormat(format: "V:|-30-[v0(108)]-8-[v1]-12-[v2]", views: profileBackgroundView, nameLabel, stackView)
        addConstraintsWithFormat(format: "H:[v0(108)]", views: profileBackgroundView)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: nameLabel)
        
        addConstraint(NSLayoutConstraint(item: profileBackgroundView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        profileBackgroundView.addSubview(profileImgView)
        profileBackgroundView.addConstraintsWithFormat(format: "V:[v0(100)]", views: profileImgView)
        profileBackgroundView.addConstraintsWithFormat(format: "H:[v0(100)]", views: profileImgView)
        profileImgView.image = UIImage(named: "missing")
        profileBackgroundView.addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerY, relatedBy: .equal, toItem: profileBackgroundView, attribute: .centerY, multiplier: 1, constant: 0))
        profileBackgroundView.addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerX, relatedBy: .equal, toItem: profileBackgroundView, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
