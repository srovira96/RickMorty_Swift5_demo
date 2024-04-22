//
//  DataManager.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation
import Alamofire

class DataManager {
	
	//-----------------------
	// MARK: VARIABLES
	// MARK: ============
	//-----------------------
	
	private var manager         : Session
	
	public static var shared: DataManager = {
		return DataManager.init()
	}()
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	public init() {
		manager = {
			let configuration = URLSessionConfiguration.default
			configuration.urlCache = nil
			return Alamofire.Session(configuration: configuration)
		}()
	}
	
	
	
	func getDataAPI(strAction: String, strActionWithParameters: String = "", method: HTTPMethod = .post, parameters: [String: Any]? = nil, completionHandler: @escaping (_ result: AFResult<Data>, _ method:HTTPMethod?, _ error: NSError?, _ array: [String:Any]?) -> Void) {
		
		var strUrl = "\(URL_BASE)\(strAction)"
		
		// If we got extra parameters in url mean that we must use it (composed url that contains id's...)
		if strActionWithParameters != "" {
			strUrl = "\(URL_BASE)\(strActionWithParameters)"
		}
		
		if let parameters, !parameters.isEmpty, method == .get {
			let base = NSURLComponents(string: strUrl)
			base?.queryItems = []
			for parameter in parameters {
				base?.queryItems?.append(.init(name: parameter.key, value: "\(parameter.value)"))
			}
		}
		
		manager.request(strUrl, method: method, parameters: parameters, encoding: method != .get ? JSONEncoding.default : URLEncoding.default).validate().responseData(completionHandler: { response in
			self.manageResponse(response, strAction: strAction, method: method, parameters: parameters, completionHandler: completionHandler)
		})
	}
	
	private func manageResponse(_ response: AFDataResponse<Data>, strAction: String, method:HTTPMethod = .post, parameters: [String: Any]? = nil, completionHandler: @escaping (_ result: AFResult<Data>, _ method: HTTPMethod, _ error: NSError?, _ array: [String:Any]?) -> Void) {
		var nsError: NSError
		
		if let codeError = response.response?.statusCode {
			if codeError == 401 {
				manager.cancelAllRequests()
				nsError = NSError.init(domain: "error.sessionExpired".localized(), code: 1, userInfo: nil)
				completionHandler(response.result, method, nsError, nil)
				return
			}
		}
		
		switch response.result {
			case .success(_):
				let processResult = process(data: response.data, strAction: strAction, method: method)
				completionHandler(response.result, method, nil, processResult)
				
			case .failure(let error):
				let afError = error as AFError
				print("❌❌❌❌❌ WS CALL FAILURE \(strAction) \(error.localizedDescription)")
				
				if let errorCode = afError.responseCode, (400...499).contains(errorCode) {
#if DEBUG
					nsError = NSError.init(domain: error.localizedDescription, code: errorCode, userInfo: nil)
					completionHandler(response.result, method, nsError, nil)
#else
					completionHandler(response.result,method, nil, nil)
#endif
				} else {
#if DEBUG
					print("❌❌❌❌❌❌❌❌❌❌❌❌ SERVER ERROR")
					nsError = NSError.init(domain: error.localizedDescription, code: afError.responseCode ?? 1, userInfo: nil)
					completionHandler(response.result, method, nsError, nil)
#else
					completionHandler(response.result,method, nil, nil)
#endif
					
				}
				
				
				
		}
	}
	
	func cancelTask(strAction: String) {
		let strUrl = "\(URL_BASE)\(strAction)"
		manager.session.getAllTasks { (tasks) in
			tasks.forEach({task in
				if task.currentRequest?.url?.absoluteString == strUrl {
					task.cancel()
				}
			})
		}
	}
	
}


//------------------------------
// MARK: - DataManager Extension
//------------------------------

extension DataManager {
	
	func process(data: Data?, paramsSent: [String: Any]? = nil, strAction: String, method: HTTPMethod) -> [String: Any] {
		
		switch strAction {
			case WS_CHARACTER_LIST:
				return process_WS_CHARACTER_LIST(data: data, paramsSent: paramsSent)
			case WS_CHARACTER_DETAIL:
				return process_WS_CHARACTER_DETAIL(data: data, paramsSent: paramsSent)
			default:
				print("WS not implemented in APP")
				return ["msg": "WS not implemented in APP"]
		}
	}
	
}

extension Encodable {
	var dictionary: [String: Any]? {
		guard let data = try? JSONEncoder().encode(self) else { return nil }
		return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
	}
}
