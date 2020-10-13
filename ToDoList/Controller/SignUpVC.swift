//
//  SignUpVC.swift
//  ToDoList
//
//  Created by Hossam on 9/19/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class SignUpVC: UIViewController {
    
    var ref :DatabaseReference?

    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       Btn.layer.cornerRadius = 5.0
        TextFieldBorder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       Auth.auth().addStateDidChangeListener {(auth , user ) in
        }
            
    navigationController?.setNavigationBarHidden(true, animated: animated)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func TextFieldBorder(){
        UserNameTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        EmailTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        PasswordTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    private func isDataEntered() -> Bool {
        guard UserNameTextField.text != "" else {
            showAlertWithCancel(alertTitle: "Error",message: "Please Enter your Name",actionTitle: "Dismiss")
            return false
        }
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
    
    private func goToSignin() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signIn = sb.instantiateViewController(withIdentifier: viewController.signInVC ) as! SignInVC
        navigationController?.pushViewController(signIn, animated: true)
        
       
    }

   private func userSignUpData() -> Bool {
    let ref = Database.database().reference()

    ref.childByAutoId().setValue(["Email" : EmailTextField.text , "Name" : UserNameTextField.text])
    Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!, completion: { user, error in
        guard let uid = user?.user.uid else {return}
        let values = ["userEmail": self.EmailTextField.text! , "userName" : self.UserNameTextField.text!]
        Database.database().reference().child("toDoUserNote").child(uid).updateChildValues(values)
        })
    
    return true
    }
    @IBAction func pressedUserNameTF(_ sender: UITextField) {
        UserNameTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        UserNameLabel.text = "User Name"
        UserNameTextField.placeholder = ""
    }
    @IBAction func unpressedUserNameTF(_ sender: UITextField) {
        UserNameTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        UserNameLabel.text = ""
        UserNameTextField.placeholder = "User Name"
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
    

    
    @IBAction func SignUpBTN(_ sender: UIButton) {

       
        if isDataEntered(){
            if isValidRegex(){
                if userSignUpData(){
                goToSignin()
            }
         }
      }
    }
    
    @IBAction func GoToSignInBTN(_ sender: UIButton) {
        goToSignin()
    }
    
    
}

