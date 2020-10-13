//
//  PopUpVC.swift
//  ToDoList
//
//  Created by Hossam on 9/23/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class PopUpVC: UIViewController {
    
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       viewControllerBackground()
        setBlurBackground()
        setBlurBackground()
        createDatePicker()
        
    }
    
    private func setBlurBackground(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    private func viewControllerBackground(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewController.popUpVc) as! PopUpVC
        // vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true;
        vc.definesPresentationContext = true;
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    private func setTextFielsBorder(){
        dateAndTimeTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
        contentTextField.setBottomBorder(borderColor: UIColor.lightGray.cgColor, backgroundColor: UIColor.clear.cgColor)
    }
    
    func createDatePicker() {
       
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateAndTimePicking))
        toolbar.setItems([doneBtn], animated: true)
        datePicker.datePickerMode = .dateAndTime
        dateAndTimeTextField.inputAccessoryView = toolbar
        dateAndTimeTextField.inputView = datePicker
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: 0 , to: Date())
        
    }
    
    @objc func dateAndTimePicking() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        dateAndTimeTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    private func doneBTNPressed() {
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        let child = Database.database().reference().child("toDoUserNote").child(uid).child("notes").childByAutoId()
        let noteId = child.key
        let newNote = note(id: noteId, date: dateAndTimeTextField.text!, content: contentTextField.text!)
        let data = try! FirebaseEncoder().encode(newNote)
        child.setValue(data, withCompletionBlock: { (error,ref) in
            if let error = error {
                print("Faild to set value", error.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            }
            print("Successfully value set")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    
    @IBAction func pressedDateAndTimeTF(_ sender: UITextField) {
        dateAndTimeTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        dateAndTimeLabel.text = "DateAndTime"
        dateAndTimeTextField.placeholder = ""
    }
    
    @IBAction func unpressedDateAndTimeTF(_ sender: UITextField) {
        dateAndTimeTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        dateAndTimeLabel.text = ""
        dateAndTimeTextField.placeholder = "DateAndTime"
    }
    
    @IBAction func pressedContentTF(_ sender: UITextField) {
        contentTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        contentLabel.text = "Content"
        contentTextField.placeholder = ""
    }
    
    
    @IBAction func unpressedContentTF(_ sender: UITextField) {
        contentTextField.setBottomBorder(borderColor: UIColor.purple.cgColor, backgroundColor: UIColor.clear.cgColor)
        contentLabel.text = ""
        contentTextField.placeholder = "Content"
    }
    
    
    @IBAction func saveBTN(_ sender: UIButton) {
       
        doneBTNPressed()
    }
    
    
}

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
    
}

