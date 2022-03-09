//
//  Landmark.swift
//  LandmarkCollectionApp
//
//  Created by lpiem on 09/03/2022.
//

import UIKit
import CoreLocation

struct Landmark: Decodable, Hashable {
    struct Coordinates: Decodable, Hashable {
        var longitude: Double
        var latitude: Double
    }
    
    enum Category: String, CaseIterable, Decodable {
        case lakes = "Lakes"
        case mountains = "Mountains"
        case rivers = "Rivers"
    }
    
    let name: String
    let category: Category
    let city: String
    let state: String
    let id: Int
    let isFeatured: Bool
    let isFavorite: Bool
    let park: String
    let description: String
    
    private let coordinates: Coordinates
    private let imageName: String
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinates.latitude,
                                      longitude: coordinates.longitude)
    }
    
}
