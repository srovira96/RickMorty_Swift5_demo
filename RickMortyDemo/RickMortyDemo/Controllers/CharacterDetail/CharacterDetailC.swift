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
	
	// Character info block
	@IBOutlet weak var viewCharState: CharacterPropertyView!
	@IBOutlet weak var viewCharGender: CharacterPropertyView!
	@IBOutlet weak var viewCharSpecie: CharacterPropertyView!
	@IBOutlet weak var viewCharType: CharacterPropertyView!
	@IBOutlet weak var viewCharOrigin: CharacterPropertyView!
	@IBOutlet weak var viewCharLocation: CharacterPropertyView!
	
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	/// Coordinator to manage navigation
	var coordinator: CharacterCoordinator?
	
	/// View model
	var viewModel : CharacterDetailViewModel!
	
	/// Boolean used on scrollDelegate methods to control and sync animations
	var isDismissing:Bool = false
	
	/// ReferenceView where snapshoot will be placed for starting animation
	private var imgReferenceView:UIView!
	
	
	
	/// Character model data used in view
	//private var character:Character!
	
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	init(viewModel: CharacterDetailViewModel , imgReferenceView: UIView) {
		super.init(nibName: "CharacterDetailC", bundle: .main)
		self.modalPresentationStyle = .overCurrentContext
		self.modalTransitionStyle = .crossDissolve
		self.viewModel = viewModel
		self.imgReferenceView = imgReferenceView
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//ws_get_characterDetail()
		
		viewModel.delegate = self
		viewModel.fetchCharacterDetail()
		
		print("SET BEGIN")
		// VIEW ANIMATION BEGIN STATE
		viewImgDestination.alpha = 0
		imgCharacter.alpha = 0
		
		viewBackground.transform = CGAffineTransform(translationX: 0, y: 50)
		viewBackground.alpha = 0
		btnClose.transform = CGAffineTransform(translationX: 0, y: 50)
		btnClose.alpha = 0
		
		stackInformation.alpha = 0
		stackInformation.transform = .init(translationX: 0, y: 50)
		print("END")
		// END ANIMATION BEGIN STATE
		
		setupView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// SETUP ANIMATIONS
		UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
			self.view.backgroundColor = .black.withAlphaComponent(0.5)
		})
		// END SETUP ANIMATIONS
		
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


// Methods and actions
extension CharacterDetailC {
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	/// Configure view content
	private func setupView() {
		self.title = String(format: "#%d", viewModel.character.id)
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
		
		btnClose.layer.cornerRadius = 12
		btnClose.layer.shadowOffset = .init(width: 0, height: 0)
		btnClose.layer.shadowRadius = 4
		btnClose.layer.shadowOpacity = 0.5
		btnClose.layer.shadowColor = UIColor.black.cgColor
		btnClose.backgroundColor = .COLOR_PRIMARY
		btnClose.tintColor = .COLOR_SECONDARY
		btnClose.setImage(UIImage.init(resource: .iconClose).withTintColor(.COLOR_SECONDARY), for: .normal)
		btnClose.setTitle("btn_close".localized(), for: .normal)
		
		// LBL FONT SETUP
		lblCharacterName.font = UIFont.retrieveCustomFont(font: .black, size: 25.0)
		btnClose.titleLabel?.font = .retrieveCustomFont(font: .bold, size: 15.0)
		// --- END STYLE
		
		
		// Content configuration
		lblCharacterName.text = viewModel.character.name
		
		viewCharState.configView(uiImage: viewModel.character.status.getStatusIcon(), strTitle: "character_status".localized(), strDesc: viewModel.character.status.rawValue)
		
		viewCharGender.configView(uiImage: viewModel.character.gender.getGenderIcon(), strTitle: "character_gender".localized(), strDesc: viewModel.character.gender.rawValue)
		
		viewCharSpecie.configView(uiImage: UIImage(resource: .iconDna), strTitle: "character_specie".localized(), strDesc: viewModel.character.species)
		
		viewCharType.configView(uiImage: UIImage(resource: .iconType), strTitle: "character_type".localized(), strDesc: viewModel.character.type == "" ? "??" : viewModel.character.type)
		
		if let location = viewModel.character.location, let locationName = location.name {
			viewCharOrigin.configView(uiImage: UIImage(resource: .iconLocation), strTitle: "character_currentLocation".localized(), strDesc: locationName)
		} else {
			viewCharOrigin.isHidden = true
		}
		
		if let origin = viewModel.character.origin, let originName = origin.name {
			viewCharLocation.configView(uiImage: UIImage(resource: .iconLocation), strTitle: "character_origin".localized(), strDesc: originName)
		} else {
			viewCharLocation.isHidden = true
		}
		
		if let strUrl = viewModel.character.image, let url = URL(string: strUrl) {
			imgCharacter.af.setImage(withURL: url, placeholderImage: UIImage.init(resource: .imgPlaceholder), imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)
		} else {
			imgCharacter.image = UIImage.init(resource: .imgPlaceholder)
			
		}
		// -- end content configuration
		
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
		})
		self.dismiss(animated: true)
	}
	
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	/// Dismiss  action performed by UIButton
	@IBAction func btnCloseAction(_ sender: UIButton) {
		dismissAnimation()
	}
	
	
}

extension CharacterDetailC: onCharacterDetailViewModel {
	func onModelUpdated() {
		setupView()
	}
	
	func onError() {
		// No actions performed
	}
}
