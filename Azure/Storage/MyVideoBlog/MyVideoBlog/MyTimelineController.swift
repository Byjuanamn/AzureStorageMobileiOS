
import UIKit




class MyTimelineController: UITableViewController {

    let client = MSClient(applicationURL:
        NSURL(string: "https://myvideoblogjuanamn.azure-mobile.net/"), applicationKey: "CGrpsXnMMsSQgDmjLVpetVqHuoDtlz11")
    
    var model : [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mis videos blog"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewVideoPost:")
        self.navigationItem.rightBarButtonItem = plusButton
        
        // modelo publicar

        populateModel()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows = 0
        if model != nil {
            rows = (model?.count)!
        }
        return rows
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videos", forIndexPath: indexPath)

        cell.textLabel?.text = model![indexPath.row]["titulo"] as? String
        
        return cell
    }
    // MARK: - Popular el modelo
    
    func populateModel(){
        
        let tablaVideos = client?.tableWithName("videoblogs")
        
        // prueba 1: obtener datos via MSTable
        
//        tablaVideos?.readWithCompletion({ (result:MSQueryResult?, error:NSError?) -> Void in
//            
//            if error == nil {
//                self.model = result?.items
//                self.tableView.reloadData()
//            }
//            
//        })
        
        // prueba 2: Obtener datos via MSQuery
        
        let query = MSQuery(table: tablaVideos)
        
        // Incluir predicados, constrains para filtrar, para limitar el numero de filas o delimitar el numero de columnas
        
        query.orderByAscending("titulo")
        query.readWithCompletion { (result:MSQueryResult?, error:NSError?) -> Void in
            if error == nil {
                self.model = result?.items
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            model!.removeAtIndex(indexPath.row)

            
            tableView.endUpdates()
        }
    }
    

    // MARK: - Añadir un nuevo post
    
    func addNewVideoPost(sender : AnyObject){
        performSegueWithIdentifier("addNewItem", sender: sender)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addNewItem" {
            let vc = segue.destinationViewController as! ViewPostController
            // desde aqui podemos pasar alguna property
            vc.client = client
            
        }
        
    }
    

}
