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
    
    enum QuoteCategory: String {
        case movies = "movies"
        case famous = "famous"
    }
    
    let allQuoteCategories = [Key.Category.movies, Key.Category.famous]
    
    let defaults = UserDefaults.standard
    var lastSelectedCategory: String!
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastSelectedCategory = defaults.object(forKey: Key.category) as? String ?? QuoteCategory.movies.rawValue
        segmentControl.selectedSegmentIndex = allQuoteCategories.index(of: lastSelectedCategory)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.quoteLabel.text = nil
        self.authorLabel.text = nil
    
            
        let completionClosure = {[weak self] (quote: Quote?, error: NSError?) in
            if let quote = quote {
                DispatchQueue.main.async {
                    self?.quoteLabel.text = quote.text
                    self?.authorLabel.text = quote.author
                }
            }
        }
        
        getRandomQuoteByCategorySelection(completion: completionClosure)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let networkingCompletionClosure = {[weak self] (quote: Quote?, error: NSError?) in
            guard let quote = quote, error == nil else {
                completionHandler(.failed)
                return
            }
            
            DispatchQueue.main.async {
                self?.quoteLabel.text = quote.text
                self?.authorLabel.text = quote.author
            }
            completionHandler(NCUpdateResult.newData)
        }
        
        getRandomQuoteByCategorySelection(completion: networkingCompletionClosure)
    }
    
    private func getRandomQuoteByCategorySelection(completion: @escaping Networking.CompletionHandler ) {
        let category = QuoteCategory(rawValue: lastSelectedCategory)!
        switch category {
        case QuoteCategory.movies:
            networking.randomMoviesQuote(completion)
        case QuoteCategory.famous:
            networking.randomMoviesQuote(completion)
        }
    }
    
    @IBAction func categorySelected(_ sender: UISegmentedControl) {
        lastSelectedCategory = allQuoteCategories[sender.selectedSegmentIndex]
        defaults.set(lastSelectedCategory, forKey: Key.category)
        
        widgetPerformUpdate { (result) in
            
        }
    }
}
