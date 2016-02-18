//
//  ViewPostController.swift
//  MyVideoBlog
//
//  Created by Juan Antonio Martin Noguera on 18/02/16.
//  Copyright © 2016 Cloud On Mobile S.L. All rights reserved.
//

import UIKit
import MobileCoreServices



class ViewPostController: UIViewController {

    @IBOutlet weak var saveInAzureButton: UIButton!
    @IBOutlet weak var validatorLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    
    var bufferVideo : NSData?
    var myBlobName : String?
    
    var client : MSClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Nuevo Post"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "capturarVideo:")
        self.navigationItem.rightBarButtonItem = plusButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveAzureAction(sender: AnyObject) {
        
        let tableVideos = client?.tableWithName("videos")
        
        tableVideos?.insert(["titulo": titleText.text!, "blobName" : myBlobName!, "container" : "temporal"], completion: { (insertItem, error : NSError?) -> Void in
            
            if error == nil {
                print("Todo OK....pero tenemos que subir el blob")
                
                self.uploadToStorage(self.bufferVideo!, blobName: self.myBlobName!)
            }
            
            
        })
        
    }
    
    func capturarVideo (sender : AnyObject){
        
        startCaptureVideoBlogFromViewController(self, withDelegate: self)
    }
    
    
    // MARK: - Metodos para la Captura de video
    
    func startCaptureVideoBlogFromViewController(viewcontroller: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool{
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false) {
            
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .Camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        presentViewController(cameraController, animated: true, completion: nil)
        
        return true
        
        
    }
    
    
    
    func saveInDocuments(data : NSData){
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePath = documents.stringByAppendingString("/video-\(NSUUID().UUIDString).mov")
        
        let existeElFichero = NSArray(contentsOfFile: filePath) as? [String]
        
        if existeElFichero == nil{
            data.writeToFile(filePath, atomically: true)
            
            bufferVideo = data
            myBlobName = "video-\(NSUUID().UUIDString).mov"
        }
        
    }
    
    func uploadToStorage(data : NSData, blobName : String){

        

        // obtener las sasurl
        
        client?.invokeAPI("generasasurl",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName": blobName, "ContainerName": "temporal"],
            headers: nil,
            completion: { (result:AnyObject?, response: NSHTTPURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                
                let sasUrl = result!["sasUrl"]
                
                let credentials = AZSStorageCredentials(SASToken: (sasUrl as? String)!);
                
                let account = AZSCloudStorageAccount(credentials: credentials, useHttps: false)
                
                let blobClient : AZSCloudBlobClient = account.getBlobClient()
                
                let container : AZSCloudBlobContainer = AZSCloudBlobContainer(name: "temporal", client: blobClient)
                
                let blobLocal = container.blockBlobReferenceFromName(blobName)
                
                // TODO: cambiar esta ñapa cuando sepamos valirdar usuarios
                
                
                blobLocal.uploadFromData(data,
                    completionHandler: { (error : NSError?) -> Void in
                        
                        if (error != nil){
                            print("Error -> \(error)")
                        }
                        
                })
                

            } else {
                
                print(error)
                
            }
            
            
        })

        
    }

}


extension ViewPostController: UINavigationControllerDelegate{
    
}

extension ViewPostController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        dismissViewControllerAnimated(true, completion :nil)
        
        if (mediaType == kUTTypeMovie as String){
            
            let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
            
            // tenemos que persistir en local - solo por aprender
            saveInDocuments(NSData(contentsOfURL: NSURL(fileURLWithPath: path!))!)
            
        }
        
    }
    
    
}

