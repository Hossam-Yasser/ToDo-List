//
//  Regex.swift
//  ToDoList
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 IOS. All rights reserved.
//
import UIKit

extension UIViewController{
    func isValidEmail(email: String?)-> Bool{
        guard email != nil else {return false}
        let regEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let pred = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(password: String?)-> Bool{
        guard password != nil else {return false}
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
        
}
    
    func showAlertWithCancel(alertTitle: String,message: String,actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alert,animated: true)
    }
    
}
