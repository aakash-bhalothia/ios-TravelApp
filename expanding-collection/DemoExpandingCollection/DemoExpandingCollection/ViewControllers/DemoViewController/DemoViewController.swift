//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoViewController: ExpandingViewController {
  
    typealias ItemInfo = (image: UIImage, title: String, address: String, startingTime: String, endingTime: String, locationTiming: String)
  fileprivate var cellsIsOpen = [Bool]()
  var items: [ItemInfo] = []
  
  @IBOutlet weak var pageLabel: UILabel!
}

// MARK: life cicle

extension DemoViewController {
  
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 335)
    super.viewDidLoad()
    
    registerCell()
    fillCellIsOpeenArry()
    addGestureToView(collectionView!)
    configureNavBar()
  }
}

// MARK: Helpers 

extension DemoViewController {
  
  fileprivate func registerCell() {
    
    let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
    collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
  }
  
  fileprivate func fillCellIsOpeenArry() {
    for _ in items {
      cellsIsOpen.append(false)
    }
  }
  
//  fileprivate func getViewController() -> ExpandingTableViewController {
//    let storyboard = UIStoryboard(storyboard: .Main)
////    let toViewController: DemoTableViewController = storyboard.instantiateViewController()
//    return toViewController
//  }
  
  fileprivate func configureNavBar() {
    navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
  }
}

/// MARK: Gesture

extension DemoViewController {
  
  fileprivate func addGestureToView(_ toView: UIView) {
    let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .down
    }
    toView.addGestureRecognizer(gesutereUp)
    toView.addGestureRecognizer(gesutereDown)
  }

  func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard let cell  = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
    // double swipe Up transition
//    if cell.isOpened == true && sender.direction == .up {
//      pushToViewController(getViewController())
    
//      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//        rightButton.animationSelected(true)
//      }
//    }
    
    let open = sender.direction == .up ? true : false
    cell.cellIsOpen(open)
    cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
  }
}

// MARK: UIScrollViewDelegate 

extension DemoViewController {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageLabel.text = "\(currentIndex+1)/\(items.count)"
  }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? DemoCollectionViewCell else { return }

    let index = (indexPath as NSIndexPath).row % items.count
    let info = items[index]
    cell.backgroundImageView?.image = info.image
    cell.customTitle.text = info.title
    cell.address.text = info.address
    cell.startingTimeLabel.text = info.startingTime
    cell.endingTimeLabel.text = info.endingTime
    cell.locationTimingLabel.text = info.locationTiming
    
    
    cell.cellIsOpen(cellsIsOpen[index], animated: false)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
          , currentIndex == (indexPath as NSIndexPath).row else { return }
    
    
    
    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
//      pushToViewController(getViewController())
        cell.cellIsOpen(false)
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
  }
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath) as! DemoCollectionViewCell
    let row = indexPath.row
    
    
    cell.googleMapsTap = { (cell) in
        //        self.showAlertForRow(collectionView.indexPathForCell(cell)!.row)
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let starting_string_spaces = self.items[row].address
            let starting_string_plusses = starting_string_spaces.replacingOccurrences(of: " ", with: "+")
            
            if ((row + 1) < self.items.count) {
                let ending_string_spaces = self.items[row+1].address
                let ending_string_plusses = ending_string_spaces.replacingOccurrences(of: " ", with: "+")
                
                UIApplication.shared.openURL(NSURL(string:
                    String(format: "comgooglemaps://?saddr=%@&daddr=%@&directionsmode=driving", starting_string_plusses, ending_string_plusses))! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string:
                    String(format: "comgooglemaps://?saddr=%@&daddr=%@&directionsmode=driving", starting_string_plusses, "HELL"))! as URL)
            }
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
    cell.uberTap = { (cell) in
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"uber://")! as URL)) {
            let starting_string_spaces = self.items[row].address
            let starting_string_temp1 = starting_string_spaces.replacingOccurrences(of: ",", with: "%2C")
            let starting_string_plusses = starting_string_temp1.replacingOccurrences(of: " ", with: "%20")
            
            
            if ((row + 1) < self.items.count) {
                let ending_string_spaces = self.items[row+1].address
                let ending_string_temp1 = ending_string_spaces.replacingOccurrences(of: ",", with: "%2C")
                let ending_string_plusses = ending_string_temp1.replacingOccurrences(of: " ", with: "%20")
                print(ending_string_plusses)
                UIApplication.shared.openURL(NSURL(string:
                    String(format: "uber://?client_id=2R4nRIxMfSv2W5B8uXWw-bV3vsoOR52Z&action=setPickup&pickup[formatted_address]=%@&dropoff[formatted_address]=%@", starting_string_plusses, ending_string_plusses))! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string:
                    String(format: "uber://?client_id=2R4nRIxMfSv2W5B8uXWw-bV3vsoOR52Z&action=setPickup&pickup[formatted_address]=%@&dropoff[formatted_address]=%@", starting_string_plusses, "USA"))! as URL)
            }
            
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    

    
    return cell
  }
}
