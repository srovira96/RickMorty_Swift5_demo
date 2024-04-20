//
//  CharacterListCell.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import UIKit
import AlamofireImage

class CharacterListCell: UITableViewCell {

	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var viewCell: UIView!
	

	@IBOutlet weak var imgCharacter: UIImageView!
	
	
	@IBOutlet weak var viewMainContent: UIView!
	
	@IBOutlet weak var lblCharacterName: UILabel!
	@IBOutlet weak var lblCharacterSpecie: UILabel!
	@IBOutlet weak var lblCharacterState: UILabel!
	
	
	@IBOutlet weak var viewNumberContent: UIView!
	@IBOutlet weak var lblCharacterNumber: UILabel!
	
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	private var character : Character!
	
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imgCharacter.image = UIImage(resource: .imgPlaceholder)
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		lblCharacterName.font = .retrieveCustomFont(font: .black, size: 18.0)
		lblCharacterSpecie.font = .retrieveCustomFont(font: .regular, size: 13.0)
		lblCharacterState.font = .retrieveCustomFont(font: .bold, size: 15.0)
		lblCharacterNumber.font = .retrieveCustomFont(font: .black, size: 17.0)
		
		viewCell.layer.cornerRadius = 12
		viewCell.layer.shadowOpacity = 0.3
		viewCell.layer.shadowRadius = 3
		viewCell.layer.shadowColor = UIColor.black.cgColor
		viewCell.layer.shadowOffset = .init(width: 0, height: 0)
		
		viewMainContent.layer.cornerRadius = 12
		viewMainContent.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
		viewMainContent.layer.masksToBounds = true
		
		imgCharacter.layer.cornerRadius = 12
		imgCharacter.layer.masksToBounds = true
		imgCharacter.backgroundColor = .white
		
		viewNumberContent.layer.mask = generateNumberMask(viewNumberContent.frame)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/// Method used to configure cell content
	/// - Parameter character: Character obj that contains all data to be showed by cell
	func configCell(_ character: Character) {
		self.character = character
		
		// Config str data
		lblCharacterName.text = character.name
		lblCharacterNumber.text = String(format: "#%d", character.id)
		lblCharacterState.text = character.status.rawValue
		lblCharacterSpecie.text = character.species
		
		// Configure 'State' color
		lblCharacterState.textColor = character.status.getStatusColor()
		
		// Configure image
		if let strUrlImg = character.image, let url = URL(string: strUrlImg) {
			imgCharacter.af.setImage(withURL: url, placeholderImage: UIImage(resource: .imgPlaceholder), imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)
		}
		
	}
	
	
	/// Method that generate shape to be used on 'viewNumberContent'
	/// - Parameter cgRect: Reference frame
	/// - Returns: Shape to be applied on layer > mask
	func generateNumberMask(_ cgRect: CGRect) -> CAShapeLayer {
		let width = cgRect.width
		let height = cgRect.height
		
		// Generate path
		let path = UIBezierPath(rect: cgRect)
		path.move(to: .init(x: 0, y: height + 1))
		path.addCurve(to: .init(x: 50, y: 0), controlPoint1: .init(x: 25, y: height), controlPoint2: .init(x: 15, y: 0))
		path.addLine(to: .init(x: width - 10, y: 0))
		path.addQuadCurve(to: .init(x: width, y: 10), controlPoint: .init(x: width, y: 0))
		path.addLine(to: .init(x: width, y: height + 1))
		path.close()
		
		let layer = CAShapeLayer()
		layer.path = path.cgPath
		return layer
		
	}
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
    
}

