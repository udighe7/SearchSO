//
//  ViewController.swift
//  SearchSO
//
//  Created by utkarsh on 12/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    var questionsToShow: [Question] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}

extension QuestionsViewController: UISearchBarDelegate {
    
}

