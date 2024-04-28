//
//  CharacterListC.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import UIKit
import Alamofire

class CharacterListC: BaseC {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var viewLoading: LoadingView!
	@IBOutlet weak var viewEmpty: EmptyView!
	@IBOutlet weak var viewError: ErrorView!
	
	@IBOutlet weak var viewContentFilter: UIView!
	@IBOutlet weak var viewCharacterTxtFilter: CharacterTxtFilterView!
	
	@IBOutlet weak var tableView: UITableView!
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	var coordinator: CharacterCoordinator?
	var characterViewModel: CharacterListViewModel!
	
	var tableDataSource:CharacterListTableDataSource!
	
	/// UIViewController that allow user filter content
	private var filterView:CharacterListFilterC!

	
	/// Array of filters to be aplied to ws call
	private var filterApplyed:[Filter_Character_Types:Any?] = [
		.gender: nil,
		.status: nil,
		.text: nil
	] {
		didSet {
			// Set filter image if there are gender or status selected
			if ((filterApplyed[.gender] as? [Character_Gender])?.isEmpty ?? true) && ((filterApplyed[.status] as? [Character_Status])?.isEmpty ?? true) {
				let image = UIImage(resource: .iconFilter).withRenderingMode(.alwaysTemplate)
				image.withTintColor(.COLOR_SECONDARY)
				let filterNavButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.openFilterScreen))
				filterNavButton.tintColor = .COLOR_SECONDARY
				self.navigationItem.rightBarButtonItem = filterNavButton
			} else {
				let image = UIImage(resource: .iconFilterFilled).withRenderingMode(.alwaysTemplate)
				image.withTintColor(.COLOR_SECONDARY)
				let filterNavButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.openFilterScreen))
				filterNavButton.tintColor = .COLOR_SECONDARY
				self.navigationItem.rightBarButtonItem = filterNavButton
			}
		}
	}
	
	
	/// Variable that holds the last contentOffset observed by tableView to manage viewContentFilter visibility
	private var lastContentOffset: CGFloat = 0
	
	/// Array of characters
	private var arrayCharacters : [Character] = []
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(characterListViewModel: CharacterListViewModel) {
		super.init(nibName: "CharacterListC", bundle: .main)
		self.characterViewModel = characterListViewModel
		self.characterViewModel.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navBarColor = .clear
		self.title = "character_list_title".localized()
		
		tableDataSource = .init(arrayCharacters: characterViewModel.characterList, coordinator: coordinator, onBottomPaginationAction: {
			self.model_fetchData()
		})
		tableView.dataSource = tableDataSource
		tableView.delegate = tableDataSource
		
		
		// VIEWS SETUP
		viewLoading.alpha = 1
		tableView.alpha = 0
		viewEmpty.alpha = 0
		viewError.alpha = 0
		
		viewEmpty.configView()
		viewError.configView(self, action: {
			self.showView(type: .viewLoading)
			self.characterViewModel.resetModel()
			self.model_fetchData()
		})
		
		// View txt filter configuration (delegate)
		viewCharacterTxtFilter.configView(self)
		
		//Filter button
		let image = UIImage(resource: .iconFilter).withRenderingMode(.alwaysTemplate)
		image.withTintColor(.COLOR_SECONDARY)
		let filterNavButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.openFilterScreen))
		filterNavButton.tintColor = .COLOR_SECONDARY
		self.navigationItem.rightBarButtonItem = filterNavButton
		
		// Style --
		viewContent.layer.cornerRadius = 20
		viewContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		tableView.contentInset.top = 70
		// --- style
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		model_fetchData()
		tableView.reloadData()
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	
	func model_fetchData() {
		characterViewModel.fetchChatacterList(with: self.filterApplyed)
	}
	
	/// Method to switch between views
	/// - Parameters:
	///   - type: Type of view that wants to be displayed
	///   - mssgError: Error message to be displayed by viewError (unused)
	private func showView(type: viewType, mssgError: String? = "") {
		switch type {
			case .viewContent:
				UIView.animate(withDuration: 0.3, animations: {
					self.tableView.alpha = 1.0
					self.viewLoading.alpha = 0.0
					self.viewEmpty.alpha = 0.0
					self.viewError.alpha = 0.0
				})
			case .viewLoading:
				UIView.animate(withDuration: 0.3, animations: {
					self.tableView.alpha = 0.0
					self.viewEmpty.alpha = 0.0
					self.viewLoading.alpha = 1.0
					self.viewError.alpha = 0.0
				})
			case .viewEmpty:
				UIView.animate(withDuration: 0.3, animations: {
					self.tableView.alpha = 0.0
					self.viewLoading.alpha = 0.0
					self.viewEmpty.alpha = 1.0
					self.viewError.alpha = 0.0
				})
			case .viewError:
				UIView.animate(withDuration: 0.3, animations: {
					self.tableView.alpha = 0.0
					self.viewLoading.alpha = 0.0
					self.viewEmpty.alpha = 0.0
					self.viewError.alpha = 1.0
				})
				
			default:
				break
		}
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	/// ACTION - Open CharacterFilterView
	@objc func openFilterScreen() {
		// Configure 'filterVew' based on filters configuration
		filterView = CharacterListFilterC(delegate: self, filterOptions: [
			.gender(title: "character_gender".localized(), arrayData: Character_Gender.allCases, currentSelected: filterApplyed[.gender] as? [Character_Gender] ?? []),
			.status(title: "character_status".localized(), arrayData: Character_Status.allCases, currentSelected: filterApplyed[.status] as? [Character_Status] ?? [])
		])
		self.present(filterView, animated: true)
	}
	
	
}

extension CharacterListC {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Scroll view current Y offset
		let currentYOffset = scrollView.contentOffset.y
		
		// If scroll displacement is negative (going down) + space control(20) + bounce control, the viewContentFilter will disappear
		if currentYOffset > lastContentOffset && (currentYOffset - lastContentOffset) > 20 && currentYOffset > -tableView.contentInset.top && (scrollView.contentSize.height + scrollView.safeAreaInsets.bottom) > scrollView.frame.size.height{
			UIView.animate(withDuration: 0.3, animations: {
				self.viewContentFilter.alpha = 0
				self.viewContentFilter.transform = .init(translationX: 0, y: 10)
			})
			lastContentOffset = currentYOffset
			
			
			// Else, if scroll displacement is positive (going up) + space control (20) + bounce control, the viewContentFilter will appear
		} else if (currentYOffset - lastContentOffset) < -20 && ((scrollView.contentSize.height + scrollView.safeAreaInsets.bottom) - scrollView.frame.size.height) > scrollView.contentOffset.y
		{
			UIView.animate(withDuration: 0.3, animations: {
				self.viewContentFilter.alpha = 1
				self.viewContentFilter.transform = .identity
			})
			lastContentOffset = currentYOffset
		}
	}
	
}


extension CharacterListC: onCharacterTxtFilterView {
	func didChangeSearchValue(_ value: String?) {
		// Check if filter is already applied
		if filterApplyed[.text] != nil {
			if let value {
				// Modify current filter .text value and call ws
				filterApplyed[.text] = value
				
				// Fetch
				characterViewModel.resetModel()
				self.model_fetchData()
				// -- fetch
				
				self.tableView.contentOffset = .init(x: 0, y: -self.tableView.contentInset.top)
			} else {
				// Remove filter
				filterApplyed[.text] = nil
			}
		}
	}
}


extension CharacterListC: onCharacterListFilterC {
	func didSelectFilters(arrayFilters: [filterType]) {
		// Set all filter data retrived by 'arrayFilters' by type
		for filter in arrayFilters {
			switch filter {
				case .gender(_, _, let currentSelected):
					filterApplyed[.gender] = currentSelected
				case .status(_, _, let currentSelected):
					filterApplyed[.status] = currentSelected
				case .none:
					break
			}
		}
		// Perform new call reloading control parameters
		characterViewModel.resetModel()
		model_fetchData()
		
		self.tableView.contentOffset = .init(x: 0, y: -self.tableView.contentInset.top)
	}
	
	func didUpdateFiltersSelected(arrayFilters: [filterType]) {
		// unused
	}
	
	func didClearFilters() {
		// Clear all data
		filterApplyed[.gender] = nil
		filterApplyed[.status] = nil
		
		// Perform new call reloading control parameters
		characterViewModel.resetModel()
		model_fetchData()
		
		self.tableView.contentOffset = .init(x: 0, y: -self.tableView.contentInset.top)
	}
}


extension CharacterListC: onCharacterListViewModel {
	func onModelUpdated() {
		tableDataSource.arrayCharacters = characterViewModel.characterList
		tableView.reloadData()
		if characterViewModel.characterList.isEmpty {
			showView(type: .viewEmpty)
		} else {
			showView(type: .viewContent)
		}
	}
	func onError() {
		print("❌ Error")
		showView(type: .viewError)
	}
}
