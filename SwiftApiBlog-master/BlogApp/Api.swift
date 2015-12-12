//
//  api.swift
//  Swag
//
//  Created by Ian Stansbury on 1/12/15.
//  Copyright (c) 2015 Make and Build. All rights reserved.
//

import Foundation

typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<AnyObject>
var dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Config", ofType: "plist")!)

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary?)
}

class API: NSObject, NSURLConnectionDataDelegate {
    
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    typealias APICallback = ((NSDictionary?, NSString?) -> ())
    
    func getData(callback: APICallback){
        println(dict)
        var prodConfigs = dict!["AppConfig_dev"] as NSDictionary
        var url = prodConfigs["base_url"] as NSString
        self.makeHTTPGetRequest(url + "/get"){
            (data, error) -> Void in
            if (error == nil){
                self.delegate?.didReceiveAPIResults(data)
            }
        }
    }
    
    func makeHTTPGetRequest(url: NSString, callback: APICallback){
        
        var urlObject = NSURL(string: url)
        var request = NSMutableURLRequest(URL: urlObject!)
        request = self.buildRequestHeaders(request)
        request.HTTPMethod = "GET"
        
        htttpRequest(request){
            (data, error) -> Void in
            callback(data, error)
        }
    }
    
    func htttpRequest(request: NSURLRequest!, callback: APICallback) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback(nil, error.localizedDescription)
            } else {
                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("responseString = \(responseString!)")
                var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:    NSJSONReadingOptions.MutableContainers, error: nil)
                if let nsDictionaryObject = jsonResult as? NSDictionary {
                    if (jsonResult != nil) {
                        callback(nsDictionaryObject, nil)
                    }else{
                        callback(nil, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func buildRequestHeaders(request: NSMutableURLRequest) -> NSMutableURLRequest{
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}
