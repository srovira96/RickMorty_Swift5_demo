//
//  CharacterDetailViewModel.swift
//  RickMortyDemo
//
//  Created by Avantiam on 29/4/24.
//

import Foundation

protocol onCharacterDetailViewModel {
	func onModelUpdated()
	func onError()
}

class CharacterDetailViewModel {
	
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	private let apiClient : CharactersApiClient
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Target character to be showed
	private(set) var character : Character!
	
	/// Delegate that control changes in model
	public var delegate : onCharacterDetailViewModel?
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(apiClient: CharactersApiClient, character: Character) {
		self.apiClient = apiClient
		self.character = character
	}
	
	func fetchCharacterDetail() {
		apiClient.fetchCharacterDetail(self.character.id) { result in
			switch result {
				case .success(let success):
					self.character = success
					self.delegate?.onModelUpdated()
					
				case .failure(let failure):
					self.delegate?.onError()
			}
		}
	}
	
	
}
