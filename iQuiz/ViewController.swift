//
//  ViewController.swift
//  iQuiz
//
//  Created by Beem on 5/5/25.
//

import UIKit

struct Quiz: Codable {
    let title: String
    let desc: String
    let questions: [Question]

    var description: String { desc }
}

struct Question: Codable {
    let text: String
    let answer: Int
    let answers: [String]

    var options: [String] { answers }
    var correctIndex: Int { answer }
    
    private enum CodingKeys: String, CodingKey {
            case text, answers, answer
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            answers = try container.decode([String].self, forKey: .answers)

            // Handle both number or string as answer
            if let intValue = try? container.decode(Int.self, forKey: .answer) {
                answer = intValue
            } else if let strValue = try? container.decode(String.self, forKey: .answer),
                      let converted = Int(strValue) {
                answer = converted
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .answer,
                    in: container,
                    debugDescription: "Expected answer to be an Int or a numeric String"
                )
            }
        }
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    //add questions
    var quizzes: [Quiz] = []
    
    
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
        tableView.delegate = self
        tableView.dataSource = self

        let url = "http://tednewardsandbox.site44.com/questions.json"

        fetchQuizzes(from: url) { downloadedQuizzes in
            if let downloadedQuizzes = downloadedQuizzes {
                DispatchQueue.main.async {
                    self.quizzes = downloadedQuizzes
                    self.tableView.reloadData()
                    print("Quizzes loaded: \(downloadedQuizzes.count)")
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Failed to load quizzes from the network.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
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
        //cell.iconImageView.image = UIImage(named: quiz.iconName)

        return cell
    }

}

func fetchQuizzes(from urlString: String, completion: @escaping ([Quiz]?) -> Void) {
    print("🌐 Fetching from URL:", urlString)

    guard let url = URL(string: urlString) else {
        print("❌ Invalid URL")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("❌ Network error:", error.localizedDescription)
            completion(nil)
            return
        }

        guard let data = data else {
            print("❌ No data returned from server")
            completion(nil)
            return
        }

        do {
            let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
            print("✅ Successfully decoded quizzes:", quizzes.count)
            completion(quizzes)
        } catch {
            print("❌ Decoding error:", error)
            if let rawJSON = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON:\n\(rawJSON)")
            }
            completion(nil)
        }
    }.resume()
}
