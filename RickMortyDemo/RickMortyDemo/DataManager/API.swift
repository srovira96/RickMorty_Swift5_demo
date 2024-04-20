//
//  API.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation

import Foundation
import Alamofire


class API: NSObject {
	
	internal var params:[String:Any] = [:]
	
	///Singelton variable
	public static var shared: API = {
		return API()
	}()
	
	
	func get_characterList(page: Int64, filterOptions:[Filter_Character_Types:Any],  completion: @escaping (_ result: AFResult<Data>, _ method: HTTPMethod?, _ error: NSError?, _ array:[String:Any]?) -> Void) {
		params = [:]
		
		params["page"] 		= page
		
		for filterOption in filterOptions {
			var values:[String] = []
			switch filterOption.key {
				case .gender:
					values = (filterOption.value as? [Character_Gender] ?? []).map({$0.rawValue})
				case .status:
					values = (filterOption.value as? [Character_Status] ?? []).map({$0.rawValue})
				case .text:
					if let value = filterOption.value as? String, value != "" {
						values = [value]
					}
					
			}
			if !values.isEmpty {
				params[filterOption.key.get_ws_param()] = values.joined(separator: ",")
			}
		}
		
		/*for filterOption in filterOptions {
			params[filterOption.get_ws_param()] = filterOption.getValue()
		}
		*/
		DataManager.shared.getDataAPI(strAction: WS_CHARACTER_LIST, method: .get, parameters: params) { result, method, error, array in
			completion(result, method, error, array)
		}
		
	}
	
	func get_characterDetail(characterId: Int64, completion: @escaping (_ result: AFResult<Data>, _ method: HTTPMethod?, _ error: NSError?, _ array:[String:Any]?) -> Void) {
		params = [:]
		
		let composedUrl = String(format: WS_CHARACTER_DETAIL, characterId)
		
		DataManager.shared.getDataAPI(strAction: WS_CHARACTER_DETAIL, strActionWithParameters: composedUrl, method: .get, parameters: params) { result, method, error, array in
			completion(result, method, error, array)
		}
		
	}
	
}
