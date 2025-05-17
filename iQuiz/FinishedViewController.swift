//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Beem on 5/14/25.
//

import UIKit

class FinishedViewController: UIViewController {

    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "You got \(correctAnswers) of \(totalQuestions) correct"

                switch Double(correctAnswers) / Double(totalQuestions) {
                case 1.0:
                    messageLabel.text = "🎉 Perfect!"
                case 0.66...0.99:
                    messageLabel.text = "👍 Almost!"
                default:
                    messageLabel.text = "😬 Nice try!"
                }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMenu(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
