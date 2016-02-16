

import UIKit
import MobileCoreServices


class DetailContainerTableController: UITableViewController {

    var currentContainer : AZSCloudBlobContainer?
    var model : [AZSCloudBlob]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateModel()
        
        self.title = currentContainer?.name
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "uploadContenido:")
        self.navigationItem.rightBarButtonItem = plusButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Azure Blobs lists
    
    func populateModel(){
        
        currentContainer?.listBlobsSegmentedWithContinuationToken(nil,
            prefix: nil,
            useFlatBlobListing: true,
            blobListingDetails: AZSBlobListingDetails.All,
            maxResults: -1,
            accessCondition: nil,
            requestOptions: nil,
            operationContext: nil,
            completionHandler: { (error : NSError?, resultSegment :AZSBlobResultSegment?) -> Void in
                
                if (error == nil){
                    self.model = resultSegment!.blobs as? [AZSCloudBlob]
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
                
        })
        
    }
    
    func uploadToStorage(data : NSData, blobName : String){
        
        let blobLocal = currentContainer?.blockBlobReferenceFromName(blobName)
//        var data : NSData?
//        data = UIImageJPEGRepresentation(UIImage(named: "picslack.jpg")!, 0.5)
        
        blobLocal?.uploadFromData(data,
            completionHandler: { (error : NSError?) -> Void in
                
                if (error != nil){
                    print("Error -> \(error)")
                }
                
                
        })
        
    }
    
    // MARK: - IBActions
    

    @IBAction func uploadContenido(sender: AnyObject) {
        
      
        startCaptureVideoBlogFromViewController(self, withDelegate: self)
        
        
    }
  
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if let model = model{
            rows = model.count
        }
        return rows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blobsIdentifier", forIndexPath: indexPath)

        let item = model![indexPath.row] as AZSCloudBlob

        cell.textLabel?.text = item.blobName
        
        return cell
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func saveInDocuments(data : NSData){
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePath = documents.stringByAppendingString("/video-\(NSUUID().UUIDString).mov")
        
        let existeElFichero = NSArray(contentsOfFile: filePath) as? [String]
        
        if existeElFichero == nil{
            data.writeToFile(filePath, atomically: true)
            
            uploadToStorage(data, blobName: "/video-\(NSUUID().UUIDString).mov")
        }
        
        
        
        
    }
    
    

}

extension DetailContainerTableController: UINavigationControllerDelegate{
    
}

extension DetailContainerTableController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if (mediaType == kUTTypeMovie as String){
            
            let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
            
            // tenemos que persistir en local - solo por aprender
            saveInDocuments(NSData(contentsOfURL: NSURL(fileURLWithPath: path!))!)
//            UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "video:didFisnishSavingWithError:contextInfo", nil)
            
            
        }
        
    }
    
    
}



















