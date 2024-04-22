//
//  CharacterListFilterC.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import UIKit


enum Filter_Character_Types: Equatable {
	case text
	case status
	case gender
	
	func get_ws_param() -> String {
		switch self {
			case .text:
				return "name"
			case .status:
				return "status"
			case .gender:
				return "gender"
		}
	}
}


protocol onCharacterListFilterC {
	func didSelectFilters(arrayFilters:[filterType])
	func didUpdateFiltersSelected(arrayFilters:[filterType])
	func didClearFilters()
}


class CharacterListFilterC: UIViewController {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewContent: UIView!
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var stackFilterContent: UIStackView!
	
	@IBOutlet weak var btnApply: UIButton!
	@IBOutlet weak var btnClear: UIButton!
	@IBOutlet weak var btnClose: UIButton!
	
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Array of filterType that will be used to configure view content
	private var arrayFilterOptions: [filterType] = []
	
	/// Delegate that will recive all filtered data
	private var delegate: onCharacterListFilterC!
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	
	/// Init view
	/// - Parameters:
	///   - delegate: Delgate that will revice filtered data
	///   - filterOptions: Arrat of filterType that will be used to configure view content
	init(delegate: onCharacterListFilterC, filterOptions: [filterType]) {
		super.init(nibName: "CharacterListFilterC", bundle: .main)
		modalTransitionStyle = .coverVertical
		modalPresentationStyle = .pageSheet
		isModalInPresentation = true
		self.delegate = delegate
		self.arrayFilterOptions = filterOptions
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		
		// Localizable ---
		lblTitle.text = "character_filter_title".localized()
		btnApply.setTitle("character_btn_apply".localized(), for: .normal)
		btnClear.setTitle("character_btn_clear".localized(), for: .normal)
		// ---- localizable
		
		// Style ---
		viewContent.layer.cornerRadius = 20
		
		lblTitle.font = .retrieveCustomFont(font: .black, size: 17.0)
		btnApply.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		btnClear.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		
		btnApply.backgroundColor = .COLOR_PRIMARY
		btnApply.setTitleColor(.COLOR_SECONDARY, for: .normal)
		btnApply.layer.cornerRadius = 12
		
		btnClear.layer.borderWidth = 2
		btnClear.layer.borderColor = UIColor.COLOR_SECONDARY.cgColor
		btnClear.setTitleColor(.COLOR_SECONDARY, for: .normal)
		btnClear.layer.cornerRadius = 12
		
		btnClose.layer.cornerRadius = 12
		btnClose.layer.shadowOffset = .init(width: 0, height: 0)
		btnClose.layer.shadowRadius = 4
		btnClose.layer.shadowOpacity = 0.5
		btnClose.layer.shadowColor = UIColor.black.cgColor
		btnClose.backgroundColor = .COLOR_PRIMARY
		btnClose.tintColor = .COLOR_SECONDARY
		btnClose.setImage(UIImage.init(resource: .iconClose).withTintColor(.COLOR_SECONDARY), for: .normal)
		btnClose.setTitle("btn_close".localized(), for: .normal)
		btnClose.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		// --- style
		
		// Config stack views bases on arrayFilterOptions data provided
		stackFilterContent.subviews.forEach({$0.removeFromSuperview()})
		for filter in arrayFilterOptions {
			let nview = FilterBoxView()
			nview.configView(self, delegate: self, type: filter)
			stackFilterContent.addArrangedSubview(nview)
		}
		
    }

	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	/// ACTION: Send filter data to delegate obj onCharacterListFilterC > didSelectFilters
	@IBAction func btnApplyFiltersAction(_ sender: UIButton) {
		Vibration.light.vibrate()
		var arrayFilters:[filterType] = []
		for view in stackFilterContent.subviews {
			if let cast = view as? FilterBoxView {
				arrayFilters.append(cast.getAllSelectedObjects())
			}
		}
		delegate?.didSelectFilters(arrayFilters: arrayFilters)
		self.dismiss(animated: true)
	}
	
	
	/// ACTION: Send onCharacterListFilterC > didClearFilters to delegate attached to controller
	@IBAction func btnClearFiltersAction(_ sender: UIButton) {
		Vibration.light.vibrate()
		delegate.didClearFilters()
		self.dismiss(animated: true)
	}
	
	
	/// Dismiss current view without send anything to delegate
	@IBAction func btnCloseAction(_ sender: Any) {
		self.dismiss(animated: true)
	}
	

}

extension CharacterListFilterC: onFilterBoxViewDelegate {
	func didSelectRow() {}
}
