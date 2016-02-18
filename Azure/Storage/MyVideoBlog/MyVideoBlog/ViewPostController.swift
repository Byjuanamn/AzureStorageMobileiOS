//
//  ViewPostController.swift
//  MyVideoBlog
//
//  Created by Juan Antonio Martin Noguera on 18/02/16.
//  Copyright © 2016 Cloud On Mobile S.L. All rights reserved.
//

import UIKit

class ViewPostController: UIViewController {

    @IBOutlet weak var saveInAzureButton: UIButton!
    @IBOutlet weak var validatorLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    
    
    
    

}
