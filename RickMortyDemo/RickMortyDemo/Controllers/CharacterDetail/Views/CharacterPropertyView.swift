//
//  CharacterPropertyView.swift
//  RickMortyDemo
//
//  Created by Avantiam on 24/4/24.
//

import UIKit

class CharacterPropertyView: UIView {

	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewCharProperty: UIView!
	@IBOutlet weak var imgChar: UIImageView!
	@IBOutlet weak var lblCharTitle: UILabel!
	@IBOutlet weak var lblCharValue: UILabel!
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	
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
		let nib = UINib(nibName: "CharacterPropertyView", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
		view.frame = bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
		
		viewCharProperty.backgroundColor = .white
		viewCharProperty.layer.cornerRadius = 12
		viewCharProperty.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharProperty.layer.shadowRadius = 4
		viewCharProperty.layer.shadowOpacity = 0.5
		viewCharProperty.layer.shadowColor = UIColor.black.cgColor
		
		lblCharTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
	}
	
}

extension CharacterPropertyView {
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	func configView(uiImage: UIImage, strTitle: String, strDesc: String) {
		imgChar.image = uiImage
		lblCharTitle.text = strTitle
		lblCharValue.text = strDesc
	}
	
}
