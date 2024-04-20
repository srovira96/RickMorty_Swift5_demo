//
//  CharacterDetailC.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import UIKit
import Alamofire

class CharacterDetailC: BaseC {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	
	// Background
	@IBOutlet weak var viewBackground: UIView!
	
	// General
	@IBOutlet weak var viewContent: UIView!
	@IBOutlet weak var stackInformation: UIStackView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var btnClose: UIButton!
	
	
	// Character name - profile image block
	@IBOutlet weak var lblCharacterName: UILabel!
	@IBOutlet weak var imgCharacter: UIImageView!
	@IBOutlet weak var viewImgDestination: UIView!
	
	// Character state block
	@IBOutlet weak var viewCharState: UIView!
	@IBOutlet weak var imgCharState: UIImageView!
	@IBOutlet weak var lblCharStateTitle: UILabel!
	@IBOutlet weak var lblCharStateValue: UILabel!
	
	// Character gender block
	@IBOutlet weak var viewCharGender: UIView!
	@IBOutlet weak var imgCharGender: UIImageView!
	@IBOutlet weak var lblCharGenderTitle: UILabel!
	@IBOutlet weak var lblCharGenderValue: UILabel!
	
	// Character specie block
	@IBOutlet weak var viewCharSpecie: UIView!
	@IBOutlet weak var imgCharSpecie: UIImageView!
	@IBOutlet weak var lblCharSpecieTitle: UILabel!
	@IBOutlet weak var lblCharSpecieValue: UILabel!
	
	// Character type block
	@IBOutlet weak var viewCharType: UIView!
	@IBOutlet weak var imgCharType: UIImageView!
	@IBOutlet weak var lblCharTypeTitle: UILabel!
	@IBOutlet weak var lblCharTypeValue: UILabel!
	
	// Character origin block
	@IBOutlet weak var viewCharOrigin: UIView!
	@IBOutlet weak var imgCharOrigin: UIImageView!
	@IBOutlet weak var lblCharOriginTitle: UILabel!
	@IBOutlet weak var lblCharOriginValue: UILabel!
	
	// Character location block
	@IBOutlet weak var viewCharLocation: UIView!
	@IBOutlet weak var imgCharLocation: UIImageView!
	@IBOutlet weak var lblCharLocationTitle: UILabel!
	@IBOutlet weak var lblCharLocationValue: UILabel!
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Boolean used on scrollDelegate methods to control and sync animations
	var isDismissing:Bool = false
	
	/// ReferenceView where snapshoot will be placed for starting animation
	private var imgReferenceView:UIView!
	
	
	
	/// Character model data used in view
	private var character:Character! {
		didSet {
			configView()
		}
	}
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(character: Character!, imgReferenceView: UIView) {
		super.init(nibName: "CharacterDetailC", bundle: .main)
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		self.character = character
		self.imgReferenceView = imgReferenceView
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = String(format: "#%d", character.id)
		configBackButton()
		
		// DELEGATES --
		scrollView.delegate = self
		// END DELEGATES
		
		// STYLE --
		viewBackground.layer.cornerRadius = 20
		viewBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		imgCharacter.layer.cornerRadius = 12
		
		viewImgDestination.layer.cornerRadius = 12
		viewImgDestination.layer.shadowColor = UIColor.black.cgColor
		viewImgDestination.layer.shadowOpacity = 0.5
		viewImgDestination.layer.shadowOffset = .init(width: 0, height: 0)
		viewImgDestination.layer.borderColor = UIColor.white.cgColor
		viewImgDestination.layer.borderWidth = 2
		
		viewCharState.backgroundColor = .white
		viewCharState.layer.cornerRadius = 12
		viewCharState.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharState.layer.shadowRadius = 4
		viewCharState.layer.shadowOpacity = 0.5
		viewCharState.layer.shadowColor = UIColor.black.cgColor
		
		viewCharGender.backgroundColor = .white
		viewCharGender.layer.cornerRadius = 12
		viewCharGender.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharGender.layer.shadowRadius = 4
		viewCharGender.layer.shadowOpacity = 0.5
		viewCharGender.layer.shadowColor = UIColor.black.cgColor
		
		viewCharSpecie.backgroundColor = .white
		viewCharSpecie.layer.cornerRadius = 12
		viewCharSpecie.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharSpecie.layer.shadowRadius = 4
		viewCharSpecie.layer.shadowOpacity = 0.5
		viewCharSpecie.layer.shadowColor = UIColor.black.cgColor
		
		viewCharType.backgroundColor = .white
		viewCharType.layer.cornerRadius = 12
		viewCharType.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharType.layer.shadowRadius = 4
		viewCharType.layer.shadowOpacity = 0.5
		viewCharType.layer.shadowColor = UIColor.black.cgColor
		
		viewCharOrigin.backgroundColor = .white
		viewCharOrigin.layer.cornerRadius = 12
		viewCharOrigin.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharOrigin.layer.shadowRadius = 4
		viewCharOrigin.layer.shadowOpacity = 0.5
		viewCharOrigin.layer.shadowColor = UIColor.black.cgColor
		
		viewCharLocation.backgroundColor = .white
		viewCharLocation.layer.cornerRadius = 12
		viewCharLocation.layer.shadowOffset = .init(width: 0, height: 0)
		viewCharLocation.layer.shadowRadius = 4
		viewCharLocation.layer.shadowOpacity = 0.5
		viewCharLocation.layer.shadowColor = UIColor.black.cgColor
		
		btnClose.layer.cornerRadius = 12
		btnClose.layer.shadowOffset = .init(width: 0, height: 0)
		btnClose.layer.shadowRadius = 4
		btnClose.layer.shadowOpacity = 0.5
		btnClose.layer.shadowColor = UIColor.black.cgColor
		btnClose.backgroundColor = .COLOR_PRIMARY
		btnClose.tintColor = .COLOR_SECONDARY
		btnClose.setImage(UIImage.init(resource: .iconClose).withTintColor(.COLOR_SECONDARY), for: .normal)
		btnClose.setTitle("btn_close".localized(), for: .normal)
		
		lblCharStateTitle.text = "character_status".localized()
		lblCharGenderTitle.text = "character_gender".localized()
		lblCharSpecieTitle.text = "character_specie".localized()
		lblCharTypeTitle.text = "character_type".localized()
		lblCharLocationTitle.text = "character_currentLocation".localized()
		lblCharOriginTitle.text = "character_origin".localized()
		
		     // LBL FONT SETUP
		lblCharacterName.font = UIFont.retrieveCustomFont(font: .black, size: 25.0)
		
		btnClose.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		
		lblCharStateTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharGenderTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharSpecieTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharTypeTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharLocationTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		lblCharOriginTitle.font = UIFont.retrieveCustomFont(font: .semi_bold, size: 15.0)
		
		lblCharStateValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		lblCharGenderValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		lblCharSpecieValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		lblCharTypeValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		lblCharLocationValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		lblCharOriginValue.font = UIFont.retrieveCustomFont(font: .bold, size: 15.0)
		// --- END STYLE
		
		
		// CONFIG CHARACTER BASED CONTENT
		configView()
		// END CONFIG CONTENT
		
		// VIEW ANIMATION BEGIN STATE
		viewImgDestination.alpha = 0
		imgCharacter.alpha = 0
		
		viewBackground.transform = CGAffineTransform(translationX: 0, y: 50)
		viewBackground.alpha = 0
		btnClose.transform = CGAffineTransform(translationX: 0, y: 50)
		btnClose.alpha = 0
		
		stackInformation.alpha = 0
		stackInformation.transform = .init(translationX: 0, y: 50)
		// END ANIMATION BEGIN STATE
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		ws_get_characterDetail()
		
		// SETUP ANIMATIONS
		UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
			self.view.backgroundColor = .black.withAlphaComponent(0.5)
		})
		
		runImageAnimation()
		
		UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
			self.viewBackground.alpha = 1
			self.viewBackground.transform = .identity
			self.btnClose.alpha = 1
			self.btnClose.transform = .identity
		})
		
		UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
			self.stackInformation.transform = .identity
			self.stackInformation.alpha = 1
		})
		// END SETUP ANIMATIONS
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//runAnimationSetup()
	}
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/// API - WS used to get an specific character data
	fileprivate func ws_get_characterDetail() {
		API.shared.get_characterDetail(characterId: self.character.id) { result, method, error, array in
			self.processWSResponse(strAction: WS_CHARACTER_DETAIL, result: result, method: method, error: error, array: array)
		}
	}
	
	
	/// Dismiss animation procedure with multiple sync effects
	fileprivate func dismissAnimation() {
		Vibration.rigid.vibrate()
		// Dismiss animation
		UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowAnimatedContent], animations: {
			self.viewBackground.transform = .init(translationX: 0, y: (self.scrollView.contentOffset.y * -1) + 100)
			self.viewContent.transform = .init(translationX: 0, y:  (self.scrollView.contentOffset.y * -1) + 100)
			self.viewContent.alpha = 0
			self.viewBackground.alpha = 0
			self.btnClose.alpha = 0
		}) { _ in
			self.dismiss(animated: true)
		}
	}
	
	
	/// Function used to generate and animate image from init position to final position
	fileprivate func runImageAnimation() {
		
		//Get screen references to calculate coord system from referenceView on screen
		let appDelegate  = UIApplication.shared.delegate as! AppDelegate
		let viewController = appDelegate.window!.rootViewController
		let transitionFrameOrigin = imgReferenceView.convert(imgReferenceView.bounds, to: viewController!.view)
		
		// Create UIImageView that will be animated from 'imgReferenceView' to 'imgCharacter' final position
		let imgCharacterSnapshot = UIImageView()
		imgCharacterSnapshot.image = imgCharacter.image
		imgCharacterSnapshot.layer.cornerRadius = 12
		imgCharacterSnapshot.layer.masksToBounds = true
		view.addSubview(imgCharacterSnapshot)
		imgCharacterSnapshot.translatesAutoresizingMaskIntoConstraints = true
		imgCharacterSnapshot.frame = transitionFrameOrigin
		
		// Set animation for snapshoot view
		let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
			imgCharacterSnapshot.frame = self.imgCharacter.convert(self.imgCharacter.bounds, to: viewController!.view)
		}
		
		// Completion block executed when animation finishes
		animator.addCompletion { _ in
			UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
				self.viewImgDestination.alpha = 1
			})
			self.imgCharacter.alpha = 1
			imgCharacterSnapshot.removeFromSuperview()
		}
		
		// Start animation
		animator.startAnimation(afterDelay: 0)
	}
	
	/// Configure view content
	fileprivate func configView() {
		lblCharacterName.text = character.name
		lblCharStateValue.text = character.status.rawValue
		lblCharGenderValue.text = character.gender.rawValue
		lblCharSpecieValue.text = character.species
		lblCharTypeValue.text = character.type == "" ? "??" : character.type
		lblCharLocationValue.text = character.location?.name
		lblCharOriginValue.text = character.origin?.name
		
		imgCharGender.image = character.gender.getGenderIcon()
		imgCharState.image = character.status.getStatusIcon()
		lblCharStateValue.textColor = character.status.getStatusColor()
		
		if let strUrl = character.image, let url = URL(string: strUrl) {
			imgCharacter.af.setImage(withURL: url, placeholderImage: UIImage.init(resource: .imgPlaceholder), imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)
		} else {
			imgCharacter.image = UIImage.init(resource: .imgPlaceholder)
			
		}
	}
	
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	/// Dismiss  action performed by UIButton
	@IBAction func btnCloseAction(_ sender: UIButton) {
		dismissAnimation()
	}
	
	
	
	//-----------------------
	// MARK: - DATAMANAGER
	//-----------------------
	
	
	override func processWSResponse(strAction: String, result: AFResult<Data>, method: HTTPMethod?, error: NSError?, array: [String:Any]?) {
		switch result {
			case .success:
				if error != nil {
					print("BaseC >>> processWSResponse\nWS = OK | Result = KO")
				} else {
					print("BaseC >>> processWSResponse\nWS = OK | Result = OK")
					
					if let fetchedCharacter = array?["character"] as? Character {
						self.character = fetchedCharacter
					}
				}
			case .failure:
				print("BaseC >>> processWSResponse\nWS = KO | Result = ?")
		}
	}
	
	
}


// MARK: - UIScrollViewDelegate
extension CharacterDetailC: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y < 0 && !isDismissing {
			viewBackground.transform = CGAffineTransform(translationX: 0, y: (scrollView.contentOffset.y) * -1)
		}
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		// Set content offset combined with velocity to dismiss the view
		if scrollView.contentOffset.y < 0 && velocity.y < -1.5 {
			// Starts dismissing
			isDismissing = true
			dismissAnimation()
		}
	}
}
