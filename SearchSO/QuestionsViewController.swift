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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        questionsTableView.dataSource = self
        questionsTableView.delegate = self

    }
    
    func updateQuestionsToShow(_ questions: [Question]) {
        self.questionsToShow.removeAll()
        self.questionsToShow = questions
        DispatchQueue.main.async {
            self.questionsTableView.reloadData();
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
        
        searchBar.resignFirstResponder()
        
        let questionsResource = StackOverflowResource<StackOverflowQuestionResponse>(getObject: .questions(searchText), parseJSON: { data in
            try? JSONDecoder().decode(StackOverflowQuestionResponse.self, from: data)})
        
        if let questionsResource = questionsResource {
            URLSession.shared.load(questionsResource) { questionsInResponse in
                if let questions = questionsInResponse?.items {
                    self.updateQuestionsToShow(questions)
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
        cell.votesText.text = "Votes"
        
        return cell
    }
}


