//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Beem on 5/26/25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    @IBAction func checkNowTapped(_ sender: UIButton) {
        guard let urlString = urlTextField.text,
                  let url = URL(string: urlString) else {
                showAlert(title: "Invalid URL", message: "Please enter a valid URL.")
                return
            }

            // Save URL to UserDefaults
            UserDefaults.standard.set(urlString, forKey: "dataSourceURL")

            // Attempt to fetch data
            fetchQuizzes(from: url.absoluteString) { quizzes in
                DispatchQueue.main.async {
                    if let quizzes = quizzes, !quizzes.isEmpty {
                        // Success: dismiss modal
                        self.dismiss(animated: true)
                    } else {
                        // Failure: show error
                        self.showAlert(title: "Fetch Failed", message: "Unable to load valid data from that URL.")
                    }
                }
            }
        
        
        
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


func fetchQuizzes(from urlString: String, completion: @escaping ([Quiz]?) -> Void) {
    print("🌐 Fetching from URL:", urlString)

    guard let url = URL(string: urlString) else {
        print(" Invalid URL")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print(" Network error:", error.localizedDescription)
            completion(nil)
            return
        }

        guard let data = data else {
            print(" No data returned from server")
            completion(nil)
            return
        }

        do {
            let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
            print(" Successfully decoded quizzes:", quizzes.count)
            completion(quizzes)
        } catch {
            print(" Decoding error:", error)
            if let rawJSON = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON:\n\(rawJSON)")
            }
            completion(nil)
        }
    }.resume()
}
