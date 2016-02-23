//
//  ViewController.swift
//  MyVideoBlog
//
//  Created by Juan Antonio Martin Noguera on 15/02/16.
//  Copyright © 2016 Cloud On Mobile S.L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let client = MSClient(
        applicationURLString:"https://myvideoblogjuanamn.azure-mobile.net/",
        applicationKey:"CGrpsXnMMsSQgDmjLVpetVqHuoDtlz11"

    )


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func logarseEnRedSocial(sender: AnyObject) {
        
    // primero comprobar si estamos logados
        if isUserloged() {
            
            print("Estamos logados")
            
            
            // Cargamos los datos del usuario que ya hizo login
            if let usrlogin = loadUserAuthInfo() {
                client.currentUser = MSUser(userId: usrlogin.usr)
                client.currentUser.mobileServiceAuthenticationToken = usrlogin.tok
                
            }
            
        } else{
           
            client.loginWithProvider("facebook", controller: self, animated: true, completion: { (user: MSUser?, error: NSError?) -> Void in
                
                if (error != nil){
                    print("Tenemos Problemas")
                } else{
                    
                    // Persistimos los credenciales del usuario
                    
                    
                    saveAuthInfo(user)
                    
                }
            })
        }
        
    }
 
    
    
    
    
    
    
    
    
    
    
    
    
    
}

