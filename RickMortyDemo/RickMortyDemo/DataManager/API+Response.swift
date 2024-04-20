//
//  API+Response.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation



extension API {
	
	struct WS_RESP_CHARACTER_LIST: Codable {
		var info			: Info?
		var results		: [Character]?
		
		enum CodingKeys: CodingKey {
			case info
			case results
		}
	}
	
	struct WS_RESP_CHARACTER_DETAIL: Codable {
		var message: String = ""
		
		public enum CodingKeys: CodingKey {
			case message
		}
	}
	
}
