//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Beem on 5/14/25.
//

import UIKit

class AnswerViewController: UIViewController {
    var quiz: Quiz?
    var question: Question?
    var selectedIndex: Int?
    var totalQuestions: Int = 0
    var correctCount: Int = 0
    var currentQuestionIndex: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //extra cred
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
            hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // fades itt out after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5) {
                hintLabel.alpha = 0
            }
        }
        //extra cred ends here
        
        
        guard let question = question, let selectedIndex = selectedIndex else { return }
        
        if let label = correctAnswerLabel {
            print("correctAnswerLabel outlet points to:", label)
        } else {
            print("correctAnswerLabel is nil — not connected properly!")
        }//label bug check
        
        
        
        
        
        questionLabel.text = question.text
        let correctIndex = question.correctIndex
        let allOptions = question.options
        print("Correct Index:", correctIndex)
        print("All options:", allOptions)

        if allOptions.indices.contains(correctIndex) {
            let correctAnswer = allOptions[correctIndex]
            print("Correct Answer Resolved As:", correctAnswer)
            correctAnswerLabel.text = "Correct Answer: \(correctAnswer)"
        } else {
            correctAnswerLabel.text = "Correct Answer: [invalid index]"
        }
        //correctAnswerLabel.text = "Correct Answer: \(question.options[question.correctIndex])"
        //yourAnswerLabel.text = "Your Answer: \(question.options[selectedIndex])"
        
        if allOptions.indices.contains(selectedIndex) {
                    let selectedAnswer = allOptions[selectedIndex]
                    print("Selected Answer Resolved As:", selectedAnswer)
                    yourAnswerLabel.text = "Your Answer: \(selectedAnswer)"
                } else {
                    yourAnswerLabel.text = "Your Answer: [invalid index]"
                }

        
            if selectedIndex == question.correctIndex {
                resultLabel.text = "Correct!"
                resultLabel.textColor = .systemGreen
            } else {
                resultLabel.text = "Incorrect!"
                resultLabel.textColor = .systemRed
            }
        // Do any additional setup after loading the view.
        
    }
    

    @objc func handleSwipeRight() {
        nextButtonTapped(UIButton()) // simulate tapping Next
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
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentQuestionIndex + 1 >= totalQuestions {
                // goes to finish screen if no more q's
                performSegue(withIdentifier: "toFinished", sender: nil)
            } else {
                // Continues to next question
                performSegue(withIdentifier: "toNextQuestion", sender: nil)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinished",
           let destination = segue.destination as? FinishedViewController {
            destination.totalQuestions = totalQuestions
            destination.correctAnswers = correctCount

        } else if segue.identifier == "toNextQuestion",
                  let destination = segue.destination as? QuestionViewController {

            destination.quiz = quiz
            destination.currentQuestionIndex = currentQuestionIndex + 1
            destination.correctCount = correctCount
        }
    }
}
