//
//  ViewController.swift
//  BlogApp
//
//  Created by Ian Stansbury on 2/24/15.
//  Copyright (c) 2015 Ian Stansbury. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APIControllerProtocol{

    
    
    @IBOutlet weak var dataFound: UILabel!
    
    lazy var api: API = API(delegate: self)
    func didReceiveAPIResults(results: NSDictionary?) {
        var resultDict = results!
        var someData = resultDict["url"] as String
        dispatch_async(dispatch_get_main_queue()) {
            self.dataFound.text = someData
        }
        
    }
    override func viewDidLoad() {
        api.getData(){
            (data, error) -> Void in
            //any additional processing, other REST calls, etc.
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

