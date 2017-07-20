//
//  Networking.swift
//  WidgetDemo
//
//  Created by Hesham Abd-Elmegid on 6/27/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import Foundation

open class Networking: NSObject {
    
    public typealias CompletionHandler = (_ quote: Quote?, _ error: NSError?) -> ()
 
    
    open func randomFamousPeopleQuote(_ completion: @escaping CompletionHandler) {
        randomQuote(completion, category: "famous")
    }
   
    open func randomMoviesQuote(_ completion: @escaping CompletionHandler) {
        randomQuote(completion, category: "movies")
    }
    
    private func randomQuote(_ completion: @escaping CompletionHandler, category: String) {
        let apiURL = URL(string: "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=\(category)")
        var request = URLRequest(url: apiURL!)
        request.httpMethod = "POST"
        request.addValue("70kHu82V9Jmshv3cD2gNkUF915jsp1K0HlYjsnVcns7jvOI4O1", forHTTPHeaderField: "X-Mashape-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data , error == nil else {
                print(error)
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
                let quote = Quote(quoteDictionary: jsonResponse)
                completion(quote, nil)
            } catch {
                print("JSON error: \(error)")
            }
        }
        
        task.resume()
    }
}
