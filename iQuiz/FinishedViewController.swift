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

        print("Finished screen - totalQuestions:", totalQuestions)
        print("Finished screen - correctAnswers:", correctAnswers)//bug check for score
        
        
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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let rootVC = storyboard.instantiateInitialViewController() {
                    window.rootViewController = rootVC
                    window.makeKeyAndVisible()
                }
            }
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
