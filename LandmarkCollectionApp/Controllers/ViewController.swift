//
//  ViewController.swift
//  LandmarkCollectionApp
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    var landmarks: [Landmark] = []
    enum Section: Hashable {
        case featured
        case category(Landmark.Category)
    }
    
    enum Item: Hashable {
        case featuredLandmark(Landmark)
        case categoryLandmark(Landmark)
    }
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
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
        
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }

    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .featuredLandmark(let featuredLandmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredLandmarkCell", for: indexPath) as! featuredLandmarkCell
                cell.imageLandmark.image = featuredLandmark.image
                return cell
                
            case .categoryLandmark(let categoryLandmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryLandmarkCell", for: indexPath) as! categoryLandmarkCell
                cell.imageLandmark.image = categoryLandmark.image
                cell.name.text = categoryLandmark.name
                return cell
            }
        })
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.featured])
        for category in Landmark.Category.allCases {
            snapshot.appendSections([.category(category)])
        }
        
        let featuredItems = landmarks
            .filter(\.isFeatured)
            .map(Item.featuredLandmark)
        snapshot.appendItems(featuredItems, toSection: Section.featured)
        
        for category in Landmark.Category.allCases {
            let items = landmarks
                .filter{ landmark in
                    landmark.category == category
                }
                .map { landmark in
                    return Item.categoryLandmark(landmark)
                }
            snapshot.appendItems(items, toSection: .category(category))
        }
        
        return snapshot
    }

    private func loadInitialState() {
        let snapshot = createSnapshot()
        diffableDataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, NSCollectionLayoutEnvironment in
            guard let self = self,
                  let section = self.diffableDataSource.sectionIdentifier(for: sectionIndex) else {
                      return nil
            }
            
            switch section {
            case .featured:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitem: item,
                                                             count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 8, leading: 0, bottom: 32, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPaging
    
                return section
                
                
            case .category:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(128),
                                                       heightDimension: .absolute(128))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitem: item,
                                                             count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 8, leading: 8, bottom: 64, trailing: 8)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                return section
                
            }
            
        }
        return layout
    }

}

