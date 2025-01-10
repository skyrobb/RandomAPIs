//
//  ViewController.swift
//  APIs
//
//  Created by Mike Collier on 12/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDogPhoto()
    }

    @IBAction func goFetchTapped(_ sender: Any) {
        loadDogPhoto()
    }
    
    func loadDogPhoto() {
        //Task creates the asyncronous context needed to run async functions
        Task {
            //The do/catch blocks allow the code to 'catch' errors that thrown by functions called in 'do' (noted with the word 'try')
            do {
                //This line calls the static function defined in the Network.swift file. This function returns an instance of UIImage that is then assigned to the imageView on this ViewController instance.
                let image = try await Network.fetchDogPhoto()
                imageView.image = image
            } catch {
                print(error)
            }
        }
    }
}

