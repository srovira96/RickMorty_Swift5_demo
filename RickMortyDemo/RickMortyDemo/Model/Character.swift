//
//  Character.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation
import UIKit

enum Character_Status: String, Codable, CaseIterable {
	case alive = "Alive"
	case death = "Dead"
	case unknown = "Unknown"
	
	static func ws_key_conversion(_ value: String) -> Character_Status {
		switch value.uppercased() {
			case "ALIVE":
				return .alive
			case "DEAD":
				return .death
			default:
				return .unknown
		}
	}
	
	func getStatusColor() -> UIColor {
		switch self {
			case .alive:
				return UIColor.COLOR_CHARACTER_ALIVE
			case .death:
				return UIColor.COLOR_CHARACTER_DEATH
			case .unknown:
				return UIColor.COLOR_CHARACTER_UNKNOWN
		}
	}
	
	func getStatusIcon() -> UIImage {
		switch self {
			case .alive:
				return UIImage(resource: .iconAlive)
			case .death:
				return UIImage(resource: .iconDeath)
			case .unknown:
				return UIImage(resource: .iconQuestion)
		}
	}
}


enum Character_Gender: String, Codable, CaseIterable {
	case male = "Male"
	case female = "Female"
	case genderless = "Genderless"
	case unknown = "Unknown"
	
	static func ws_key_conversion(_ value: String) -> Character_Gender {
		switch value.uppercased() {
			case "MALE":
				return .male
			case "FEMALE":
				return .female
			case "GENDERLESS":
				return .genderless
			default:
				return .unknown
		}
	}
	
	func getGenderIcon() -> UIImage {
		switch self {
			case .male:
				return UIImage(resource: .iconMale)
			case .female:
				return UIImage(resource: .iconFemale)
			case .genderless:
				return UIImage(resource: .iconeGenderless)
			case .unknown:
				return UIImage(resource: .iconQuestion)
		}
	}
	
}

struct Character: Codable, Identifiable {
	var id				: Int64 = 0
	var name				: String
	var gender			: Character_Gender = .unknown
	var status			: Character_Status = .unknown
	var species			: String
	var type				: String
	var origin			: Location?
	var location			: Location?
	var image			: String?
	
	enum CodingKeys: CodingKey {
		case id
		case name
		case gender
		case status
		case origin
		case location
		case image
		case species
		case type
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int64.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		
		//Decode 'Gender' value and assign correct value type or .unknown
		if let value = try? container.decodeIfPresent(String.self, forKey: .gender) {
			self.gender = Character_Gender.ws_key_conversion(value)
		} else {
			self.gender = .unknown
		}
		
		//Decode 'Status' value and assign correct value type or .unknown
		if let value = try? container.decodeIfPresent(String.self, forKey: .status) {
			self.status = Character_Status.ws_key_conversion(value)
		} else {
			self.status = .unknown
		}
		
		self.origin = try container.decodeIfPresent(Location.self, forKey: .origin)
		self.location = try container.decodeIfPresent(Location.self, forKey: .location)
		self.image = try container.decodeIfPresent(String.self, forKey: .image)
		self.species = try container.decode(String.self, forKey: .species)
		self.type = try container.decode(String.self, forKey: .type)
	}
	
}


