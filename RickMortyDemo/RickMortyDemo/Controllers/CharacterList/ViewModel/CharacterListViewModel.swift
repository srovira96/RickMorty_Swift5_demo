//
//  CharacterListViewModel.swift
//  RickMortyDemo
//
//  Created by Avantiam on 28/4/24.
//

import Foundation

protocol onCharacterListViewModel {
	func onModelUpdated()
	func onError()
	func onUpdateFilerData()
}

class CharacterListViewModel {
	
	/// Comunication layer to request Characters information
	private let apiClient : CharactersApiClient
	
	/// Delegate used to perform changes on view
	public var delegate : onCharacterListViewModel?
	
	/// Array of characters
	private(set) var characterList : [Character] = []
	
	/// Current ws page value
	private var pageToRequest: Int64 = 1
	
	/// Boolean that controls if new page is requesting. Used to prevent duplicated calls
	private var isRequestingPage: Bool = false
	
	/// Boolean that tells if there are more pages to request
	private var canRequestMorePages: Bool = true
	
	/// Array of filters to be aplied to ws call
	private(set) var filterApplyed:[Filter_Character_Types:Any?] = [
		.gender: nil,
		.status: nil,
		.text: nil
	] {
		didSet {
			self.delegate?.onUpdateFilerData()
		}
	}
	
	
	/// Init view model
	/// - Parameter apiClient: API Client used to fetch characters
	init(apiClient: CharactersApiClient) {
		self.apiClient = apiClient
	}
	
	/// Function that fetch a list of characters
	/// - Parameter filterOptions: Filter to be applied on request
	public func fetchChatacterList() {
		if !isRequestingPage && canRequestMorePages {
			isRequestingPage = true
			apiClient.fetchCharacters(on: self.pageToRequest, with: filterApplyed) { result in
				
				self.isRequestingPage = false
				switch result {
					case .success(let success):
						if self.pageToRequest == 1 {
							self.characterList = []
						}
						self.pageToRequest += 1
						
						if let infoData = success.info {
							self.canRequestMorePages = infoData.next != nil
						}
						
						self.characterList.append(contentsOf: success.results ?? [])
						self.delegate?.onModelUpdated()
						
					case .failure(_:):
						self.delegate?.onError()
				}
			}
		}
	}
	
	/// Reset model. It will reset control variables, paging and characters fetched
	public func resetCharacterModel() {
		self.pageToRequest = 1
		self.canRequestMorePages = true
		self.characterList = []
	}
	
	
	/// Reset filter options. (Character gender and character status)
	public func resetFilterModel() {
		filterApplyed[.gender] = nil
		filterApplyed[.status] = nil
	}
	
	
	/// Apply filter options to current model
	/// - Parameter arrayFilters: Array of filters to apply
	public func setFilterOptions(arrayFilters: [filterType]) {
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
	}
	
	/// Set new "Text" search to filter fetched characters by name
	/// - Parameter value: Text to be used to filter characters by name
	public func setTextFilterOption(_ value: String?) {
		filterApplyed[.text] = value
	}
	
}
