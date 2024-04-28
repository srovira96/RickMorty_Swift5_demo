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
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let characterViewModel = CharacterListViewModel(apiClient: .init())
		let vc = CharacterListC(characterListViewModel: characterViewModel)
		vc.coordinator = self
		navigationController.viewControllers = [vc]
	}
	
	func showCharacterDetail(_ character: Character, referenceView: UIView) {
		let vc = CharacterDetailC(character: character, imgReferenceView: referenceView)
		vc.coordinator = self
		navigationController.present(vc, animated: true)
	}
	
}
