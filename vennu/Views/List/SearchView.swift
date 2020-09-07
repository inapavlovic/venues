//
//  SearchView.swift
//  users
//
//  Created by Ina Statkic on 26/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class SearchView: CardView {

    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchButton: UIButton?
    @IBOutlet private weak var filterButton: UIButton?
    @IBOutlet private weak var arrangeButton: UIButton?
    @IBOutlet private weak var numberOfPeoplePickerView: UIPickerView!
    
    // MARK: - Properties
    
    private var searchText: String = ""
    var searching: ((String) -> ())?
    var didSearch: ((String) -> ())?
    var didArrange: (() -> ())?
    var didFilters: (() -> ())?
    var pickNumberOfPeople: ((Int) -> ())?
//    private let range: Array = Array(Array(0..<50).suffix(from: 2))
    private let range: Array = Array(0..<50)
    
    var arrangedByMax: Bool = false {
        didSet {
            if arrangedByMax {
                arrangeButton?.imageView?.transform = CGAffineTransform.init(scaleX: 1, y: -1)
            } else {
                arrangeButton?.imageView?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
        }
    }
    
    var text: String? {
        get {
            searchBar.text
        }
        set {
            searchBar.text = newValue
        }
    }
    
    var numberOfPeople: Int {
        get {
            numberOfPeoplePickerView.selectedRow(inComponent: 0)
        }
        set {
            numberOfPeoplePickerView.selectRow(newValue, inComponent: 0, animated: true)
            pickerView(numberOfPeoplePickerView, didSelectRow: newValue, inComponent: 0)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBar.delegate = self
        setSearchBar()
        searchButton?.addTarget(self, action: #selector(searchVenues(_:)), for: .touchUpInside)
        arrangeButton?.addTarget(self, action: #selector(arrangeVenues(_:)), for: .touchUpInside)
        filterButton?.addTarget(self, action: #selector(filterVenues(_:)), for: .touchUpInside)
        numberOfPeoplePickerView.delegate = self
        numberOfPeoplePickerView.dataSource = self
    }
    
    // MARK: - Set
    
    private func setSearchBar() {
        if searchButton != nil {
            searchBar.setSearchFieldBackgroundImage(UIImage(named: "search.bar"), for: .normal)
        } else {
            searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchbar.gray"), for: .normal)
        }
        searchBar.tintColor = .coralRed
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        searchBar.searchTextField.textColor = .tuna
    }
    
    // MARK: - Actions
    
    @objc func searchVenues(_ sender: Any) {
        didSearch?(searchText)
    }
    
    @objc func arrangeVenues(_ sender: Any) {
        arrangedByMax.toggle()
        didArrange?()
    }
    
    @objc func filterVenues(_ sender: Any) {
        didFilters?()
    }
}

// MARK: - Search Bar Delegate

extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        searching?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didSearch?(searchText)
        searchBar.searchTextField.resignFirstResponder()
    }
}

// MARK: - Picker View Data Source

extension SearchView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return range.count
    }
}

// MARK: - Picker View Delegate

extension SearchView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width - 30, height: 20))
        label.textColor = .tuna
        label.font = .systemFont(ofSize: 14)
        label.text = "\(range[row]) People"
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 74
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickNumberOfPeople?(range[row])
        pickerView.subviews.last?.backgroundColor = .clear
    }
}
