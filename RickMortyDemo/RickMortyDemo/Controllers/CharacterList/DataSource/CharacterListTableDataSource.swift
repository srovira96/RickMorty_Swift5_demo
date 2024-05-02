//
//  CharacterListTableDataSource.swift
//  RickMortyDemo
//
//  Created by Avantiam on 28/4/24.
//

import Foundation
import UIKit

class CharacterListTableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Array of characters to be showd by tableView
	var arrayCharacters:[Character]
	
	/// Coordinator to manage navigation
	var coordinator: CharacterCoordinator?
	
	/// Action to be formed when user reach 'arrayCharacters.count - 4'  elements
	var onBottomPaginationAction: (() -> Void)
	
	/// CharacterListTableDataSource init
	/// - Parameters:
	///   - arrayCharacters: array of characters to show
	///   - coordinator: Corrdinator to manage navigation
	///   - onBottomPaginationAction: Action performed when scroll view reach viewCells.count - 4. (Used to request new characters. Pagination)
	init(arrayCharacters: [Character], coordinator: CharacterCoordinator? = nil, onBottomPaginationAction: @escaping () -> Void) {
		self.arrayCharacters = arrayCharacters
		self.coordinator = coordinator
		self.onBottomPaginationAction = onBottomPaginationAction
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	
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
			// Apply interaction feedback
			Vibration.soft.vibrate()
			
			// Navigation through coordinator pattern
			self.coordinator?.showCharacterDetail(self.arrayCharacters[indexPath.row], referenceView: castCellView.imgCharacter)
			
		}
	}
	
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		// Make call when least 4 items will be displayed by UITableView
		if indexPath.row > arrayCharacters.count - 4 {
			self.onBottomPaginationAction()
		}
	}
	
}
