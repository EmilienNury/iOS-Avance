//
//  LandmarkDetailsViewController.swift
//  LandmarkCollectionApp
//
//  Created by lpiem on 16/03/2022.
//

import UIKit

class LandmarkDetailsViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var park: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    
    public var landmark: Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = landmark?.name
        image.image = landmark?.image
        state.text = landmark?.state
        city.text = landmark?.city
        park.text = landmark?.park
        desc.text = landmark?.description
        longitude.text = landmark?.locationCoordinate.longitude.description
        latitude.text = landmark?.locationCoordinate.latitude.description
    }
}
