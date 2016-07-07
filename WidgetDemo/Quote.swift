//
//  Quote.swift
//  WidgetDemo
//
//  Created by Hesham Abd-Elmegid on 6/27/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import Foundation

public class Quote: NSObject {
    public let text: String
    public let author: String
    
    public init(quoteDictionary: NSDictionary) {
        text = quoteDictionary["quote"] as! String
        author = quoteDictionary["author"] as! String
    }
    
}
