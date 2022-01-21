//
//  ViewController.swift
//  Something
//
//  Created by vignesh kumar c on 19/01/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameField: CustomTextField!
    @IBOutlet weak var usenameErrorLbl: UILabel!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var passwordError1Lbl: UILabel!
    @IBOutlet weak var passwordErrorLbl2: UILabel!
    @IBOutlet weak var confirmPasswordField: CustomTextField!
    @IBOutlet weak var confirmFieldErrorLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var singInBtn: UIButton!
    
    @IBOutlet weak var showAndHideBtn: UIButton!
    var activeTextField : UITextField? = nil
    var showIcon: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
       NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupBtn()
        
        userNameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    func setupBtn() {
        let color1 = UIButton.UIColorFromRGB(0xEC8A82)
        let color2 = UIButton.UIColorFromRGB(0xF4C176)
        self.signUpBtn.applyGradient(colors: [color1.cgColor,color2.cgColor])
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        guard let name = userNameField.text, name.count > 4  else {
            showAlert(title: "Username error", message: " A minimum 4 character required")
        
            return
        }
        
    if !isPasswordHasNumberAndCharacterSign(password: self.passwordField.text ?? "") {
            
            showAlert(title: "Password error", message: "A minimum 8 characters required")
            return
        }
        if confirmPasswordField.text != passwordField.text {
            showAlert(title: "Password Incorrect", message: "password does not match")
            return
        }
    }
    
    @IBAction func iconClicked(_ sender: Any) {
       if(showIcon) {
            showIcon = false
            passwordField.isSecureTextEntry = false
            let image = UIImage(systemName: "eye.slash")
            showAndHideBtn.setImage(image, for: .normal)
        }else {
            showIcon = true
            passwordField.isSecureTextEntry = true
            let image1 = UIImage(systemName: "eye")
            showAndHideBtn.setImage(image1, for: .normal)
        }
    }
    
    func isPasswordHasNumberAndCharacterSign(password: String) -> Bool {
        let passWordRegEx = "[a-zA-Z0-9!@#$%^&*]+"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passWordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
}
extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 6

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
    static func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
}
extension ViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           return
        }
       
        var shouldMoveViewUp = false
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
}
    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
       self.view.endEditing(true)
    }
    
}
extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
   func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
