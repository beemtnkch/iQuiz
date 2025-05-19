//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Beem on 5/14/25.
//

import UIKit

class QuestionViewController: UIViewController {
    

    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var choiceAButton: UIButton!
    @IBOutlet weak var choiceBButton: UIButton!
    @IBOutlet weak var choiceCButton: UIButton!
    
    var quiz: Quiz?
    var currentQuestionIndex = 0
    var selectedIndex: Int? = nil
    var correctCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let question = quiz?.questions[currentQuestionIndex] {
            questionLabel.text = question.text
            choiceAButton.setTitle(question.options[0], for: .normal)
            choiceBButton.setTitle(question.options[1], for: .normal)
            choiceCButton.setTitle(question.options[2], for: .normal)
        }
        // Do any additional setup after loading the view.
        //extra cred starts here
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let hintLabel = UILabel()
        hintLabel.text = "← Swipe to quit | → Swipe to continue"
        hintLabel.textColor = .lightGray
        hintLabel.font = UIFont.systemFont(ofSize: 14)
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintLabel)

        // layout stuff
        NSLayoutConstraint.activate([
            hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // fades out after 3seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5) {
                hintLabel.alpha = 0
            }
            
        }
        
        //extra cred ends
        
    }
    
    @objc func handleSwipeRight() {
        submitButtonTapped(UIButton()) // simulate tapping Submit
    }

    @objc func handleSwipeLeft() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let rootVC = storyboard.instantiateInitialViewController() {
                    window.rootViewController = rootVC
                    window.makeKeyAndVisible()
                }
            }
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let selectedIndex = selectedIndex else {
                print("No answer selected")
                return
            }
            performSegue(withIdentifier: "toAnswer", sender: selectedIndex)
    }
    

    
    @IBAction func choiceASelected(_ sender: UIButton) {
        selectedIndex = 0
    }
    
    @IBAction func choiceBSelected(_ sender: UIButton) {
        selectedIndex = 1
    }
    
    @IBAction func choiceCSelected(_ sender: UIButton) {
        selectedIndex = 2
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAnswer",
               let destination = segue.destination as? AnswerViewController,
               let selectedIndex = sender as? Int,
               let question = quiz?.questions[currentQuestionIndex] {
                
                // Pass the question and answer
                destination.question = question
                destination.selectedIndex = selectedIndex
                
                destination.quiz = quiz
                
                // Pass progress
                destination.totalQuestions = quiz?.questions.count ?? 0
                destination.currentQuestionIndex = currentQuestionIndex
                
                // Pass score
                destination.correctCount = selectedIndex == question.correctIndex ? correctCount + 1 : correctCount
            }
        }
}
