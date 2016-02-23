//
//  DetailPostController.swift
//  MyVideoBlog
//
//  Created by Juan Antonio Martin Noguera on 23/02/16.
//  Copyright © 2016 Cloud On Mobile S.L. All rights reserved.
//

import UIKit

import MediaPlayer
import MobileCoreServices

class DetailPostController: UIViewController {

    var client : MSClient?
    var record : AnyObject?
    
    @IBOutlet weak var webView : UIWebView!
    @IBOutlet weak var titulo : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(record)
        // Do any additional setup after loading the view.
        titulo.text = record!["titulo"] as? String
        
        loadBlobFromAzure()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showBlob (sender: AnyObject){
        loadBlobWithAZSSdk()
    }

    // Cargar la url del blob 
    /*
        1) obtenemos la sas url de la property record, esto es un diccionario con la info del post que hemos selecionado, esto significa que tenemo el nombre del container y del blob. Tenemos que hacer un invoke a nuestra Custom API
    
        2) Esta sas url la usaremos para cargarla en la webview
    
    */
    
    func loadBlobFromAzure(){
        
        //1: extraemos del record el nombre del blob y el contenedor
        
        let blobName = record!["blobName"] as! String
        let containerName = record!["containername"] as! String
        
        //2: Invocar la Api
        
        client?.invokeAPI("urlsastoblobandcontainer",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName" : blobName, "containerName" : containerName],
            headers: nil,
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error: NSError?) -> Void in
                
                if error == nil{
                    
                    // 2: Tenemos solo la ruta del container/blob + la SASURL
                    let sasURL = result!["sasUrl"] as? String
                    
                    // 3: url del endpoint de Storage
                    var endPoint = "https://videoblogapp.blob.core.windows.net"
                    
                    endPoint += sasURL!
                    
                    // ahora le pasamo la url a la webView
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: endPoint)!))
                    })
                    
                }
                
        })
        
        
    }
    
    /*
    // MARK: en esta funcion usamos el SDK para descargar el blob del registro

*/
    func loadBlobWithAZSSdk(){
        
        //1: extraemos del record el nombre del blob y el contenedor
        
        let blobName = record!["blobName"] as! String
        let containerName = record!["containername"] as! String
        
        //2: Invocar la Api
        
        client?.invokeAPI("urlsastoblobandcontainer",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName" : blobName, "containerName" : containerName],
            headers: nil,
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error: NSError?) -> Void in
                
                if error == nil{
                    
                    // 2: Tenemos solo la ruta del container/blob + la SASURL
                    let sasURL = result!["sasUrl"] as? String
                    
                    // 3: url del endpoint de Storage
                    var endPoint = kEndpointAzureStorage
                    
                    endPoint += sasURL!
                    
                    let blob = AZSCloudBlockBlob(url: NSURL(string: endPoint)!)
                    
                    blob.downloadToDataWithCompletionHandler({ (error: NSError?, data : NSData?) -> Void in
                        
                        if let _ = error {
                            print("Tenemos un error --> \(error)")
                        } else {
                            
                            let path = saveInDocuments(data!)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let moviPlayer = MPMoviePlayerViewController(contentURL: path)
                                self.presentMoviePlayerViewControllerAnimated(moviPlayer)
                            })

                        }
                    })
                    
                }
                
        })
        
        
    }

}

extension UINavigationControllerDelegate {
    
}
