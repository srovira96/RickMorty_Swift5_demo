//
//  CharacterListFilterViewModel.swift
//  RickMortyDemo
//
//  Created by Avantiam on 29/4/24.
//

import Foundation


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

class CharacterListFilterViewModel {
	
	/// Array of filterType that will be used to configure view content
	var arrayFilterOptions: [filterType] = []
	
	init(arrayFilterOptions: [filterType]) {
		self.arrayFilterOptions = arrayFilterOptions
	}
	
}
