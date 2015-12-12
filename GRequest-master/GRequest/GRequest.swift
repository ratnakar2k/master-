//
//  GRequest.swift
//  GRequest
//
//  Created by Ruoyu Fu on 14-7-1.
//  Copyright (c) 2014年 Roy Fu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


typealias Request = GRequest<NSData>


protocol ResponseDeserialization{
  class func convertFromData(data:NSData!) -> (Self?, NSError?)
}


class GRequest<D:ResponseDeserialization> {
  
  
  var session: NSURLSession
  var config: NSURLSessionConfiguration {
    willSet{
      session = NSURLSession(configuration: newValue)
    }
  }
  
  init(_ urlString:String) {
    _baseURLString = urlString
    config = NSURLSessionConfiguration.defaultSessionConfiguration()
    session = NSURLSession.sharedSession()
  }
  
  func path(path: String) -> GRequest<D>{
    let grequest = GRequest<D>(_baseURLString)
    
    grequest._header = _header
    grequest._query = _query
    grequest._body = _body
    grequest._bodyTypeString = _bodyTypeString
    
    grequest._path = path
    return grequest
  }
  
  func query(query: Dictionary<String, String>) -> GRequest<D>{
    let grequest = GRequest<D>(_baseURLString)
    
    grequest._path = _path
    grequest._header = _header
    grequest._body = _body
    grequest._bodyTypeString = _bodyTypeString

    grequest._query = query
    return grequest
  }
  
  func header(header: Dictionary<String, String>) -> GRequest<D> {
    let grequest = GRequest<D>(_baseURLString)
    
    grequest._path = _path
    grequest._query = _query
    grequest._body = _body
    grequest._bodyTypeString = _bodyTypeString
    
    grequest._header = header
    return grequest
  }
  
  func formBody(body:Dictionary<String, String>) -> GRequest<D>{
    var urlEncString = ""
    var idx = 0
    for (key, value) in body{
      urlEncString = urlEncString + key.URLEncoded + "=" + value.URLEncoded
      if idx < body.count-1{
        urlEncString += "&"
      }
      idx++
    }
    let request = GRequest<D>(_baseURLString)
    request._body = urlEncString.dataUsingEncoding(NSUTF8StringEncoding)
    request._bodyTypeString = "application/x-www-form-urlencoded"
    
    request._path = _path
    request._header = _header
    request._query = _query
    
    return request
  }
  
  func jsonBody(body:NSDictionary) -> GRequest<D>{
    let request = GRequest<D>(_baseURLString)
    request._body = JSONValue(body).rawJSONString.dataUsingEncoding(NSUTF8StringEncoding)
    request._bodyTypeString = "application/json"
   
    request._path = _path
    request._header = _header
    request._query = _query
    
    return request
  }
  
  func body(bodyData:NSData, typeString:String) -> GRequest<D>{
    let grequest = GRequest<D>(_baseURLString)
    grequest._body = bodyData
    grequest._bodyTypeString = typeString
    
    grequest._path = _path
    grequest._header = _header
    grequest._query = _query
    
    return grequest
  }
  
  
  func get(completion: (GResponse<D>) -> ()){
    _sendRequest("GET", completion: completion)
  }
  
  func get<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("GET", completion: completion)
  }
  
  func post(completion: (GResponse<D>) -> ()){
    _sendRequest("POST", completion: completion)
  }
  
  func post<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("POST", completion: completion)
  }
  
  func head(completion: (GResponse<D>) -> ()){
    _sendRequest("HEAD", completion: completion)
  }
  
  func head<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("HEAD", completion: completion)
  }
  
  func patch(completion: (GResponse<D>) -> ()){
    _sendRequest("PATCH", completion: completion)
  }
  
  func patch<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("PATCH", completion: completion)
  }
  
  func put(completion: (GResponse<D>) -> ()){
    _sendRequest("PUT", completion: completion)
  }
  
  func put<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("PUT", completion: completion)
  }
  
  func delete(completion: (GResponse<D>) -> ()){
    _sendRequest("DELETE", completion: completion)
  }
  
  func delete<T:ResponseDeserialization>(completion: (GResponse<T>) -> ()){
    _sendRequest("DELETE", completion: completion)
  }
  
  func _sendRequest<T:ResponseDeserialization>(method: String, completion: (GResponse<T>) -> ()){
    
    var url:NSURL
    
    if let path = _path{
      var baseURL = NSURL(string:_baseURLString)
      url = NSURL(string: path, relativeToURL: baseURL)
    }else{
      url = NSURL(string:_baseURLString)
    }
    
    if let query = _query{
      var additionQueryString:String
      if (url.query != nil){
        additionQueryString = "&"
      }else{
        additionQueryString = "?"
      }
      var idx = 0
      for (key, value) in query{
        additionQueryString = additionQueryString + key.URLEncoded + "=" + value.URLEncoded
        if idx < query.count-1{
          additionQueryString += "&"
        }
        idx++
      }
      url = NSURL(string: url.absoluteString+additionQueryString)
    }
    
    var request = NSMutableURLRequest(URL: url)
    
    if let header = _header{
      for (field, value) in header{
        request.setValue(value, forHTTPHeaderField: field)
      }
    }
    
    if let body = _body{
      request.HTTPBody = body
    }
    if let bodyTypeString = _bodyTypeString{
      request.setValue(bodyTypeString, forHTTPHeaderField: "Content-Type")
    }
    
    request.HTTPMethod = method
    
    session.dataTaskWithRequest(request){
      data, response, error in
      let resp = GResponse<T>(urlData: data, urlResponse: response, urlError: error)
      completion(resp)
      }.resume()
  }
  
  var _baseURLString: String
  var _path: String? = nil
  var _header: Dictionary<String, String>? = nil
  var _query: Dictionary<String, String>? = nil
  var _body: NSData? = nil
  var _bodyTypeString: String? = nil
  
}


struct GResponse<T:ResponseDeserialization>:LogicValue{
  
  let object: T?
  let content: NSData?
  let statusCode: Int?
  let headers: NSDictionary?
  let MIMEType: String?
  let encoding: String?
  
  var string:String?{
    get{
      if (encoding != nil){
        let enc:NSString = encoding!
        let IANAEncoding:CFStringEncoding = CFStringConvertIANACharSetNameToEncoding(enc)
        if IANAEncoding != kCFStringEncodingInvalidId{
          let stringEncoding = CFStringConvertEncodingToNSStringEncoding(IANAEncoding);
          return NSString(data: content, encoding: stringEncoding)
        }
      }
      return nil
    }
  }

  let error:NSError?


  init(urlData: NSData!, urlResponse: NSURLResponse!, urlError: NSError!){
    content = urlData
    
    statusCode = (urlResponse as? NSHTTPURLResponse)?.statusCode
    headers = (urlResponse as? NSHTTPURLResponse)?.allHeaderFields
    MIMEType = (urlResponse as? NSHTTPURLResponse)?.MIMEType
    encoding = (urlResponse as? NSHTTPURLResponse)?.textEncodingName
    
    var desError:NSError?
    (object, desError) = T.convertFromData(urlData)
    if (urlError != nil){
      error = urlError
    }else if (desError != nil){
      error = desError
    } else {
      if let code = statusCode{
        if code >= 400 || code < 200{
          error = NSError(domain: "GRequestErrorDomain", code: code, userInfo: nil)
        }
      }
    }
  }
  
  func getLogicValue() -> Bool {
    if (error != nil){
      return false
    }
    return true
  }
}


extension JSONValue:ResponseDeserialization{
  static func convertFromData(data:NSData!) -> (JSONValue?, NSError?){
    let value = JSONValue(data)
    switch value{
    case .JInvalid(let error):
      return (value, error)
    default:
      return (value, nil)
    }
  }
}


extension NSData:ResponseDeserialization{
  class func convertFromData(data:NSData!) -> (NSData?, NSError?){
    return (data, nil)
  }
}


extension UIImage:ResponseDeserialization{
  class func convertFromData(data:NSData!) -> (UIImage?, NSError?){
    return (UIImage(data: data), nil)
  }
}


extension String{
  
  var URLEncoded:String{
  get{
    let raw: NSString = self
    let str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,raw,"[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
    return str as String
  }
  }
  
}
