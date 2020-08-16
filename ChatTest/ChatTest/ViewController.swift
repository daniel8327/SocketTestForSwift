//
//  ViewController.swift
//  ChatTest
//
//  Created by 장태현 on 2020/08/15.
//  Copyright © 2020 장태현. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var nickname: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if nickname == nil {
            askForNickname { bool in
                
                
                if bool {
                    SocketIOManager.shared.connectToServerWithNickname(nickname: self.nickname, completionhandler: { (userList) -> Void in
                        
                        print("현재 접속인원 \(userList)")
                    })
                    
                    SocketIOManager.shared.getChatMessage { datas in
                        self.textView.text += "\n\(datas)"
                    }
                }
                else {
                    fatalError()
                }
            }
        }
    }
    
    @IBAction func disconnetSocket(_ sender: Any) {
        SocketIOManager.shared.socket.disconnect()
    }
    
    @IBAction func connectSocket(_ sender: Any) {
        SocketIOManager.shared.socket.connect()
    }
    
    @IBAction func sendData(_ sender: Any) {
        SocketIOManager.shared.sendMessage(message: self.textField.text!, nickName: nickname)
    }
    
    func askForNickname(_ completion: @escaping (_ isDone: Bool) -> Void) {
        
        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField(configurationHandler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) -> Void in
            let textfield = alertController.textFields![0]
            if textfield.text?.count == 0 {
                completion(false)
            }
            else {
                
                
                self.nickname = textfield.text
                
                completion(true)
            }
        }
        
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

