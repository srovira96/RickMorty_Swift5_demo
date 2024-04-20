//
//  ErrorView.swift
//  veterapp
//
//  Created by Sergio Rovira on 20/04/24.
//  Copyright © 2022 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

typealias ErrorViewAction = () -> Void


class ErrorView: UIView {

    
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    
    
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
	// Controller that will use the view
    var controller = UIViewController()
	
	// Action to be performed by view with 'btnRetry'
    var errorAction:ErrorViewAction? = nil
    
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
        let nib = UINib(nibName: "ErrorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
		// Style --
		lblTitle.font = .retrieveCustomFont(font: .bold, size: 17.0)
		lblDesc.font = .retrieveCustomFont(font: .semi_bold, size: 15.0)
		btnRetry.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		btnRetry.layer.cornerRadius = 12
		// -- style
		
		// localized --
        lblTitle.text = "general_error_title".localized()
        lblDesc.text = "general_error_desc".localized()
        btnRetry.setTitle("btn_retry".localized(), for: .normal)
		// -- localized
        
    }
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
	
	/// ACTION - Try again action
    @IBAction func btnTryAgainAction(_ sender: Any) {
        errorAction!()
    }
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
	
	/// Configures the view
	/// - Parameters:
	///   - cont: controller that will use the view
	///   - action: Action to be performed to retry fetch data
    func configView(_ cont: UIViewController, action: @escaping ErrorViewAction) {
        self.controller = cont
        self.errorAction = action
    }
    

}
