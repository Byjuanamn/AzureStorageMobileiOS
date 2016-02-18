//
//  MyTimelineController.swift
//  MyVideoBlog
//
//  Created by Juan Antonio Martin Noguera on 18/02/16.
//  Copyright © 2016 Cloud On Mobile S.L. All rights reserved.
//

import UIKit


let k_TableName = "Videos"


class MyTimelineController: UITableViewController {

    let client = MSClient(
        applicationURLString:"https://myvideoblogjuanamn.azure-mobile.net/",
        applicationKey:"XObHPCejvWSJAqJRHJshIiZSMLpaVA37"
    )

    var model : [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mis videos blog"
        let plusButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "addNewVideoPost:")
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

        let item = model![indexPath.row]
        cell.textLabel!.text = item["titulo"] as? String

        return cell
    }
    // MARK: - Popular el modelo
    
    func populateModel(){
        
        let tableBlogs = client.tableWithName(k_TableName)
        
  
        tableBlogs.readWithCompletion { (results: MSQueryResult?, error: NSError?) -> Void in
            
            if error == nil{
                self.model = results?.items
                self.tableView.reloadData()
            }
        }
//        let predicate = NSPredicate(format: "", argumentArray: nil)

//        tableBlogs.readWithPredicate(predicate) { (results: MSQueryResult?, error: NSError?) -> Void in
//            
//            if error == nil{
//                self.model = results?.items
//                self.tableView.reloadData()
//            }
//        }
        
        
    }


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
            let vc = segue.destinationViewController
            // desde aqui podemos pasar alguna property
//            vc.client = client
            
        }
        
    }
    

}
