//
//  LoadingView.swift
//  veterapp
//
//  Created by Sergio Rovira on 20/04/24.
//  Copyright © 2022 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    
    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
	@IBOutlet weak var activityLoading: UIActivityIndicatorView!
	
    
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
        let nib = UINib(nibName: "LoadingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
		
		activityLoading.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------
    
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    
}
