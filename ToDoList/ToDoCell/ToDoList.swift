//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import Firebase

class ToDoList: UITableViewCell {
    
    
    @IBOutlet weak var DateAndTimeLabel: UILabel!
    @IBOutlet weak var NoteNameLabel: UILabel!
    
    var noteRef: note?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(note: note) {
        DateAndTimeLabel.text = note.date
        NoteNameLabel.text = note.content
        noteRef = note
    }
    
    @IBAction func DeleteBtn(_ sender: UIButton) {
        
        let deleteAlert = UIAlertController(title: "Sorry", message: "Are You Sure You Want To Delete This TODO?", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            guard let user = Auth.auth().currentUser else {return}
            let uid = user.uid
            Database.database().reference().child("toDoUserNote").child(uid).child("notes").child(self.noteRef!.id!).removeValue()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(deleteAlert, animated: true, completion: nil)
        
        
    }
    
}
