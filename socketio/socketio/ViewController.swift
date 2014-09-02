//
//  ViewController.swift
//  socketio
//
//  Created by Derek J. Kinsman on 2014-08-11.
//  Copyright (c) 2014 Teehan + Lax. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, SRWebSocketDelegate {
    
    var socketio:SRWebSocket?
    let server = "example.com" // don't include http://
    let session:NSURLSession?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(CGRectGetWidth(view.frame)/2-100, CGRectGetHeight(view.frame)/2-40, 200, 80)
        button.backgroundColor = UIColor(red: 0.2421875, green: 0.64453125, blue: 0.8046875, alpha: 1)
        button.setTitle("Socket.IO", forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func buttonAction(sender:UIButton!) {
        var dict = [
            "name": "test",
            "args": [["Button": "Pressed"]]
        ]
        
        /*
         * What you would see in a traditional
         * Socket.IO app.js file.
         *
         * socket.emit("test", {
         *   Button: "Pressed"
         * });
         *
         *
         */
        
        var jsonSendError:NSError?
        var jsonSend = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(0), error: &jsonSendError)
        var jsonString = NSString(data: jsonSend, encoding: NSUTF8StringEncoding)
        println("JSON SENT \(jsonString)")
        
        let str:NSString = "5:::\(jsonString)"
        socketio?.send(str)
    }
    
    // SWIFT REQUIREMENTS
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    // SWIFT REQUIREMENTS
    
    override init() {
        
        let sessionConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        
        super.init()
        
        session = NSURLSession(configuration: sessionConfig)
        
        initHandshake()
    }
    
    func initHandshake() {
        let time:NSTimeInterval = NSDate().timeIntervalSince1970 * 1000
        
        var endpoint = "http://\(server)/socket.io/1?t=\(time)"
        
        var handshakeTask:NSURLSessionTask = session!.dataTaskWithURL(NSURL.URLWithString(endpoint), completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) in
            if !error {
                let stringData:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)
                let handshakeToken:NSString = stringData.componentsSeparatedByString(":")[0] as NSString
                println("HANDSHAKE \(handshakeToken)")
                
                self.socketConnect(handshakeToken)
            }
        })
        handshakeTask.resume()
    }
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://\(server)/socket.io/1/websocket/\(token)")))
        socketio!.delegate = self
        socketio!.open()
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        println("MESSAGE: \(message)")
        
        var jsonError:NSError?
        let messageArray = (message as NSString).componentsSeparatedByString(":::")
        let data:NSData = messageArray[messageArray.endIndex - 1].dataUsingEncoding(NSUTF8StringEncoding)
        var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
        
        if json != nil {
            let event: NSString = json!["name"] as NSString
            let args: NSDictionary = (json!["args"] as NSArray)[0] as NSDictionary
            
            if (event.isEqualToString("one")) {
                didReceiveEventOne(args)
            }
            else if (event.isEqualToString("two")) {
                didReceiveEventTwo(args)
            }
            else if (event.isEqualToString("three")) {
                didReceiveEventThree(args)
            }
        }
    }
    
    func didReceiveEventOne(args: NSDictionary) {
        var dict = [
            "name": "event",
            "args": [["Method": "One"]]
        ]
        var jsonSendError:NSError?
        var jsonSend = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(0), error: &jsonSendError)
        var jsonString = NSString(data: jsonSend, encoding: NSUTF8StringEncoding)
        println("JSON SENT \(jsonString)")
        let str:NSString = "5:::\(jsonString)"
        socketio?.send(str)
    }
    
    func didReceiveEventTwo(args: NSDictionary) {
        var dict = [
            "name": "event",
            "args": [["Method": "Two"]]
        ]
        var jsonSendError:NSError?
        var jsonSend = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(0), error: &jsonSendError)
        var jsonString = NSString(data: jsonSend, encoding: NSUTF8StringEncoding)
        println("JSON SENT \(jsonString)")
        let str:NSString = "5:::\(jsonString)"
        socketio?.send(str)
    }
    
    func didReceiveEventThree(args: NSDictionary) {
        var dict = [
            "name": "event",
            "args": [["Method": "Three"]]
        ]
        var jsonSendError:NSError?
        var jsonSend = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(0), error: &jsonSendError)
        var jsonString = NSString(data: jsonSend, encoding: NSUTF8StringEncoding)
        println("JSON SENT \(jsonString)")
        let str:NSString = "5:::\(jsonString)"
        socketio?.send(str)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

