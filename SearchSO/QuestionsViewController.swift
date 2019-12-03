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
    
    @IBOutlet weak var questionsTableView: UITableView!
    
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        questionsTableView.dataSource = self
        questionsTableView.delegate = self
        
        DispatchQueue.main.async {
            self.spinnerView.layer.cornerRadius = 10
            self.spinnerView.layer.masksToBounds = true
            self.spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.spinner.hidesWhenStopped = true
            self.spinner.style = UIActivityIndicatorView.Style.whiteLarge
        }
    }
    
    func updateQuestionsToShow(_ questions: [Question]) {
        self.questionsToShow.removeAll()
        self.questionsToShow = questions
        
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinnerView.isHidden = true
            self.view.isUserInteractionEnabled = true
            
            self.questionsTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayAnswerSegue" {
            if let indexPath = self.questionsTableView.indexPathForSelectedRow {
                let controller = segue.destination as! AnswerViewController
                controller.questionId = self.questionsToShow[indexPath.row].questionId
            }
        }
    }

}

extension QuestionsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        guard let searchText = searchBar.text else {
            print("Empty")
            return
        }
        
        if searchText == "" {
            return
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            
            if self.questionsToShow.count != 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.questionsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            self.view.isUserInteractionEnabled = false
            self.spinnerView.isHidden = false
            self.view.bringSubviewToFront(self.spinnerView)
            self.spinner.startAnimating()
        }
        
        let questionsResource = StackOverflowResource<StackOverflowQuestionResponse>(getObject: .questions(searchText), parseJSON: { data in
            try? JSONDecoder().decode(StackOverflowQuestionResponse.self, from: data)})
        
        if let questionsResource = questionsResource {
            URLSession.shared.load(questionsResource) { questionsInResponse in
                if let questions = questionsInResponse?.items {
                    self.updateQuestionsToShow(questions)
                }
                else {
                    self.updateQuestionsToShow([])
                }
            }
        }
    }
}

extension QuestionsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension QuestionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabeledCell", for: indexPath) as! CustomTableViewCell
        
        let question = self.questionsToShow[indexPath.row]
        cell.questionTitle?.text = question.title
        cell.questionScore?.text = String(question.score)
        if question.acceptedAnswerId != nil {
            cell.greenTickImage.image = UIImage(named: "GreenTick")
        }
        else {
            cell.greenTickImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


