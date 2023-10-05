//
//  ViewController.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 7/7/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //Properties
    var modal = MeetingModel()
    
    //timer that handles updating the remaining time labels in the cells every second
    var timer: Timer?
    
    private lazy var dataSource = makeDataSource()
    
    //Define views
    var titleLabel: UILabel!
    
    //reference to app delegate
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //reference to the managed context in the app delegate
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<CDMeeting> = {
            
            //init fetch request
            let fetchRequest: NSFetchRequest<CDMeeting> = CDMeeting.fetchRequest()
        
        
            
            //add sort descriptors
            let sort = NSSortDescriptor(key: "meetingDate", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            
            //init fetfhed results controller
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self
            return fetchedResultsController
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //try fetching the meeting from core data
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
        
        //enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = getMeetingRaceLocation()

        //reference to the navigation bar used by this VC's navigation controller
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        
        //setup the right bar button item in nav bar
        //let downloadRacesBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.circle"), style: .plain, target: self, action: #selector(showFetchRaceDataScreen(_:)))
        //self.navigationItem.rightBarButtonItem = downloadRacesBarButton
        
        //menu button
        let menuButton = UIBarButtonItem(systemItem: .edit, primaryAction: nil, menu: createMenu())
        self.navigationItem.rightBarButtonItem = menuButton
        
        //init the Label used above the large title
        titleLabel = UILabel()
        
        //setup properties for the titleLabel
        titleLabel.text = getFormattedMeetingDateFromFirstRace().uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
    
    private func createMenu() -> UIMenu {
        
        let clearAction = UIAction(title: "Clear Meeting", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { [self] action in
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMeeting")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.managedContext.execute(deleteRequest)
            } catch let error as NSError {
              debugPrint(error)
            }
            
            //self.managedContext.refreshAllObjects()
            
            //try fetching the meeting from core data
//            do {
//                try fetchedResultsController.performFetch()
//
//            } catch {
//
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
            
//            var snapshot = NSDiffableDataSourceSnapshot<Section, CDRace>()
//            snapshot.appendSections(Section.allCases)
//            snapshot.deleteAllItems()
            
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            dataSource.apply(snapshot)
            
            
            //self.applySnapShot()
            self.titleLabel.text = ""
        }
        
        
        
        
        
        //store the menu actions
        let menuActions: [UIAction] = [clearAction]
        
        return UIMenu(title: "", children: menuActions)
    }
    
    /*
     *  Formats the date from the meeting and returns it in the custom format
     *  Is used in the navigation bar's subtitle
     */
    private func getFormattedMeetingDateFromFirstRace() -> String {
        
        if let meeting = fetchedResultsController.fetchedObjects?.first {
            guard let meetingDate = meeting.meetingDate else {return ""}
            
            return DateFormatter.monthLongAndShortDay.string(from: meetingDate) //"THURSDAY, 8 JUL"
        } else {
            return ""
        }
        
    }
    
    /*
     *  Gets the meeting's location safely from the fetched results controller
     *  Is used in the navigation bar's title
     */
    private func getMeetingRaceLocation() -> String {
        
        if let meeting = fetchedResultsController.fetchedObjects?.first {
            guard let meetingLocation = meeting.meetingLocation else {return "Races"}
            
            return meetingLocation
        } else {
            return "Races"
        }
        
    }

    
    //Functions
    @objc func showFetchRaceDataScreen(_ sender: UIBarButtonItem) {
        
        //stop the timer
        //self.timer?.invalidate()
        
        self.present(RaceDataFetcherUIViewController(), animated: true) {
            //self.applySnapShot()
            
            print("Start")
        }
        
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
        
//        print("subtitle label alpha: \(progress) ")
//        print("scrollview offset \(scrollView.contentOffset.y)")
        
        
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
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, CDRace> {
        
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
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CDRace>()
        snapshot.appendSections(Section.allCases)
        
        guard let meeting = fetchedResultsController.fetchedObjects?.first else { return }
        guard let races = meeting.races?.allObjects as? [CDRace] else { return }
        
        let sortedRaces = races.sorted { $0.order < $1.order }
        
        snapshot.appendItems(sortedRaces, toSection: Section.main)
        
        dataSource.apply(snapshot)

    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let EditorVC = RaceEditorUIViewController()
//        EditorVC.context = self.managedContext
//
//        self.present(EditorVC, animated: true, completion: nil)
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
                print("controllerDidChangeContent")

                do {
                    try fetchedResultsController.performFetch()

                    //update the navigation bar incase the meeting date or location has changed
                    titleLabel.text = getFormattedMeetingDateFromFirstRace()
                    navigationController?.navigationBar.topItem?.title = getMeetingRaceLocation()

                } catch let error as NSError {
                    print(error)
                }


                applySnapShot()
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
//
//        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
//        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>
//
//        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
//            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
//                return nil
//            }
//            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
//            return itemIdentifier
//        }
//
//        snapshot.reloadItems(reloadIdentifiers)
//
//        snapshot.appendSections([.main])
//        snapshot.appendItems([NSManagedObjectID()], toSection: .main)
//
//        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Section, NSManagedObjectID>, animatingDifferences: false)
//    }
}



