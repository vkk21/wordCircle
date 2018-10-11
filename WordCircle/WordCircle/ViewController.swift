//
//  ViewController.swift
//  WordCircle
//
//  Created by Vamshi Krishna on 10/4/18.
//  Copyright © 2018 VamshiK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputValue: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var outputValue: UITextView!
    
    var circleWord : String = ""
    var wordDict : [String:Any] = [String:Any]()
    var sortedKeys: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "https://raw.githubusercontent.com/tmobil/WordCircle/master/english.json"
        getJsonDataFromUrl(url:jsonUrlString)
        
    }
    
    func getJsonDataFromUrl(url:String){
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
            
            do {
                let wDict =  try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                self.wordDict = wDict!
                self.sortedKeys = self.wordDict.keys.sorted()
                //            print(wDict)
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
        
    }
    
    
    @IBAction func buttonClick(sender: UIButton) {
        //getting input from Text Field
        circleWord = inputValue.text!
        
        // Given a valid word in the dictionary check
        if (sortedKeys.contains(circleWord)&&( circleWord.count >= 2)) {
            
            var index = 0
            while circleWord.split(separator: " ").count <= 3 {
                circleWord += " " + getWordStartWith(String(circleWord.suffix(1)), word: String(circleWord.split(separator: " ")[index]))!
                index += 1
            }
            
            outputValue.text = circleWord
        }
        else
        {
            let alert = UIAlertController(title: "Invalid word", message: "Not valid word from dictionary, choose another word", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // function to search and get the words from the dict to match the passes character
    func getWordStartWith(_ letter: String, word: String) -> String? {
        
        for key in self.sortedKeys {
            if key.starts(with: letter) && word != key && key.count >= 2 {
                return  key
            }
        }
        return nil
    }
}
