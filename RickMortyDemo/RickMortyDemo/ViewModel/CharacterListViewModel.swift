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
}

class CharacterListViewModel {
	
	private let apiClient : CharactersApiClient
	public var delegate : onCharacterListViewModel?
	private(set) var characterList : [Character] = []
	
	/// Current ws page value
	private var pageToRequest: Int64 = 1
	
	/// Boolean that controls if new page is requesting. Used to prevent duplicated calls
	private var isRequestingPage: Bool = false
	
	/// Boolean that tells if there are more pages to request
	private var canRequestMorePages: Bool = true
	
	
	init(apiClient: CharactersApiClient) {
		self.apiClient = apiClient
	}
	
	
	public func fetchChatacterList(with filterOptions:[Filter_Character_Types:Any?]) {
		if !isRequestingPage && canRequestMorePages {
			isRequestingPage = true
			apiClient.fetchCharacters(on: self.pageToRequest, with: filterOptions) { result in
				
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
						
					case .failure(let failure):
						self.delegate?.onError()
				}
			}
		}
	}
	
	public func resetModel() {
		self.pageToRequest = 1
		self.canRequestMorePages = true
		self.characterList = []
	}
}
