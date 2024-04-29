//
//  CharactersApiClient.swift
//  RickMortyDemo
//
//  Created by Avantiam on 28/4/24.
//

import Foundation
import Alamofire

enum CharacterAPIError: Error {
	case networkError
	case invalidResponse
	case decodingError
}




class CharactersApiClient {
	private var manager         : Session
	
	public init() {
		manager = {
			let configuration = URLSessionConfiguration.default
			configuration.urlCache = nil
			return Alamofire.Session(configuration: configuration)
		}()
	}
	
	func fetchCharacters(on page: Int64, with filterOptions:[Filter_Character_Types:Any?], completion: @escaping (Result<WS_RESP_CHARACTER_LIST, CharacterAPIError>) -> ()) {
		let url = String(format: "%@%@", URL_BASE, WS_CHARACTER_LIST)
		
		var params:[String:Any] = [:]
		
		// Page nº
		params["page"] 		= page
		
		// Filter
		for filterOption in filterOptions {
			guard let filterValue = filterOption.value else {
				continue
			}
			var values:[String] = []
			switch filterOption.key {
				case .gender:
					guard let castedValues = filterValue as? [Character_Gender] else {
						continue
					}
					values = castedValues.map({$0.rawValue})
				case .status:
					guard let castedValues = filterValue as? [Character_Status] else {
						continue
					}
					values = castedValues.map({$0.rawValue})
				case .text:
					guard let castedValue = filterValue as? String else {
						continue
					}
					if castedValue != "" {
						values = [castedValue]
					}
					
			}
			if !values.isEmpty {
				params[filterOption.key.get_ws_param()] = values.joined(separator: ",")
			}
			// -- filter
		}
		// -- end filter
		
		manager.request(url, method: .get, parameters: params, encoding: URLEncoding.default).validate().responseData { response in
			switch response.result {
				case .success(let data):
					do  {
						let wsResponse = try JSONDecoder().decode(WS_RESP_CHARACTER_LIST.self, from: data)
						completion(.success(wsResponse))
					} catch (let error) {
						print(error.localizedDescription)
						completion(.failure(.decodingError))
					}
				case .failure(let failure):
					print(failure.localizedDescription)
					if failure.responseCode == 404 {
						completion(.success(.init(info: nil, results: [])))
					} else {
						completion(.failure(.networkError))
					}
			}
		}
		
	}
	
	
	func fetchCharacterDetail(_ id: Int64, completion: @escaping(Result<Character, CharacterAPIError>) -> ()) {
		
		let partialUrl = String(format: WS_CHARACTER_DETAIL, id)
		
		let url = String(format: "%@%@", URL_BASE, partialUrl)
		
		manager.request(url, method: .get, encoding: URLEncoding.default).validate().responseData { response in
			switch response.result {
				case .success(let data):
					do  {
						let wsResponse = try JSONDecoder().decode(Character.self, from: data)
						completion(.success(wsResponse))
					} catch (let error) {
						print(error.localizedDescription)
						completion(.failure(.decodingError))
					}
				case .failure(let failure):
					print(failure.localizedDescription)
					completion(.failure(.networkError))
			}
		}
		
		
	}
}


extension CharactersApiClient {
	struct WS_RESP_CHARACTER_LIST: Codable {
		var info			: Info?
		var results		: [Character]?
		
		enum CodingKeys: CodingKey {
			case info
			case results
		}
	}
}


