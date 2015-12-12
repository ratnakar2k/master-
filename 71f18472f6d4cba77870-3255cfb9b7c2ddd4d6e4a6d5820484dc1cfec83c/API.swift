//
//  API.swift
//
//  Created by Taro Minowa on 6/10/14.
//  Copyright (c) 2014 Higepon Taro Minowa. All rights reserved.
//

import Foundation

typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<AnyObject>

class API: NSObject, NSURLConnectionDataDelegate {

    enum Path {
        case SIGIN_IN
        case GET_ROOMS
        case GET_MESSAGES
        case CREATE_MESSAGE
    }

    typealias APICallback = ((AnyObject?, NSError?) -> ())
    let responseData = NSMutableData()
    var statusCode:Int = -1
    var callback: APICallback! = nil
    var path: Path! = nil

    func getRooms(user: User, callback: APICallback) {
        let url = "\(Config.baseURL())/api/rooms.json?user_email=\(user.email)&user_token=\(user.token)"
        makeHTTPGetRequest(Path.GET_ROOMS, callback: callback, url: url)
    }

    func getMessages(room: Room, user: User, callback: APICallback) {
        let url = "\(Config.baseURL())/api/rooms/\(room.id)/messages.json?user_email=\(user.email)&user_token=\(user.token)"
        makeHTTPGetRequest(Path.GET_MESSAGES, callback: callback, url: url)
    }
    
    func createMessage(room: Room, text: String, user: User, callback: APICallback) {
        let url = "\(Config.baseURL())/api/rooms/\(room.id)/messages.json"
        let body = "text=\(text)&user_email=\(user.email)&user_token=\(user.token)"
        makeHTTPPostRequest(Path.CREATE_MESSAGE, callback: callback, url: url, body: body)
    }

    func signIn(email: String!, password: String!, callback: APICallback) {
        let url = "\(Config.baseURL())/api/sessions.json"
        let body = "user[email]=\(email)&user[password]=\(password)"
        makeHTTPPostRequest(Path.SIGIN_IN, callback: callback, url: url, body: body)
    }

    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        let httpResponse = response as NSHTTPURLResponse
        statusCode = httpResponse.statusCode
        switch (httpResponse.statusCode) {
        case 201, 200, 401:
            self.responseData.length = 0
        default:
            println("ignore")
        }
    }

    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.responseData.appendData(data)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var error: NSError?
        var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(self.responseData, options: NSJSONReadingOptions.MutableLeaves, error: &error)
        if error {
            callback(nil, error)
            return
        }

        switch(statusCode, self.path!) {
            case (200, Path.SIGIN_IN):
                callback(self.handleSignIn(json), nil)
            case (200, Path.GET_ROOMS):
                self.callback(self.handleGetRooms(json), nil)
            case (200, Path.GET_MESSAGES):
                callback(self.handleGetMessages(json), nil)
            case (201, Path.CREATE_MESSAGE):
                callback(self.handleCreateMessage(json), nil)
            case (401, _):
                callback(nil, handleAuthError(json))
            default:
                // Unknown Error
                callback(nil, nil)
        }
    }

    func handleAuthError(json: AnyObject) -> NSError {
        if let resultObj = json as? JSONDictionary {
            // beta2 workaround
            if let messageObj: AnyObject = resultObj["error"] {
                if let message = messageObj as? String {
                    return NSError(domain:"signIn", code:401, userInfo:["error": message])
                }
            }
        }
        return NSError(domain:"signIn", code:401, userInfo:["error": "unknown auth error"])
    }

    func handleSignIn(json: AnyObject) -> User? {
        if let resultObj = json as? JSONDictionary {
            if let userObj: AnyObject = resultObj["user"] {
                if let userJson = userObj as? JSONDictionary {
                    if let user = User.createFromJson(userJson) {
                        return user
                    }
                }
            }
        }
        return nil
    }

    func handleCreateMessage(json: AnyObject) -> Message? {
        if let messageObject = json as? JSONDictionary {
            return Message.createFromJson(messageObject)
        } else {
            return nil
        }
    }

    func handleGetRooms(json: AnyObject) -> Array<Room> {
        var rooms = Array<Room>()
        if let roomObjects = json as? JSONArray {
            for roomObject: AnyObject in roomObjects {
                if let roomJson = roomObject as? JSONDictionary {
                    if let room = Room.createFromJson(roomJson) {
                        rooms.append(room)
                    }
                }
            }
        }
        return rooms;
    }

    func handleGetMessages(json: AnyObject) -> Array<Message> {
        var messages = Array<Message>()
        if let messageObjects = json as? JSONArray {
            for messageObject: AnyObject in messageObjects {
                if let messageJson = messageObject as? JSONDictionary {
                    if let message = Message.createFromJson(messageJson) {
                        messages.append(message)
                    }
                }
            }
        }
        return messages;
    }

    // private
    func makeHTTPGetRequest(path: Path, callback: APICallback, url: NSString) {
        self.path = path
        self.callback = callback
        let request = NSURLRequest(URL: NSURL(string: url))
        let conn = NSURLConnection(request: request, delegate:self)
        if (conn == nil) {
            callback(nil, nil)
        }
    }

    func makeHTTPPostRequest(path: Path, callback: APICallback, url: NSString, body: NSString) {
        self.path = path
        self.callback = callback
        let request = NSMutableURLRequest(URL: NSURL(string: url))
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let conn = NSURLConnection(request: request, delegate:self)
        if (conn == nil) {
            callback(nil, nil)
        }
    }
}