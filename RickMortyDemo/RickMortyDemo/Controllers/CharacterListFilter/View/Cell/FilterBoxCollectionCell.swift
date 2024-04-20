//
//  FilterBoxView.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 20/4/24.
//

import UIKit

class FilterBoxCollectionCell: UICollectionViewCell {

    //-----------------------
    // MARK: Outlets
    // MARK: ============
    //-----------------------
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
	/// Override selected state to apply custom design
    override var isSelected: Bool {
        didSet {
            if isSelected {
				viewCell.backgroundColor = .COLOR_PRIMARY
                lblTitle.textColor = .COLOR_SECONDARY
                
            } else {
				viewCell.backgroundColor = .COLOR_CELL_BACKGORUND
				lblTitle.textColor = .COLOR_SECONDARY
            }
        }
    }
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
		
		// Style --
		viewCell.layer.cornerRadius = 12
		lblTitle.font = .retrieveCustomFont(font: .semi_bold, size: 15.0)
		// -- style
		
    }
    
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
	
	/// Configure view with parameters content
	/// - Parameter strTitle: Title to be displayed by cell
    func configCell(_ strTitle: String) {
        lblTitle.text = strTitle
    }
    
    //-----------------------
    // MARK: - ACTIONS
    //-----------------------

}
