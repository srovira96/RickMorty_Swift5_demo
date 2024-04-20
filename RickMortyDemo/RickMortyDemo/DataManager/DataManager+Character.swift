//
//  DataManager+Character.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation

extension DataManager {
	
	func process_WS_CHARACTER_LIST(data: Data?, paramsSent:[String:Any]?) -> [String:Any] {
		if let data {
			do {
				let wsData = try JSONDecoder().decode(API.WS_RESP_CHARACTER_LIST.self, from: data)
				
				if let info = wsData.info, let arrayCharacters = wsData.results {
					return [
						"info": info,
						"arrayCharacters": arrayCharacters
					]
				}
				
			} catch (let error) {
				print("DECODE ERROR \(error)")
			}
		}
		return [:]
	}
	
	func process_WS_CHARACTER_DETAIL(data: Data?, paramsSent:[String:Any]?) -> [String:Any] {
		if let data {
			do {
				let wsData = try JSONDecoder().decode(Character.self, from: data)
				return ["character": wsData]
				
			} catch (let error) {
				print("DECODE ERROR \(error)")
			}
		}
		return [:]
	}
	
}
