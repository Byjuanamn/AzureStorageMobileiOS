

import UIKit

class ContainersTableController: UITableViewController {

   
    
    let account = AZSCloudStorageAccount(fromConnectionString: "DefaultEndpointsProtocol=https;AccountName=videoblogapp;AccountKey=MaRn1e2rvWYZh+zzlbMZVoHiikmNNCrzT6Gjvixh4Thtj4Wv2DfTxbR1Ab+PAvixt5r5nCt0SBCX8LdbYrLhYA==")
    
    var model : [AZSCloudBlobContainer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Azure Storage Containers Model
    func populateModel(){
        
        let blobClient : AZSCloudBlobClient = account.getBlobClient()
        
        blobClient.listContainersSegmentedWithContinuationToken(nil) { (error : NSError?, resultSegment : AZSContainerResultSegment?) -> Void in
            
            if (error == nil){
                self.model = resultSegment?.results as? [AZSCloudBlobContainer]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })

            }
            
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var rows = 0
        
        if let model = model {
            rows = model.count
        }

        return rows
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaContainer", forIndexPath: indexPath)

        let contendor : AZSCloudBlobContainer = model![indexPath.row]

        cell.textLabel?.text = contendor.name
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("containerDetail", sender: indexPath)
    }

   
  
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "containerDetail"){
            let vc = segue.destinationViewController as? DetailContainerTableController
            let index = sender as! NSIndexPath
            vc?.currentContainer = model![index.row]
            
        }
    }
   

}









