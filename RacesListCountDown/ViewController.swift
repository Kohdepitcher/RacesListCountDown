//
//  ViewController.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 7/7/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    //Properties
    var modal = MeetingModel()
    
    //timer that handles updating the remaining time labels in the cells every second
    var timer: Timer?
    
    private lazy var dataSource = makeDataSource()
    
    //Define views
    var titleLabel: UILabel!
    
    //collectionview
    lazy var ListCollectionView: UICollectionView = {
       
        //collection view layout configuration
        let size = NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                    heightDimension: NSCollectionLayoutDimension.estimated(44)
                )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        section.interGroupSpacing = 10

        //create compositional layout using section size
        let layout = UICollectionViewCompositionalLayout(section: section)
                
        //init the collectionview and set the layout
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //register the list row cell used for the collection view
        collectionView.register(ListRowCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdenitifier.ListCell.rawValue)
        
        //set the background color for the collectionview
        collectionView.backgroundColor = UIColor(named: "Background Color")
        
        
        
        
//        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        
        collectionView.allowsMultipleSelection = false
        
        
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true

        //reference to the navigation bar used by this VC's navigation controller
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        //init the Label used above the large title
        titleLabel = UILabel()
        
        //setup properties for the titleLabel
        titleLabel.text = DateFormatter.monthLongAndShortDay.string(from: modal.meetingDate)//"THURSDAY, 8 JUL"
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        //add the title label to the navigation bar
        navigationBar.addSubview(titleLabel)
        
        //add the collectionview to the view controller
        self.view.addSubview(ListCollectionView)
        
        //turn off autoresizing masks
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //setup contraints
        NSLayoutConstraint.activate([
        
            titleLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -48),
            
            ListCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            ListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            ListCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        ])
        
        
        //set the datasource for the collectionview
        ListCollectionView.dataSource = dataSource
        
        //update the collectionview to use the data from the model
        applySnapShot()
        
        //start the timer to calculate reminaing time for each race cell
        createTimer()
    }


}

extension ViewController {
    /*
     *  Responsible for creating the timer that updates the remaining time label in each cell
     */
    func createTimer() {
        
        /*
         *  Check if the timer is nil
         *  meaning that it has been stopped or waiting to be started
         */
        if timer == nil {

            //create a new timer
            let timer = Timer(timeInterval: 1.0,                //Fire every second
                              target: self,
                              selector: #selector(updateTimer), //Call the update function when fired
                              userInfo: nil,
                              repeats: true)
            
            //add to the common run loop
            RunLoop.current.add(timer, forMode: .common)
            
            //increase the tolerance to optimise for efficiency and battery life
            timer.tolerance = 0.1

            //set the VC's timer to the new one
            self.timer = timer
        }
    }
    
    func stopTimer() {
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func updateTimer() {
        
//        //turn of the timer if time is past the last race time
//        if let lastRace = modal.meeting.Races.last {
//            
//            //check if the race is past now
//            if lastRace.LocalStartTime > Date() {
//                
//                print("Last race finished")
//                
//                stopTimer()
//                
//            }
//            
//        }
        
        let visibleRowsIndexPaths: [IndexPath] = self.ListCollectionView.indexPathsForVisibleItems
      
//        guard let visibleRowsIndexPaths: [IndexPath] = self.ListCollectionView.indexPathsForVisibleItems else {
//        return
//      }

      for indexPath in visibleRowsIndexPaths {
        
        if let cell = self.ListCollectionView.cellForItem(at: indexPath) as? ListRowCollectionViewCell {
          cell.UpdateRemainingTime()
        }
      }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //https://stackoverflow.com/questions/55539363/navigation-bar-with-large-titles-and-right-uibarbuttonitem
//        let maxTitlePoint = tableView.convert(CGPoint(x: titleStackView.titleLabel.bounds.minX, y: titleStackView.titleLabel.bounds.maxY), from: titleStackView.titleLabel)
        //title = scrollView.contentOffset.y > 0 ? "Listen Now" : nil
        
        var progress =  ( (scrollView.contentOffset.y + 136 ) * -0.15 )
////        progress.negate()
//
//
//        titleLabel.alpha = progress
        
        print("subtitle label alpha: \(progress) ")
        print("scrollview offset \(scrollView.contentOffset.y)")
        
        
        var offset: CGFloat = scrollView.contentOffset.y + 143
        var percentage: CGFloat = offset / 25
        var value: CGFloat = 25 * percentage
        var alpha: CGFloat = 1 - fabs(percentage)
        
        if offset < 0 {
            titleLabel.alpha = 1
        } else {
            titleLabel.alpha = pow(alpha, 3)
        }
        
     }
    
}

private extension ViewController {
    
    enum ReuseIdenitifier: String {
        case ListCell
    }
    
    //define sections
    enum Section: Int, CaseIterable {
        case main
        //case add
    }
    
    /*
     *  This func is responsible for configuring the datasource for the collection view
     */
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Race> {
        
        UICollectionViewDiffableDataSource(collectionView: ListCollectionView, cellProvider: { ListCollectionView, indexPath, race in
            
            let cell = ListCollectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdenitifier.ListCell.rawValue, for: indexPath) as! ListRowCollectionViewCell
            
            cell.configure(with: race)
            
            return cell
            
        })
        
    }
    
    /*
     *  This function is responsible for updating the datasource for the collection view with a new data snapshot
     *  Has an optional parameter for whether or not changes should be animated between updatesß
     */
    private func applySnapShot(animatingDifferences: Bool = true) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Race>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems(modal.meeting.Races, toSection: Section.main)
        
        dataSource.apply(snapshot)

        //get the fetched objects from the fetched results controller
        //if there's none, use an empty array
        //there should always be units
//        let fetched = unitsProvider.fetchedObjects ?? []
//
//        //set the snapshot to a new snapshot
//        snapShot = DataSourceSnapShot()
//
//        //append all the possible sections
//        snapShot.appendSections(collectionViewSections.allCases)
//
//        /*
//         *  Determines which items to show based on editing status
//         *  If in ediitng mode, show all the objects from the fetched results controller
//         *  If not in editing mode, show only those that are 'enabled' i.e. not hiddenß
//         */
//        snapShot.appendItems( self.isEditing ? fetched : fetched.filter{ $0.isEnabled == true } , toSection: .units)
//
//        //append a 'fake' or 'empty' CDUnit so that the add button appears
////        snapShot.appendItems([CDUnit()], toSection: .add)
//
//        //finally apply the new snapshot changes to the datasource
//        dataSource.apply(snapShot, animatingDifferences: animatingDifferences, completion: { [self] in
//            dataSource.apply(snapShot, animatingDifferences: false)
//        })
    }
    
}



