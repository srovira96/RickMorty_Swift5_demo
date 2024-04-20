//
//  CharacterOrigin.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation

struct Location: Codable {
	var name			: String?
	
	enum CodingKeys: CodingKey {
		case name
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
	}
}
