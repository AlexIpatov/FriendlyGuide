//
//  OnMapSliderView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

class OnMapSliderView: UIView {
    // MARK: - UI components
    private(set) lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private(set) lazy var viewForTable: UIView = {
        let viewForTable = UIView()
        viewForTable.translatesAutoresizingMaskIntoConstraints = false
        return viewForTable
    }()
    
    private(set) lazy var removeSliderButton = UIButton(image: UIImage(systemName: "chevron.compact.down"),
                                                        backgroundColor: .white)
    
    private(set) lazy var sliderTitleNameLabel = UILabel(text: "Поиск",
                                                         font: .smallTitleFont(),
                                                         textColor: .systemBlue,
                                                         numberOfLines: 1,
                                                         textAlignment: .center,
                                                         adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var sourceSelectionSegmentedControl = UISegmentedControl(items: ["Места", "События"],
                                                                               selectedSegmentIndex: 0,
                                                                               backgroundColor: .systemGray6)
    
    private(set) lazy var searchTextField = UITextField(placeholder: "Введите место для поиска",
                                                        font: .smallTitleFont(),
                                                        borderStyle: .roundedRect)
    
    private(set) lazy var placesAndEventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.rowHeight = 40
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewForUITests()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    func configureViewForUITests() {
        accessibilityIdentifier = "onMapSliderScreenView"
        viewForTable.accessibilityIdentifier = "onMapSliderScreenViewForTableView"
        placesAndEventsTableView.accessibilityIdentifier = "placesAndEventsTableView"
    }
    
    func configureUI() {
        backgroundColor = .white

        addSubview(headerView)
        addSubview(viewForTable)
        
        headerView.addSubview(removeSliderButton)
        headerView.addSubview(sliderTitleNameLabel)
        headerView.addSubview(sourceSelectionSegmentedControl)
        headerView.addSubview(searchTextField)
        
        viewForTable.addSubview(placesAndEventsTableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor),
            headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140.0),
            
            viewForTable.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            viewForTable.leftAnchor.constraint(equalTo: self.leftAnchor),
            viewForTable.rightAnchor.constraint(equalTo: self.rightAnchor),
            viewForTable.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            removeSliderButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10.0),
            removeSliderButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            removeSliderButton.heightAnchor.constraint(equalToConstant: 30.0),
            removeSliderButton.widthAnchor.constraint(equalToConstant: 30.0),
            
            sliderTitleNameLabel.topAnchor.constraint(equalTo: removeSliderButton.bottomAnchor, constant: 0.0),
            sliderTitleNameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            sliderTitleNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            sourceSelectionSegmentedControl.topAnchor.constraint(equalTo: sliderTitleNameLabel.bottomAnchor, constant: 5),
            sourceSelectionSegmentedControl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            sourceSelectionSegmentedControl.heightAnchor.constraint(equalToConstant: 30.0),
            sourceSelectionSegmentedControl.widthAnchor.constraint(equalToConstant: 150.0),
            
            searchTextField.topAnchor.constraint(equalTo: sourceSelectionSegmentedControl.bottomAnchor, constant: 10.0),
            searchTextField.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
            searchTextField.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            placesAndEventsTableView.topAnchor.constraint(equalTo: viewForTable.topAnchor, constant: 5.0),
            placesAndEventsTableView.leftAnchor.constraint(equalTo: viewForTable.leftAnchor),
            placesAndEventsTableView.rightAnchor.constraint(equalTo: viewForTable.rightAnchor),
            placesAndEventsTableView.bottomAnchor.constraint(equalTo: viewForTable.bottomAnchor)
        ])
    }
}
