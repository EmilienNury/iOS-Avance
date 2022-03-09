//
//  ViewController.swift
//  LandmarkCollectionApp
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    var landmarks: [Landmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = Bundle.main.url(forResource: "landmarkData", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            landmarks = try! decoder.decode([Landmark].self, from: data)
        }
        catch {
            print("error while decoding data")
        }

        print(landmarks.first)
    }


}

