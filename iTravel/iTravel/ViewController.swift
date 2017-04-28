//
//  ViewController.swift
//  iTravel
//
//  Created by Aakash Bhalothia on 3/25/17.
//  Copyright © 2017 Aakash Bhalothia. All rights reserved.
//

import UIKit
import GooglePlaces



class ViewController: UIViewController {
    
    
    @IBOutlet weak var drivingSwitch: UISwitch!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    @IBOutlet weak var subView: UIView!
    
    var searchtext = "San Francisco, CA, USA"
    
    @IBAction func searchLoc(_ sender: Any) {
        performSegue(withIdentifier: "getNewTable", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "getNewTable" {
                let dest = segue.destination as! MainTableViewController
                    dest.city = searchtext
                if self.drivingSwitch.isOn{
                    dest.isDriving = true
                }
                else {
                    dest.isDriving = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.city
        resultsViewController?.autocompleteFilter = filter
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        subView.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.widthAnchor.constraint(equalTo: subView.widthAnchor)
        searchController?.searchBar.heightAnchor.constraint(equalTo: subView.heightAnchor)
        view.addSubview(subView)
        searchController?.searchBar.heightAnchor.constraint(equalTo: subView.heightAnchor)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}

// Handle the user's selection.
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        searchController?.searchBar.text = place.formattedAddress
        searchtext = place.formattedAddress!
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
