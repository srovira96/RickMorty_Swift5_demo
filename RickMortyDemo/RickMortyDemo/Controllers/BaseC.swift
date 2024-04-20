//
//  BaseC.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation
import UIKit
import Alamofire

enum viewType {
	case unknown, viewContent, viewLoading, viewError, viewEmpty
}

class BaseC: UIViewController {
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Color to be configured in navigationBar
	var navBarColor: UIColor? = .COLOR_PRIMARY
	/// Color to be configured by title on navigationBar
	var titleBarColor: UIColor? = .COLOR_SECONDARY
	/// UIFont to be configured by title on nabigationBar
	var titleFont: UIFont = .retrieveCustomFont(font: .bold, size: 17.0)
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if navBarColor != nil {
			if (navBarColor == UIColor.clear) {
				let navBarAppearance = UINavigationBarAppearance()
				navBarAppearance.configureWithTransparentBackground()
				navBarAppearance.backgroundColor = .clear
				navBarAppearance.shadowColor = nil
				navBarAppearance.shadowImage = UIImage()
				navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
				self.navigationController?.navigationBar.standardAppearance = navBarAppearance
				self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
				
			} else {
				let navBarAppearance = UINavigationBarAppearance()
				navBarAppearance.configureWithOpaqueBackground()
				navBarAppearance.backgroundColor = navBarColor
				navBarAppearance.shadowColor = nil
				navBarAppearance.shadowImage = UIImage()
				navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
				self.navigationController?.navigationBar.standardAppearance = navBarAppearance
				self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
				
			}
		} else {
			var colors = [UIColor]()
			colors.append(.white)
			colors.append(.white)
			
			let gradientLayer = CAGradientLayer(frame: UIScreen.main.bounds, colors: colors)
			
			let navBarAppearance = UINavigationBarAppearance()
			navBarAppearance.configureWithOpaqueBackground()
			navBarAppearance.backgroundColor = navBarColor
			navBarAppearance.shadowColor = nil
			navBarAppearance.shadowImage = UIImage()
			navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor : titleBarColor ?? .clear]
			navBarAppearance.backgroundImage = gradientLayer.creatGradientImage()
			self.navigationController?.navigationBar.standardAppearance = navBarAppearance
			self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
			
		}
	}
	
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/// Configure back button as navigation button with "popController" action
	public func configBackButton() {
		let img = UIImage(resource: .navBack).withRenderingMode(.alwaysOriginal)
		let btn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(self.popController))
		navigationItem.leftBarButtonItem = btn
	}
	
	/// Pop controller in navigationController
	@objc func popController(){
		self.navigationController?.popViewController(animated: true)
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	/// Default process method to process WS requests
	public func processWSResponse(strAction: String, result: AFResult<Data>, method: HTTPMethod?, error: NSError?, array: [String:Any]?) {
		switch result {
			case .success:
				if error != nil {
					print("BaseC >>> processWSResponse\nWS = OK | Result = KO")
				} else {
					print("BaseC >>> processWSResponse\nWS = OK | Result = OK")
				}
			case .failure:
				print("BaseC >>> processWSResponse\nWS = KO | Result = ?")
		}
	}
	
	
}
