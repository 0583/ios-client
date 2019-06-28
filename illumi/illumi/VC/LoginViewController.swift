//
//  LoginViewController.swift
//  illumi
//
//  Created by 0583 on 2019/6/27.
//  Copyright © 2019 0583. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var loginMainView: UIView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var loadingRing: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadingRing.stopAnimating()
        
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        
        userNameTextField.addTarget(self, action: #selector(checkButtonsValidation(_:)), for: UIControl.Event.editingChanged)
        passWordTextField.addTarget(self, action: #selector(checkButtonsValidation(_:)), for: UIControl.Event.editingChanged)
        
        checkButtonsValidation(userNameTextField)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        userNameTextField.text = ""
        passWordTextField.text = ""
        checkButtonsValidation(userNameTextField)
        userNameTextField.becomeFirstResponder()
    }


    @IBAction func UITapped(_ sender: UITapGestureRecognizer) {
        // Objective-C style
        // [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passWordTextField.becomeFirstResponder()
        } else if textField == passWordTextField {
            loginTapped()
        }
        return true
    }
    
    func goToNextPage() {
        DispatchQueue.main.async {
            self.loadingRing.stopAnimating()
            self.userNameTextField.isEnabled = true
            self.passWordTextField.isEnabled = true
            NSLog("Successfully Logged in!")
            let destinationStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let destinationViewController = destinationStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            self.present(destinationViewController, animated: true, completion: nil)
        }
    }
    
    func declareRetry(message: String) {
        DispatchQueue.main.async {
            self.loadingRing.stopAnimating()
            let controller = UIAlertController(title: "Failed to Login", message: "The server says “\(message)”. \nCheck your name and password, and try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
            
            self.userNameTextField.isEnabled = true
            self.passWordTextField.isEnabled = true
        }
    }
    
    @IBAction func checkButtonsValidation(_ sender: UITextField) {
        if userNameTextField.text == "" && passWordTextField.text == "" {
            resetButton.isEnabled = false
            loginButton.isEnabled = false
        } else {
            resetButton.isEnabled = true
            if userNameTextField.text == "" || passWordTextField.text == "" {
                loginButton.isEnabled = false
            } else {
                loginButton.isEnabled = true
            }
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginTapped()
    }
    
    
    func loginTapped() {
        
        if userNameTextField.text == "" || passWordTextField.text == "" {
            return
        }
        
        let userName = userNameTextField.text!
        let passWord = passWordTextField.text!
        
        loadingRing.startAnimating()
        
        userNameTextField.isEnabled = false
        passWordTextField.isEnabled = false
        
        
        DispatchQueue.global().async {
            LoginManager.performLogin(userName: userName,
                                      passWord: passWord,
                                      completionHandler: self.goToNextPage,
                                      failureHandler: self.declareRetry)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}