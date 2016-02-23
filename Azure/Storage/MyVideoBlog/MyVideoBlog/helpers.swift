//
//  helpers.swift
//  MyVideoBlog
//


import Foundation


let kEndpointMobileService = "https://myvideoblogjuanamn.azure-mobile.net/"
let kAppKeyMobileService = "XObHPCejvWSJAqJRHJshIiZSMLpaVA37"
let kEndpointAzureStorage = "https://videoblogapp.blob.core.windows.net"


func saveAuthInfo (currentUser : MSUser?){
    
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.userId, forKey: "userId")
    NSUserDefaults.standardUserDefaults().setObject(currentUser?.mobileServiceAuthenticationToken, forKey: "tokenId")
    
}


func loadUserAuthInfo() -> (usr : String, tok : String)? {
    
    let user = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
    let token = NSUserDefaults.standardUserDefaults().objectForKey("tokenId") as? String
    
    return (user!, token!)
}

func isUserloged() -> Bool {
    
    var result = false
    
    let userID = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
    
    if let _ = userID {
        result = true
    }
    
    return result
    
}


// MARK: - Esta funcion nos permite generar la url para guardar en el directorio documents un blob

func saveInDocuments(data : NSData) -> NSURL {
    
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let writePath = documents.stringByAppendingString("/videotemp.mov")
    
    let array = NSArray(contentsOfFile: writePath) as? [String]
    
    if array == nil {
        
        data.writeToFile(writePath, atomically: true)
        
        
    }
    
    return (NSURL(fileURLWithPath: writePath))
}
