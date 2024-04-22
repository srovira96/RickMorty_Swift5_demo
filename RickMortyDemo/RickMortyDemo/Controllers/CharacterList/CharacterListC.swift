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
	
	/// UIViewController that allow user filter content
	private var filterView:CharacterListFilterC!
	
	/// Current ws page value
	private var pageToRequest: Int64 = 1
	
	/// Boolean that controls if new page is requesting. Used to prevent duplicated calls
	private var isRequestingPage: Bool = false
	
	/// Boolean that tells if there are more pages to request
	private var canRequestMorePages: Bool = true
	
	
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navBarColor = .clear
		self.title = "character_list_title".localized()
		
		
		// VIEWS SETUP
		viewLoading.alpha = 1
		tableView.alpha = 0
		viewEmpty.alpha = 0
		viewError.alpha = 0
		
		viewEmpty.configView()
		viewError.configView(self, action: {
			self.showView(type: .viewLoading)
			self.pageToRequest = 1
			self.arrayCharacters.removeAll()
			self.ws_fetch_character_list(page: self.pageToRequest)
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
		ws_fetch_character_list(page: self.pageToRequest)
		tableView.reloadData()
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/// WS Make call to fetch characters WS_CHARACTER_LIST
	func ws_fetch_character_list(page: Int64) {
		isRequestingPage = true
		API.shared.get_characterList(page: page, filterOptions: self.filterApplyed) { result, method, error, array in
			self.processWSResponse(strAction: WS_CHARACTER_LIST, result: result, method: method, error: error, array: array)
		}
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
	
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	/// Process all ws response
	override func processWSResponse(strAction: String, result: AFResult<Data>, method: HTTPMethod?, error: NSError?, array: [String:Any]?) {
		
		isRequestingPage = false
		viewCharacterTxtFilter.stopLoadingAnimator()
		
		switch result {
			case .success:
				if error != nil {
					print("BaseC >>> processWSResponse\nWS = OK | Result = KO")
					showView(type: .viewError)
					
				} else {
					print("BaseC >>> processWSResponse\nWS = OK | Result = OK")
					
					// If 'Info > next' is null, meant that is the last page
					if let fetchedInfo = array?["info"] as? Info {
						self.canRequestMorePages = fetchedInfo.next != nil
					}
					
					// Get characters data
					if let fetchedCharacters = array?["arrayCharacters"] as? [Character] {
						// If is the first page, clear data to prevent duplicates
						if pageToRequest == 1 {
							arrayCharacters.removeAll()
						}
						// Add one more page to next request
						self.pageToRequest += 1
						// Append characters fetched to current array of characters
						arrayCharacters.append(contentsOf: fetchedCharacters)
						// Reload table content to apply new characters
						tableView.reloadData()
						
						// Config what view to see based on content retrieved
						if arrayCharacters.isEmpty {
							showView(type: .viewEmpty)
						} else {
							showView(type: .viewContent)
						}
						
					}
				}
			case .failure:
				print("BaseC >>> processWSResponse\nWS = KO | Result = ?")
				if error?.code == 404 {
					showView(type: .viewEmpty)
					arrayCharacters.removeAll()
					tableView.reloadData()
				} else {
					showView(type: .viewError)
				}
		}
	}
	
	
}

extension CharacterListC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrayCharacters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = "CharacterListCell"
		
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterListCell
		
		if cell == nil {
			tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
			cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CharacterListCell
		}
		
		// Config cell based con content selected
		cell?.configCell(arrayCharacters[indexPath.row])
		
		cell?.setNeedsUpdateConstraints()
		cell?.updateConstraintsIfNeeded()
		return cell!
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Check if cell exists and have contentView to animate
		if let cell = tableView.cellForRow(at: indexPath), let castCellView = cell as? CharacterListCell {
			// Make view bounce
			//castCellView.bounce()
			
			// Apply interaction feedback
			Vibration.soft.vibrate()
			
			// View reaction after 0.2s
			DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
				let vc = CharacterDetailC(character: self.arrayCharacters[indexPath.row], imgReferenceView: castCellView.imgCharacter)
				self.present(vc, animated: false)
			})
			
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		// Make call when least 4 items will be displayed by UITableView
		if indexPath.row > arrayCharacters.count - 4 && !isRequestingPage && canRequestMorePages {
			ws_fetch_character_list(page: self.pageToRequest)
		}
	}
	
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
				self.canRequestMorePages = true
				self.pageToRequest = 1
				self.ws_fetch_character_list(page: self.pageToRequest)
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
		self.canRequestMorePages = true
		self.pageToRequest = 1
		self.ws_fetch_character_list(page: self.pageToRequest)
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
		self.canRequestMorePages = true
		self.pageToRequest = 1
		self.ws_fetch_character_list(page: self.pageToRequest)
		self.tableView.contentOffset = .init(x: 0, y: -self.tableView.contentInset.top)
	}
	
	
}
