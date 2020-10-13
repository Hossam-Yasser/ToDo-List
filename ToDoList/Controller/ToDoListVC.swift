//
//  ToDoList.swift
//  ToDoList
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase


class ToDoListVC: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    
    var arr = [note]()
    var ref = Database.database().reference()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
getData()
UserDefaultManager.shared().isLoggedIn = true
setTableView()
navigationBar()
    }
    
    
    private func getData() {
        guard let user = Auth.auth().currentUser else {return}
        let uid = user.uid
        
        ref.child("toDoUserNote").child(uid).child("notes").observe(.value, with:
            { (snapshot) in
                self.arr = []
                if snapshot.exists() {
                    
                    if let result = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        for child in result {
                            if let value = child.value as? [String: Any] {
                                let dateAndTime = value["date"] as? String ?? ""
                                let content = value["content"] as? String ?? ""
                                let id = child.key
                                let noteData = note(id: id, date: dateAndTime, content: content)
                                self.arr.append(noteData)
                                print(dateAndTime, content)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.TableView.reloadData()
                }
        })
        
    }

    
    private func navigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow") , style: .plain, target: self, action:  #selector(tapBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(tapBTN))
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .purple
        self.navigationItem.rightBarButtonItem!.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 25.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white],for: .normal)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = UserDefaultManager.shared().userName
        
    }
    
    
    func setTableView() {
        TableView.register(UINib(nibName: Cells.toDoListCell  , bundle: nil) , forCellReuseIdentifier: Cells.toDoListCell )
        SetDelegate()
        TableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func SetDelegate() {
        TableView.dataSource = self
        TableView.delegate = self
    }
    
    @objc private func tapBtn(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let signIn = sb.instantiateViewController(withIdentifier: viewController.signInVC ) as! SignInVC
        navigationController?.pushViewController(signIn, animated: true)
    }
    
    @objc private func tapBTN() {
        popUpView()
       
    }
    func popUpView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewController.popUpVc) as! PopUpVC
        // vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true;
        vc.definesPresentationContext = true;
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
}



extension ToDoListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.toDoListCell, for: indexPath) as? ToDoList else {
            
    return UITableViewCell()
    }
        cell.configure(note: self.arr[indexPath.row])
        return cell
    
 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
