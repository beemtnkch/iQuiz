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
                answer = intValue-1
            } else if let strValue = try? container.decode(String.self, forKey: .answer),
                      let converted = Int(strValue) {
                answer = converted-1
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

            let urlString = UserDefaults.standard.string(forKey: "dataSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"

            fetchQuizzes(from: urlString) { downloadedQuizzes in
                if let downloadedQuizzes = downloadedQuizzes {
                    DispatchQueue.main.async {
                        self.quizzes = downloadedQuizzes
                        saveQuizzesLocally(downloadedQuizzes)
                        self.tableView.reloadData()
                        print("Quizzes loaded and saved locally")
                    }
                } else {
                    if let fallbackQuizzes = loadQuizzesFromLocalFile() {
                        DispatchQueue.main.async {
                            self.quizzes = fallbackQuizzes
                            self.tableView.reloadData()
                            print("Loaded quizzes from local backup")
                        }
                    } else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "No quizzes available. Network failed and no local backup found.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuiz = quizzes[indexPath.row]
        performSegue(withIdentifier: "toQuestion", sender: selectedQuiz)
    }
    
    @IBAction func settingButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                settingsVC.modalPresentationStyle = .pageSheet
                present(settingsVC, animated: true)
            }
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
        switch quiz.title.lowercased() {
            case "mathematics":
                cell.iconImageView.image = UIImage(named: "mathIcon")
            case "science!":
                cell.iconImageView.image = UIImage(named: "scienceIcon")
            case "marvel super heroes":
                cell.iconImageView.image = UIImage(named: "marvelIcon")
            default:
            cell.iconImageView.image = UIImage(named: "default_icon")//placeholder here
                 
            }


        return cell
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlString = UserDefaults.standard.string(forKey: "dataSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        fetchQuizzes(from: urlString) { downloadedQuizzes in
            if let downloadedQuizzes = downloadedQuizzes {
                DispatchQueue.main.async {
                    self.quizzes = downloadedQuizzes
                    self.tableView.reloadData()
                    print("Quizzes reloaded on viewWillAppear")
                }
            }
        }
    }
    
}

func saveQuizzesLocally(_ quizzes: [Quiz]) {
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(quizzes)
        let url = getQuizzesFileURL()
        try data.write(to: url)
        print("Quizzes saved locally.")
    } catch {
        print("Failed to save quizzes locally: \(error)")
    }
}

func loadQuizzesFromLocalFile() -> [Quiz]? {
    do {
        let url = getQuizzesFileURL()
        let data = try Data(contentsOf: url)
        let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
        print("Loaded quizzes from local file.")
        return quizzes
    } catch {
        print("Failed to load local quizzes: \(error)")
        return nil
    }
}

func getQuizzesFileURL() -> URL {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent("quizzes.json")
}
