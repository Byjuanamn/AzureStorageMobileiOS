

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let client = MSClient(
        applicationURLString:"https://myvideoblogjuanamn.azure-mobile.net/",
        applicationKey:"XObHPCejvWSJAqJRHJshIiZSMLpaVA37"
    )

    
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
            
            
            
        
//        let item = ["Name":"Awesome item", "edad" : "18", "Pais" : "Spain"]
//        
//        let table = client.tableWithName("elementos")
//        table.insert(item) {
//            (insertedItem, error : NSError?) in
//            
//            
//            print("Tenemos noticias de Azure mobile Services")
//            if error != nil {
//                print("Error" + error!.description);
//            } else {
//                print("Item inserted, id: \(insertedItem["id"])")
//            }
//        }
//        
//        let predicate = NSPredicate(format: "edad > 17", [])
//        
//        table.readWithPredicate(predicate) { (result : MSQueryResult?, error: NSError?) -> Void in
//            
//            
//            if error != nil {
//                print("Error" + error!.description);
//            } else {
//                print("Eliminamos los mayores de 17")
//                let misRegistros : MSQueryResult = result!
//                
//                table.delete(misRegistros.items[0] as! [NSObject : AnyObject] , completion: { (resultado:AnyObject?, error : NSError?) -> Void in
//                    
//                    if error != nil{
//                        print("Error" + error!.description);
//                    } else {
//                        print("Elemento eleminado -> \(resultado)");
//                    }
//                    
//                })
//            }
//
//        }
        

        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

