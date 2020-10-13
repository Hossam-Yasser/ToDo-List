//
//  SignInVC.swift
//  ToDoList
//
//  Created by Hossam on 9/19/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class SignInVC: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    var ref = Database.database().reference()
    var userArray = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    TextFieldBorder()
    btn.layer.cornerRadius = 5.0
    UserDefaultManager.shared().isLoggedIn = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func isDataEntered() -> Bool {
        guard EmailTextField.text != "" else {
            showAlertWithCancel(alertTitle: "Error",message: "Please Enter your E-mail",actionTitle: "Dismiss")
            return false
        }
        
        guard PasswordTextField.text != "" else {
            showAlertWithCancel(alertTitle: "Error",message: "Please Enter your Password",actionTitle: "Dismiss")
            return false
        }
        
        return true
    }
    
    private func isValidRegex() -> Bool{
        guard isValidEmail(email: EmailTextField.text) else{
            
            showAlertWithCancel(alertTitle: "Error", message: "please Enter Valid Email", actionTitle: "Dismiss")
            return false
        }
        guard isValidPassword(password: PasswordTextField.text) else{
            showAlertWithCancel(alertTitle: "Error", message: "Please Enter Valid Password", actionTitle: "Dissmiss")
            return false
        }
        return true
    }
    
    private func TextFieldBorder(){
        EmailTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        PasswordTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    
    private func goToDoList() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let toDoList = sb.instantiateViewController(withIdentifier: viewController.toDoList) as! ToDoListVC
        navigationController?.pushViewController(toDoList, animated: true)
        
    }
    
    
    private func getUserData() {
        ref.child("toDoUserNote").observe(.value,with: { (snapshot)in
            
            self.userArray = []
            if snapshot.exists() {
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result {
                        if let value = child.value as? [String: Any] {
                    let email = value["userEmail"] as? String ?? ""
                    let name = value["userName"] as? String ?? ""
                    let data = User(name: name, email: email)
                    self.userArray.append(data)
                
                        }
                    }
                }
            }
        })
    }
    
    
    private func signedUser()  {
        
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { [weak self] authResult, error in
            guard self != nil else { return }
            
            guard error == nil else {
                print(error!.localizedDescription)
                self?.showAlertWithCancel(alertTitle: "Error", message: "The account is not valid", actionTitle: "Cancel")
                return
            }
            for user in self!.userArray{
                if self!.EmailTextField.text! == user.email {
                    UserDefaultManager.shared().userName = user.name
                    
                }
            }
            UserDefaultManager.shared().userEmail = self!.EmailTextField.text!
            self!.goToDoList()
        
    }
    }
    
    
    
    @IBAction func pressedEmailTF(_ sender: UITextField) {
        EmailTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        EmailLabel.text = "Email"
        EmailTextField.placeholder = ""
    }
    @IBAction func unpressedEmailTF(_ sender: UITextField) {
        EmailTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        EmailLabel.text = ""
        EmailTextField.placeholder = "Email"
    }
    @IBAction func pressedPasswordTF(_ sender: UITextField) {
       PasswordTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        PasswordLabel.text = "Password"
        PasswordTextField.placeholder = ""
        
    }
    @IBAction func unpressedPasswordTF(_ sender: UITextField) {
        PasswordTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        PasswordLabel.text = ""
        PasswordTextField.placeholder = "Password"
    }
    
    
    
    
    
    @IBAction func SigninBTN(_ sender: UIButton) {
        if isDataEntered(){
            if isValidRegex(){
                 signedUser()
                
                
             }
          }
    }
    
    private func goToSignUP(){
        let signUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController.signUpVC) as! SignUpVC
        navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func BackToSignUpBTN(_ sender: UIButton) {
        goToSignUP()
    }
    
}
