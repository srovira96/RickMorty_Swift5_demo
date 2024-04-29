//
//  CharacterCoordinator.swift
//  RickMortyDemo
//
//  Created by Avantiam on 28/4/24.
//

import Foundation
import UIKit


class CharacterCoordinator {
	
	var navigationController: UINavigationController
	var apiCharacter = CharactersApiClient()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let characterViewModel = CharacterListViewModel(apiClient: apiCharacter)
		let vc = CharacterListC(viewModel: characterViewModel)
		vc.coordinator = self
		navigationController.viewControllers = [vc]
	}
	
	func showCharacterDetail(_ character: Character, referenceView: UIView) {
		let characterDetailViewModel = CharacterDetailViewModel(apiClient: apiCharacter, character: character)
		let vc = CharacterDetailC(viewModel: characterDetailViewModel, imgReferenceView: referenceView)
		vc.coordinator = self
		navigationController.present(vc, animated: true)
	}
	
	func showCharacterFilterModal(delegate: onCharacterListFilterC, withSelectedOptions: [filterType]) {
		let characterFilterViewModel = CharacterListFilterViewModel(arrayFilterOptions: withSelectedOptions)
		let vc = CharacterListFilterC(delegate: delegate, viewModel: characterFilterViewModel)
		navigationController.present(vc, animated: true)
	}
	
}
