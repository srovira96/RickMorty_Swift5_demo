//
//  EmptyView.swift
//  SixtemiaTest
//
//  Created by Sergio Rovira on 20/04/24.
//  Copyright © 2023 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    var controller = UIViewController()
    
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
        let nib = UINib(nibName: "EmptyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
		
		lblTitle.font = .retrieveCustomFont(font: .bold, size: 17.0)
		lblDesc.font = .retrieveCustomFont(font: .semi_bold, size: 15.0)
		
    }
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
	
	/// Configure the view
	/// - Parameters:
	///   - strTitle: Title to be showed by the view
	///   - strDesc: Description to be showed by the view
    func configView(strTitle:String = "character_list_empty_title".localized(), strDesc:String = "character_list_empty_desc".localized()) {
        lblTitle.text = strTitle
        lblDesc.text = strDesc
    }

}
