//
//  ViewController.swift
//  iQuiz
//
//  Created by Beem on 5/5/25.
//

import UIKit

struct Quiz {
    let title: String
    let description: String
    let iconName: String
    let questions: [Question]
}

struct Question {
    let text: String
    let options: [String]
    let correctIndex: Int
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    //add questions
    let quizzes: [Quiz] = [
        Quiz(
            title: "Mathematics",
            description: "Test your math skills!",
            iconName: "mathIcon",
            questions: [
                Question(text: "What is 2 + 2?", options: ["3", "4", "5"], correctIndex: 1),
                Question(text: "What is 5 × 3?", options: ["15", "10", "8"], correctIndex: 0)
            ]
        ),
        Quiz(
            title: "Marvel",
            description: "Avengers Assemble!",
            iconName: "marvelIcon",
            questions: [
                Question(text: "Who is Iron Man?", options: ["Bruce Wayne", "Tony Stark", "Clark Kent"], correctIndex: 1),
                Question(text: "Who leads the Avengers?", options: ["Thor", "Captain America", "Hulk"], correctIndex: 1)
            ]
        ),
        Quiz(
            title: "Science",
            description: "Explore scientific facts!",
            iconName: "scienceIcon",
            questions: [
                Question(text: "Water boils at what temperature (°C)?", options: ["100", "90", "80"], correctIndex: 0),
                Question(text: "Earth is the ___ planet from the Sun.", options: ["2nd", "3rd", "4th"], correctIndex: 1)
            ]
        )
    ]
    
    
    //pass to QuestionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestion",
           let destination = segue.destination as? QuestionViewController,
           let selectedQuiz = sender as? Quiz {
            destination.quiz = selectedQuiz
        }
    }

    
    
    
    



    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        performSegue(withIdentifier: "toQuestion", sender: selectedQuiz)
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

