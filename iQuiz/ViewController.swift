//
//  ViewController.swift
//  iQuiz
//
//  Created by Beem on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    struct Quiz {
        let title: String
        let description: String
        let iconName: String
    }

    let quizzes = [
        Quiz(title: "Mathematics", description: "Test your math skills!", iconName: "mathIcon"),
        Quiz(title: "Marvel", description: "How well do you know Marvel?", iconName: "marvelIcon"),
        Quiz(title: "Science", description: "Explore scientific facts!", iconName: "scienceIcon")
    ]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func settingButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quiz = quizzes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! TableViewCell

        cell.titleLabel.text = quiz.title
        cell.descriptionLabel.text = quiz.description
        cell.iconImageView.image = UIImage(named: quiz.iconName)

        return cell
    }
}

