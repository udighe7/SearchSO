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
    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var questionId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Answer"
        
        DispatchQueue.main.async {
            self.spinnerView.layer.cornerRadius = 10
            self.spinnerView.layer.masksToBounds = true
            self.spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.spinner.hidesWhenStopped = true
            self.spinner.style = UIActivityIndicatorView.Style.whiteLarge
            
            self.view.isUserInteractionEnabled = false
            self.answerView.isHidden = true
            self.view.layoutIfNeeded()
            self.spinner.startAnimating()
        }
        self.updateView()
    }
    
    func updateView() {
        if let id = self.questionId {
            let questions = StackOverflowResource<StackOverflowAnswerResponse>(getObject: .answer(id), parseJSON: { data in
                try? JSONDecoder().decode(StackOverflowAnswerResponse.self, from: data)})
            
            if let answersObject = questions {
                URLSession.shared.load(answersObject) { answerResponse in
                    if let answers = answerResponse?.items {
                        var displayAnswer: Answer? = nil
                        var score: Int = -999999
                        var index = 0
                        var count = 0
                        var acceptedAnswer = false
                        for answer in answers {
                            if answer.isAccepted {
                                displayAnswer = answer
                                acceptedAnswer = true
                                break
                            }
                            if score < answer.score {
                                score = answer.score
                                index = count
                            }
                            count += 1
                        }
                        if score != -999999 && acceptedAnswer == false {
                            displayAnswer = answers[index]
                        }
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                            self.spinnerView.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        }
                        if let answer = displayAnswer {
                            self.updateAnswer(answer,acceptedAnswer)
                        }
                        else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Update", message: "No answer found!", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateAnswer(_ answerData: Answer,_ acceptedAnswer: Bool) {
        DispatchQueue.main.async {
            self.answerView.isHidden = false
            
            self.answerScore.text = String(answerData.score)
            self.ownerId.text = String(answerData.owner.ownerId)
            self.ownerName.text = answerData.owner.ownerName
            let noHtmlTagsstring = answerData.body.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            self.answerBody.text = noHtmlTagsstring.trimmingCharacters(in: .whitespacesAndNewlines)
            self.greenTickImage.image = UIImage(named: "GreenTick")
            if acceptedAnswer == false {
                self.greenTickImage.isHidden = true
            }
        }
    }
}
