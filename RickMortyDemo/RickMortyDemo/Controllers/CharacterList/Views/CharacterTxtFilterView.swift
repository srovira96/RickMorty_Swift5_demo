//
//  CharacterTxtFilterView.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 20/4/24.
//

import UIKit

protocol onCharacterTxtFilterView {
	func didChangeSearchValue(_ value: String?)
}

class CharacterTxtFilterView: UIView {

	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var txtSearch: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Delegate configured on view
	private var delegate : onCharacterTxtFilterView!
	
	/// Timer used to add delay between onCharacterTxtFilterView > didChangeSearchValue
	private var sendTimer:Timer? = nil
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadViewFromNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadViewFromNib()
	}
	
	func loadViewFromNib() {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "CharacterTxtFilterView", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
		
		// Set font
		txtSearch.font = .retrieveCustomFont(font: .semi_bold, size: 15.0)
		
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	public func configView(_ delegate: onCharacterTxtFilterView) {
		self.delegate = delegate
		
		// Setup UITextField delegate and 'didChange' action
		txtSearch.delegate = self
		txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

		viewContent.layer.cornerRadius = 12
		viewContent.layer.shadowOffset = .init(width: 0, height: 0)
		viewContent.layer.shadowOpacity = 0.5
		viewContent.layer.shadowColor = UIColor.black.cgColor
		viewContent.layer.shadowRadius = 4
		txtSearch.autocorrectionType = .no
	}
	
	/// Method that stops loading indicator. Indicator will hide.
	public func stopLoadingAnimator() {
		self.activityIndicator.stopAnimating()
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	/// Method called when TextField content changes
	@objc func textFieldDidChange(_ textField: UITextField) {
		self.sendTimer?.invalidate()
		self.sendTimer = nil
		if let value = textField.text, value != "" {
			activityIndicator.startAnimating()
		}
		// Configure timer to set 1s delay before send it to delegate. Used to prevent too many calls when user is writing
		sendTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
			self.delegate.didChangeSearchValue(textField.text)
		})
	}
	
}

extension CharacterTxtFilterView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		// Hide keyboard when user press enter
		endEditing(true)
	}
}
