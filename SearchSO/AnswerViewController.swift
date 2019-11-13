//
//  AnswerViewController.swift
//  SearchSO
//
//  Created by utkarsh on 13/11/19.
//  Copyright © 2019 utkarsh. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var answerScore: UILabel!
    @IBOutlet weak var greenTickImage: UIImageView!
    @IBOutlet weak var ownerId: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var answerBody: UILabel!
    
    var questionId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
