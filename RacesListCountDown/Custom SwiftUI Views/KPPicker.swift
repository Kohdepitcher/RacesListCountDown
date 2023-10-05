////
////  KPPicker.swift
////  RacesListCountDown
////
////  Created by Kohde Pitcher on 19/2/2022.
////
//
//import Foundation
//import UIKit
//
////MARK: View Styles
///*
// *  Support "Styles" for the picket
// *  - Wheel - mimics the nomral 3D affect when scrolling
// *  - Flat - mimics the "flat" style seen in Apple's Memoji creater
// */
//public enum KPPickerViewStyle {
//    case flat
//    case wheel
//}
//
////MARK: - Protocols
//public protocol KPPickerViewDataSource {
//    func numberOfItemsInPicker(_ pickerView: KPPickerView) -> Int
//    func pickerView(_ pickerView: KPPickerView, cellForItem item: Int) -> KPPickerCollectionViewCell
//}
//
//private protocol KPCollectionViewLayoutDelegate {
//    func pickerStyleForLayout(_ layout: KPPickerCollectionViewLayout) -> KPPickerViewStyle
//}
////MARK: - Base CollectionViewCell
///*
// *  This collection view cell is what is used for the picker
// *  By conforming to this collection view cell, you can have any kind of content for you picker
// */
//public class KPPickerCollectionViewCell: UICollectionViewCell {
//
//}
//
//public class KPTextCell: KPPickerCollectionViewCell {
//
//}
//
////MARK: - Custom Collectionview Layout
///*
// *  This is what creates the layout for the picker
// */
//private class KPPickerCollectionViewLayout: UICollectionViewFlowLayout {
//    var delegate: KPCollectionViewLayoutDelegate!
//    var width: CGFloat!
//    var midX: CGFloat!
//    var maxAngle: CGFloat!
//
//    //shared initialiser
//    func initialize() {
//        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//        self.scrollDirection = .horizontal
//        self.minimumLineSpacing = 0.0
//    }
//
//    override init() {
//        super.init()
//        initialize()
//    }
//
//    required init!(coder: NSCoder) {
//        super.init(coder: coder)
//        self.initialize()
//    }
//
//    fileprivate override func prepare() {
//        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
//        self.midX = visibleRect.midX;
//        self.width = visibleRect.width / 2;
//        self.maxAngle = CGFloat(Double.pi/2);
//    }
//
//    fileprivate override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//
//    fileprivate override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
//            switch self.delegate.pickerStyleForLayout(self) {
//            case .flat:
//                return attributes
//            case .wheel:
//                let distance = attributes.frame.midX - self.midX;
//                let currentAngle = self.maxAngle * distance / self.width / CGFloat(M_PI_2);
//                var transform = CATransform3DIdentity;
//                transform = CATransform3DTranslate(transform, -distance, 0, -self.width);
//                transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0);
//                transform = CATransform3DTranslate(transform, 0, 0, self.width);
//                attributes.transform3D = transform;
//                attributes.alpha = fabs(currentAngle) < self.maxAngle ? 1.0 : 0.0;
//                return attributes;
//            }
//        }
//
//        return nil
//    }
//
//    private func layoutAttributesForElementsInRect(_ rect: CGRect) -> [AnyObject]? {
//        switch self.delegate.pickerStyleForLayout(self) {
//        case .flat:
//            return super.layoutAttributesForElements(in: rect)
//        case .wheel:
//            var attributes = [AnyObject]()
//            if self.collectionView!.numberOfSections > 0 {
//                for i in 0 ..< self.collectionView!.numberOfItems(inSection: 0) {
//                    let indexPath = IndexPath(item: i, section: 0)
//                    attributes.append(self.layoutAttributesForItem(at: indexPath)!)
//                }
//            }
//            return attributes
//        }
//    }
//}
//
////MARK: - KPPickerView
//public class KPPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//}
