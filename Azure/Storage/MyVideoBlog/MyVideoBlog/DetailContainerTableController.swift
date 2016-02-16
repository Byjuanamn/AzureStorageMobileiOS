

import UIKit

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
    
    func fakeUpload(){
        let blobLocal = currentContainer?.blockBlobReferenceFromName("blob-\(NSUUID().UUIDString)")
        var data : NSData?
        data = UIImageJPEGRepresentation(UIImage(named: "picslack.jpg")!, 0.5)
        
        blobLocal?.uploadFromData(data!,
            completionHandler: { (error : NSError?) -> Void in
                
                if (error != nil){
                    print("Error -> \(error)")
                }
                
                
        })
        
    }
    
    // MARK: - IBActions
    

    @IBAction func uploadContenido(sender: AnyObject) {
        
      
        fakeUpload()
        
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
