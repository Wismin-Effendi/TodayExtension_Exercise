//
//  TodayViewController.swift
//  QuotesWidget
//
//  Created by Wismin Effendi on 7/19/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import NotificationCenter
import QuotesNetworking

class TodayViewController: UIViewController, NCWidgetProviding {
    
    struct Key {
        static let category = "category"
        
        struct Category {
            static let movies = "movies"
            static let famous = "famous"
        }
    }
    
    let quoteCategory = [Key.Category.movies, Key.Category.famous]
    
    let defaults = UserDefaults.standard
    var lastSelectedCategory: String!
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let networking = Networking()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.quoteLabel.text = nil
        self.authorLabel.text = nil
        
        lastSelectedCategory = defaults.object(forKey: Key.category) as? String ?? Key.Category.movies
        segmentControl.selectedSegmentIndex = quoteCategory.index(of: lastSelectedCategory)!
            
        networking.randomMoviesQuote { (quote, error) in
            if let quote = quote {
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        networking.randomMoviesQuote { (quote, error) in
            guard let quote = quote, error == nil else {
                completionHandler(.failed)
                return
            }
            
            DispatchQueue.main.async {
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
            }
            completionHandler(NCUpdateResult.newData)
        }
    }
    
    @IBAction func categorySelected(_ sender: UISegmentedControl) {
        defaults.set(quoteCategory[sender.selectedSegmentIndex], forKey: Key.category)
        
        
    }
}
