//
//  AddressPickerVC.swift
//  AddressPicker
//
//  Created by Gaurang on 06/10/22.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

private let cellId = "cell"

class AddressPickerVC: UITableViewController {
    var onSelectedAddress: (_ location: LocationInfo) -> Void

    lazy var searchBar = UISearchBar()
    var fetcher: GMSAutocompleteFetcher?
    private var debounceTimer: Timer?

    private var autocompletePredictionArray: [GMSAutocompletePrediction] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(onSelectedAddress: @escaping (_ location: LocationInfo) -> Void) {
        self.onSelectedAddress = onSelectedAddress
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.keyboardDismissMode = .onDrag
        setupSearchController()
        setupAutoComplete()
        self.searchBar.becomeFirstResponder()
    }

    private func setupSearchController() {
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.placeholder = "Search places"
        navigationItem.titleView = self.searchBar
    }

    private func setupAutoComplete() {
        let filter = GMSAutocompleteFilter()
        if let location = LocationManager.shared.mostRecentLocation {
            let target = location.coordinate
            let northeast = CLLocationCoordinate2D(latitude: target.latitude + 0.1, longitude: target.longitude + 0.1)
            let southwest = CLLocationCoordinate2D(latitude: target.latitude - 0.1, longitude: target.longitude - 0.1)
            filter.locationBias = GMSPlaceRectangularLocationOption(northeast, southwest)
            filter.countries = ["GY"]
        }
        
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher?.delegate = self
    }

    @objc func selectFromMapTapped() {}

    func getLatLongFromAutocompletePrediction(prediction: GMSAutocompletePrediction, completion: @escaping(_ place: GMSPlace?) -> Void) {
        let placeClient = GMSPlacesClient()
        placeClient.lookUpPlaceID(prediction.placeID) { place, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if let place = place {
                print(place.addressComponents ?? "")
                completion(place)
            }
        }
    }

    private func close() {
        self.dismiss(animated: true)
    }
    
    func bindToSystemNavigation() -> UINavigationController {
        let navVC = UINavigationController(rootViewController: self)
        let barAppearance = navVC.navigationBar
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            barAppearance.standardAppearance = appearance
            barAppearance.scrollEdgeAppearance = appearance
        } else {
            let system = UINavigationBar()
            barAppearance.setBackgroundImage(nil, for: .default)
            barAppearance.shadowImage = system.shadowImage
            barAppearance.backgroundColor = system.backgroundColor
            barAppearance.isTranslucent = system.isTranslucent
            barAppearance.isOpaque = system.isTranslucent
            barAppearance.barTintColor = .white
            barAppearance.tintColor = system.tintColor
            barAppearance.titleTextAttributes = system.titleTextAttributes
        }
        return navVC
    }
}

// MARK: - TableView methods

extension AddressPickerVC {

    override func numberOfSections(in _: UITableView) -> Int {
        if autocompletePredictionArray.isNotEmpty {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        4
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if autocompletePredictionArray.isNotEmpty {
            return autocompletePredictionArray.count
        } else {
            return 0//recentAddresses.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let info = autocompletePredictionArray[indexPath.row]
        cell.textLabel?.attributedText = info.attributedPrimaryText
        cell.detailTextLabel?.attributedText = info.attributedSecondaryText
        cell.detailTextLabel?.textColor = .gray
        cell.imageView?.image = UIImage(systemName: "mappin.circle")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchBar.resignFirstResponder()
        if autocompletePredictionArray.isNotEmpty {
            let prediction = autocompletePredictionArray[indexPath.row]
            getLatLongFromAutocompletePrediction(prediction: prediction) { [weak self] place in
                if let place = place {
                    let location = LocationInfo(place: place)
                    self?.onSelectedAddress(location)
                    self?.close()
                }
            }
        }
    }
}

// MARK: - Autocomplete methods
extension AddressPickerVC: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        autocompletePredictionArray = predictions
    }
    func didFailAutocompleteWithError(_: Error) {}
}

extension AddressPickerVC: UISearchControllerDelegate {}

// MARK: - search bar methods

extension AddressPickerVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.close()
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if searchText.count >= 3 {
                print("Search Text", searchText)
                self.fetcher?.sourceTextHasChanged(searchText)
            } else {
                self.autocompletePredictionArray = []
            }
        }
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
        return true
    }
}

class SubtitleTableViewCell: UITableViewCell {
    override init(style _: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Array {
    var isNotEmpty: Bool {
        return count > 0
    }
}
