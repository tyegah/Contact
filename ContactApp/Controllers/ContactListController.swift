//
//  ViewController.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/17/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import UIKit

class ContactListController: UITableViewController {
    let cellId = "CellId"
    var contacts:[Contact]?
    var indices:[String]?
    let contactPresenter = ContactListPresenter(coreDataManager: CoreDataManager(persistentContainer: (UIApplication.shared.delegate as! AppDelegate).persistentContainer))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactPresenter.attachView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactPresenter.loadContacts()
    }
    
    func getContactsForSection(section:Int) -> [Contact] {
        return contacts?.filter{ ($0.firstName?.characters.first?.description ?? "").lowercased() == indices![section].lowercased()} ?? []
    }
}

extension ContactListController:ContactListViewProtocol {
    override func setupViewLayout() {
        self.navigationItem.title = "Contact"
        let leftBarButton = UIBarButtonItem(title: "Groups", style: .plain, target: self, action: #selector(showGroups))
        let rightBarButton = UIBarButtonItem(image: UIImage(named:"plus"), style: .plain, target: self, action: #selector(addContact))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        tableView.bounces = true
        self.refreshControl?.isEnabled = true
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = Color.backgroundColor
        tableView.sectionIndexColor = UIColor.black
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.white
        self.refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func handleRefresh() {
        self.refreshControl?.beginRefreshing()
        contactPresenter.loadContacts()
        self.refreshControl?.endRefreshing()
    }
    
    func loadContacts(contacts: [Contact]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if contacts.count == 0 && appDelegate.isFirstLoad {
            appDelegate.isFirstLoad = false
            contactPresenter.loadContacts()
            return
        }
        
        var chars = contacts.map{ $0.firstName?.characters.first?.description.uppercased() ?? ""}
        chars = chars.sorted{ $0 < $1 }
        var i = 0
        var tempIndices = [String]()
        while chars.count > 0 {
            let char = chars[0]
            tempIndices.append(char)
            chars = chars.filter{ $0 != char }
            i += 1
        }
        
        indices = tempIndices.sorted { $0 < $1 }
        self.contacts = contacts
        DispatchQueue.main.async {
            if contacts.count > 0 {
                self.hideEmptyView()
            }
            self.tableView.reloadData()
        }
    }
    
    func setEmptyUsers() {
        showEmptyView(UIImage(named:"empty_box")!, text: "Oops! It seems like you have no contacts yet.")
    }
    
    //Actions
    func showGroups() {
        
    }
    
    func addContact() {
        let addeditVC = ContactAddEditController(style: .plain)
        let navVC = UINavigationController(rootViewController: addeditVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func showDetailContact(contact: Contact?) {
        let detailVC = ContactDetailController(style: .plain)
        detailVC.contact = contact
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: UItableView Datasource & Delegate
extension ContactListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let count = indices?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getContactsForSection(section: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        let contact = getContactsForSection(section: indexPath.section)[indexPath.row]
        cell.setupView(contact: contact)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indices
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indices?[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = getContactsForSection(section: indexPath.section)[indexPath.row]
        contactPresenter.loadDetailContact(Int(contact.id))
    }
}

class ContactCell:UITableViewCell {
    fileprivate lazy var profileImgView:CachedImageView = {
        let imageView = CachedImageView(cornerRadius: 20, emptyImage: UIImage(named: "missing"))
        imageView.shouldUseEmptyImage = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    fileprivate lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    fileprivate lazy var starImgView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    
    fileprivate lazy var separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = Color.separatorColor
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        addSubview(profileImgView)
        addSubview(nameLabel)
        addSubview(starImgView)
        addSubview(separatorView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(40)]-16-[v1]-8-[v2(20)]-32-|", views: profileImgView, nameLabel, starImgView)
        addConstraintsWithFormat(format: "V:[v0(40)]", views: profileImgView)
        addConstraintsWithFormat(format: "V:[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: starImgView)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: separatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]-1-|", views: separatorView)
        
        
        addConstraint(NSLayoutConstraint(item: profileImgView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: starImgView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    func setupView(contact:Contact) {
        nameLabel.text = "\(contact.firstName ?? "") \(contact.lastName ?? "")"
        starImgView.image = contact.isFavorite ? UIImage(named:"star") : UIImage(named:"star_empty")
        profileImgView.loadImage(urlString: contact.profilePic ?? "")
    }
}
