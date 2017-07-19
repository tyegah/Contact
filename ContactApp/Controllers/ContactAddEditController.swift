//
//  ContactAddEditController.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import UIKit

class ContactAddEditController: UITableViewController, UINavigationControllerDelegate {
    let cellId = "AddEditCell"
    let tableFields = ["First Name", "Last Name", "mobile", "email"]
    var contact:Contact? {
        didSet {
            if let _ = contact {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    var imagePickerController:UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popViewController))
        let saveBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveContact))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        tableView.register(AddEditCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.sectionIndexBackgroundColor = Color.backgroundColor
        imagePickerController = UIImagePickerController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Make the first textfield the first responder
        if let v = self.view.viewWithTag(1) {
            v.becomeFirstResponder()
        }
    }
    
    //actions
    func saveContact() {
        if let _ = self.contact {
            // Update contact
        }
        else {
            // Add new contact
            var firstName = ""
            var lastName = ""
            var phoneNumber = ""
            var emailAddress = ""
            if let firstNameTextfield = self.view.viewWithTag(1) as? UITextField, let lastNameTextfield = self.view.viewWithTag(2) as? UITextField, let phoneTextfield = self.view.viewWithTag(3) as? UITextField, let emailTextfield = self.view.viewWithTag(4) as? UITextField {
                firstName = firstNameTextfield.text!
                lastName = lastNameTextfield.text!
                emailAddress = emailTextfield.text!
                phoneNumber = phoneTextfield.text!
                
//                let contact = Contact(context: <#T##NSManagedObjectContext#>)
            }
            
        }
    }
    
    func openImagePicker() {
        self.popupAlert(title: "", message: "Choose Action",style:.actionSheet, actionTitles: ["Open Gallery", "Open Camera","Cancel"], actions: [{action1 in
            self.openGallery()
        },{action2 in
            self.openCamera()
        },nil])
    }
    
    func openGallery()
    {
        imagePickerController?.delegate = self
        imagePickerController?.allowsEditing = false
        imagePickerController?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePickerController!, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePickerController!.delegate = self
            imagePickerController!.allowsEditing = false
            imagePickerController!.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController!.cameraCaptureMode = .photo
            present(imagePickerController!, animated: true, completion: nil)
        } else {
            self.popupAlert(title: "Error", message: "This device has no camera.", style: .alert, actionTitles: ["OK"], actions: [nil])
        }
    }
    
    func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyBoardOnTap() {
        self.view.endEditing(true)
    }
}

extension ContactAddEditController:UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let contactImageView = self.view.viewWithTag(99) as? UIImageView {
            contactImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ContactAddEditController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        var nextTag = 1
        if tag < 4 {
            nextTag = textField.tag + 1
        }
        
        if let v = self.tableView.viewWithTag(nextTag) {
            v.becomeFirstResponder()
        }
        return false
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
        let headerView = AddEditHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        headerView.profileImgView.tag = 99
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoardOnTap))
        headerView.addGestureRecognizer(tapGesture)
        headerView.cameraImgView.isUserInteractionEnabled = true
        let addImageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        headerView.cameraImgView.addGestureRecognizer(addImageTap)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddEditCell
        cell.titleLabel.text = tableFields[indexPath.row]
        cell.textField.tag = indexPath.row + 1
        cell.textField.delegate = self
        if indexPath.row == 2 {
            cell.textField.keyboardType = .phonePad
        }
        
        if indexPath.row == 3 {
            cell.textField.keyboardType = .emailAddress
        }
        
        if let contact = self.contact {
            switch indexPath.row {
            case 0:
                cell.textField.text = contact.firstName
                break
            case 1:
                cell.textField.text = contact.lastName
                break
            case 0:
                cell.textField.text = contact.phoneNumber
                break
            case 0:
                cell.textField.text = contact.email
                break
            default:
                break
            }
        }
        
        cell.selectionStyle = .none
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
