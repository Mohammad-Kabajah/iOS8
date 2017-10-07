//
//  ViewController.swift
//  Autolayout
//
//  Created by Mohammad Kabajah on 9/1/15.
//  Copyright (c) 2015 Mohammad Kabajah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    var secure = false { didSet{ updateUI() } }

    var loggedInUser: User? { didSet{ updateUI() } }
    
    fileprivate func updateUI() {
        passwordField.isSecureTextEntry = secure
        passwordLabel.text  = secure ? "Secure Password" : "Password"
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
    }
    
    
    var image:UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            if let constraintedView = imageView{
                if let newImage = newValue {
                    aspeectRatioConstraint = NSLayoutConstraint(
                        item: constraintedView,
                        attribute: .width,
                        relatedBy: .equal,
                        toItem: constraintedView,
                        attribute: .height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                }
                else{
                    aspeectRatioConstraint = nil
                }
            }
        }
    }
    
    var aspeectRatioConstraint: NSLayoutConstraint?  {
        willSet{
            if let existingConstraint = aspeectRatioConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet{
            if let newConstraint = aspeectRatioConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
    
    @IBOutlet weak var loginField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
        
    }
    
    @IBAction func toggleSecurity(_ sender: UIButton) {
    secure = !secure
    }


    
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        }
        else{
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
