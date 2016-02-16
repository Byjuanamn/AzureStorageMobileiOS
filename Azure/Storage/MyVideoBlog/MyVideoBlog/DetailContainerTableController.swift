

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
        
        blobLocal?.uploadFromData(data,
            completionHandler: { (error : NSError?) -> Void in
                
                if (error != nil){
                    print("Error -> \(error)")
                }
                
                
        })
        
    }
    
    // MARK: - IBActions
    
    @IBAction func refreshTable(sender: AnyObject) {
        // actualizar modelo + mas la vista ...
        
        
        sender.endRefreshing()

    }

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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == .Delete) {
            updateLocalModelWithIndexpath(indexPath)
        }
        
    }
    
    func updateLocalModelWithIndexpath(index : NSIndexPath){
        
        tableView.beginUpdates()
        
        //eleiminando de la vista
        tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Automatic)
        
    // eleminar de azure
        deleteBlob(model![index.row])
    // eliminar del modelo local
        model?.removeAtIndex(index.row)
        
        tableView.endUpdates()
        
    }
    
    
    func deleteBlob(blob : AZSCloudBlob){
        
        blob.deleteWithCompletionHandler { (error : NSError?) -> Void in
            if (error != nil){
                print("error -> \(error)")
            }
        }
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
            
            uploadToStorage(data, blobName: "video-\(NSUUID().UUIDString).mov")
        }

    }
    // "video:didFisnishSavingWithError:contextInfo:"
    func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo info:AnyObject){
        
        var title = "Ok"
        var message = "Video grabado perfectamente"
        
        if let _ = error{
            
            title = "Fail"
            message = "El video no se ha grabado"
            
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        
        
    }


}

extension DetailContainerTableController: UINavigationControllerDelegate{
    
}

extension DetailContainerTableController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        dismissViewControllerAnimated(true, completion :nil)
        
        if (mediaType == kUTTypeMovie as String){
            
            let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
            
            // tenemos que persistir en local - solo por aprender
            saveInDocuments(NSData(contentsOfURL: NSURL(fileURLWithPath: path!))!)
            UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "video:didFinishSavingWithError:contextInfo:", nil)
            
            
        }
        
    }
    
    
}



















