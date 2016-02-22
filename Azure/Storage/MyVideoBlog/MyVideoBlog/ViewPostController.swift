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
        
        titleText.delegate = self
        
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
        
        let tablaVideos = client?.tableWithName("videoblogs")
        
        // 1: Partimos de la base de tener ya el video y en primer lugar guardamos en base de datos
        
        
        tablaVideos?.insert(["titulo" : titleText.text!, "blobName" : myBlobName!, "containername" : "pruebas"], completion: { (inserted, error: NSError?) -> Void in
            
            if error != nil{
                print("Tenemos un error -> : \(error)")
            } else {
                
                // 2: Persistir el blob en el Storage
                print("Primera parte superada (Ya tenemos el registro en la BBDD, ahora toca blob")
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

        // vamos a invoke la api urlsastoblobandcontainer para obtener una url para poder subir
        
        //1: Invocar la Api
        
        client?.invokeAPI("urlsastoblobandcontainer",
            body: nil,
            HTTPMethod: "GET",
            parameters: ["blobName" : myBlobName!, "ContainerName" : "pruebas"],
            headers: nil,
            completion: { (result : AnyObject?, response : NSHTTPURLResponse?, error: NSError?) -> Void in
                
                if error == nil{
                    
                    // 2: Tenemos solo la ruta del container/blob + la SASURL
                    let sasURL = result!["sasUrl"] as? String
                    
                    // 3: url del endpoint de Storage
                    var endPoint = "https://videoblogapp.blob.core.windows.net"
                    
                    endPoint += sasURL!
                    
                    // 4: Hemos apuntado al container de AZure Storage
                    let container = AZSCloudBlobContainer(url: NSURL(string: endPoint)!)
                    
                    // 5: Creamo nuestro blob local
                    
                    let blobLocal = container.blockBlobReferenceFromName(blobName)
                    
                    // 6: Vamos a hacer el upload de nuestro blob local + NSData
                    
                    blobLocal.uploadFromData(data,
                        completionHandler: { (error: NSError?) -> Void in
                            
                            if error == nil {
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.saveInAzureButton.enabled = false
                                    
                                })
                            } else {
                                print("Tenemos un error -> \(error)")
                            }
        
                    })
                    
                }
                
        })
        
    }

}


extension ViewPostController: UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        let currentString = textField.text! as NSString
        
        if (currentString.length > 10) {
            validatorLabel.text = "Este titulo mola"
            validatorLabel.textColor = UIColor.greenColor()
            saveInAzureButton.enabled = true
        }
        
        
        return true
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

