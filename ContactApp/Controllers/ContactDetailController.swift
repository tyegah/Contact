//
//  ContactDetailController.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import UIKit

class ContactDetailController: UITableViewController {
    let cellId = "DetailCell"
    var contact:Contact?
    let contactPresenter = ContactDetailPresenter(coreDataManager: CoreDataManager(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer))
    override func viewDidLoad() {
        super.viewDidLoad()
        contactPresenter.attachView(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadView(contact: contact)
    }
}

extension ContactDetailController:ContactDetailViewProtocol {
    override func setupViewLayout() {
        tableView.register(DetailCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = Color.backgroundColor
        let editBarButton = UIBarButtonItem(title:"Edit", style: .plain, target: self, action: #selector(editContact))
        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    func reloadView(contact:Contact?) {
        DispatchQueue.main.async {
            self.contact = contact
            self.tableView.reloadData()
        }
    }
    
    func editContact() {
        let addeditVC = ContactAddEditController(style: .plain)
        addeditVC.contact = contact
        let navVC = UINavigationController(rootViewController: addeditVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func makeCall() {
        
    }
    
    func makeFavorite() {
        contactPresenter.makeFavorite(contact: contact)
    }
    
    func sendEmail() {
        
    }
    
    func sendMessage() {
        
    }
}

// MARK: - Table view data source
extension ContactDetailController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
            // Configure the cell...
        if indexPath.row == 0 {
            cell.titleLabel.text = "mobile"
            cell.contentLabel.text = contact?.phoneNumber ?? ""
        }
        if indexPath.row == 1 {
            cell.titleLabel.text = "email"
            cell.contentLabel.text = contact?.email ?? ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 260))
        headerView.isUserInteractionEnabled = true
        headerView.profileImgView.loadImage(urlString: contact?.profilePic ?? "")
        headerView.nameLabel.text = "\(contact?.firstName ?? "") \(contact?.lastName ?? "")"
        if let bool = contact?.isFavorite {
            if bool {
                headerView.favoriteButton.setImage(UIImage(named:"favorite_selected"), for: .normal)
            }
            else {
                headerView.favoriteButton.setImage(UIImage(named:"favorite"), for: .normal)
            }
        }
    
        headerView.favoriteButton.addTarget(self, action: #selector(makeFavorite), for: .touchUpInside)
        headerView.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        headerView.emailButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        headerView.callButton.addTarget(self, action: #selector(makeCall), for: .touchUpInside)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 260
    }
}

class DetailCell:UITableViewCell {
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Color.lightGrayTextColor
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = Color.separatorColor
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "H:|-20-[v0(80)]-16-[v1]-8-|", views:titleLabel, contentLabel)
        addConstraintsWithFormat(format: "V:[v0(1)]-1-|", views: separatorView)
        addConstraintsWithFormat(format: "H:|-16-[v0]|", views: separatorView)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
}

class HeaderView:UIView {
    lazy var profileImgView:CachedImageView = {
        let imageView = CachedImageView(cornerRadius: 50, emptyImage: UIImage(named: "missing"))
        imageView.shouldUseEmptyImage = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Test Name"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        
        addSubview(profileImgView)
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
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = UIColor.red
        
        let buttonArray = [messageButton, callButton, emailButton, favoriteButton]
        let labelArray = [messageLabel, callLabel, emailLabel, favoriteLabel]
        for (index, button) in buttonArray.enumerated() {
            let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 56))
            buttonContainerView.isUserInteractionEnabled = true
            button.isUserInteractionEnabled  = true
            buttonContainerView.addSubview(button)
            buttonContainerView.addSubview(labelArray[index])
            buttonContainerView.addConstraintsWithFormat(format: "V:|[v0(40)]-2-[v1]", views: button,  labelArray[index])
            buttonContainerView.addConstraintsWithFormat(format: "H:|-5-[v0(40)]-5-|", views: button)
            buttonContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: labelArray[index])
            stackView.addArrangedSubview(buttonContainerView)
        }
        
        addSubview(stackView)
        
        addConstraintsWithFormat(format: "H:|-44-[v0]-44-|", views: stackView)
        addConstraintsWithFormat(format: "V:|-30-[v0(100)]-8-[v1]-12-[v2]", views: profileImgView, nameLabel, stackView)
        addConstraintsWithFormat(format: "H:[v0(100)]", views: profileImgView)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: nameLabel)
        
        addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
