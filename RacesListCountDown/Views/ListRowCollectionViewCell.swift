//
//  ListRowCollectionViewCell.swift
//  RacesListCountDown
//
//  Created by Kohde Pitcher on 7/7/21.
//

import UIKit

/*
 *  Defines the look of a list cell for a race
 */

class ListRowCollectionViewCell: UICollectionViewCell {
    
    //properties
    
    /*
     *  Local copy of the race data
     *  Set by the configure function down below
     */
    private var race: CDRace!
    
    //Define views
    lazy var RaceNumberLabel: UILabel = {
    
        var label = UILabel()
            label.text = "Race Number"
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    
        return label
    }()
    
    lazy var TimeRemainingLabel: UILabel = {
            
        var label = UILabel()
            label.text = "Time Left"
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label.textAlignment = .right
    
        return label
    }()
    
    lazy var RaceTimeLabel: UILabel = {
    
        var label = UILabel()
            label.text = "Race Start Time"
            label.font = UIFont.systemFont(ofSize: 17)
    
        return label
    }()
    
    lazy var RaceTitleLabel: UILabel = {
    
        var label = UILabel()
            label.text = "Race Name"
            label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
    
        return label
    }()
    
    
    //stack view that builds up the race information
    lazy var RaceDetailsVStack: UIStackView = {
       
        var stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(RaceNumberLabel)
        stackView.addArrangedSubview(RaceTimeLabel)
        stackView.addArrangedSubview(RaceTitleLabel)
        
        return stackView
        
    }()
    
    //override the frame initialiser so that we can setup the cell programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //set corner radius for cell
        self.layer.cornerRadius = 10
        
        //set border width to 0 so that cells lose the selection border when recycled
        self.layer.borderWidth = 0
        
        //set the color for the border selection indicator
        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        
        //set background color of cell from xcassets
        self.backgroundColor = UIColor(named: "Cell Background Color")
        
        //add views to the cell
        self.addSubview(RaceDetailsVStack)
        self.addSubview(TimeRemainingLabel)
        
        //turn off auto resizing masks
        RaceDetailsVStack.translatesAutoresizingMaskIntoConstraints = false
        TimeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //setup constraints
        RaceDetailsVStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        RaceDetailsVStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        RaceDetailsVStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        RaceDetailsVStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        TimeRemainingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        TimeRemainingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     *  This configures the cell
     *  Requires an Race object as a parameter
     */
    func configure(with race: CDRace, isNextRace: Bool = false) {
        
        //set the local race var to the passed parameter
        self.race = race
        
        //set the text in the labels
        self.RaceNumberLabel.text = "Race " + race.raceNumber!
        self.RaceTimeLabel.text = DateFormatter.HourMinuteFormatter.string(from: race.localStartTime!)
        self.RaceTitleLabel.text = race.raceTitle
        
        self.layer.borderWidth = isNextRace ? 2 : 0
        
        //show initial time left until race
        UpdateRemainingTime()
        
    }
    
    /*
     *  This calculates the time between now and the race time and puts that into the remaining time label
     */
    func UpdateRemainingTime() {
        
        //date as of now
        let currentDate = Date()
//        print("currentDate: \(currentDate)")
//        print("startTime: \(race.localStartTime!)")
        
        //get the amount of seconds from now and the local start time of the race
        let delta = Calendar.current.dateComponents([.second], from: currentDate, to: race.localStartTime!)
        
        //store the delta as seconds
        let deltaAsSeconds = delta.second
        
        //format the delta seconds into a normal format
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = deltaAsSeconds! <= 300 ? [.hour, .minute, .second] : [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        
        
        if deltaAsSeconds! <= 0 {
            self.TimeRemainingLabel.text = "Done"
        } else {
            self.TimeRemainingLabel.text = formatter.string(from: delta)!
        }
        
    }
    
    //highlighted cell state
    override var isHighlighted: Bool {
        didSet {
            
            //if the cell is highlighted
            if isHighlighted == true {
                
                
                UIView.animate(withDuration: 0.15) {
                    self.transform = .init(scaleX: 0.95, y: 0.95)
                }
                
            }
            
            //if the cell is unhighlighted
            else {
                
                
                UIView.animate(withDuration: 0.15) {
                    self.transform = .identity
                }
                
                
            }
            
        }
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//            let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//            layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//            return layoutAttributes
//        }
    
//    override func systemLayoutSizeFitting(
//            _ targetSize: CGSize,
//            withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
//            verticalFittingPriority: UILayoutPriority) -> CGSize {
//
//            // Replace the height in the target size to
//            // allow the cell to flexibly compute its height
//            var targetSize = targetSize
//            targetSize.height = CGFloat.greatestFiniteMagnitude
//
//            // The .required horizontal fitting priority means
//            // the desired cell width (targetSize.width) will be
//            // preserved. However, the vertical fitting priority is
//            // .fittingSizeLevel meaning the cell will find the
//            // height that best fits the content
//            let size = super.systemLayoutSizeFitting(
//                targetSize,
//                withHorizontalFittingPriority: .required,
//                verticalFittingPriority: .fittingSizeLevel
//            )
//
//            return size
//        }
    
}
