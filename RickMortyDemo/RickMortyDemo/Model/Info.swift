//
//  Info.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation

struct Info: Codable {
	var count			: Int64?
	var pages			: Int64?
	var next				: String?
	var prev				: String?
	
	enum CodingKeys: CodingKey {
		case count
		case pages
		case next
		case prev
	}
	
}
