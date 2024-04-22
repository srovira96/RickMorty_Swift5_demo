//
//  Extensions.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 17/4/24.
//

import Foundation
import UIKit
import AudioToolbox

// MARK: - EXTENSION - CAGradientLayer
extension CAGradientLayer {
	convenience init(frame: CGRect, colors: [UIColor]) {
		self.init()
		self.frame = frame
		self.colors = []
		for color in colors {
			self.colors?.append(color.cgColor)
		}
		startPoint = CGPoint(x: 0, y: 1)
		endPoint = CGPoint(x: 1, y: 0)
	}
	
	/// Generate gradient UIImage based on self parameters
	/// - Returns: UIImage with gradient applied
	func creatGradientImage() -> UIImage? {
		var image: UIImage? = nil
		UIGraphicsBeginImageContext(bounds.size)
		if let context = UIGraphicsGetCurrentContext() {
			render(in: context)
			image = UIGraphicsGetImageFromCurrentImageContext()
		}
		UIGraphicsEndImageContext()
		return image
	}
}


// MARK: - UIView
extension UIView {
	
	/// Make view bounce (sacle with center point)
	func bounce() {
		let animation = CABasicAnimation(keyPath: "transform.scale")
		animation.duration = 0.3
		animation.repeatCount = 1
		animation.autoreverses = true
		animation.fromValue = 1
		animation.toValue = 0.95
		animation.timingFunction = .init(name: CAMediaTimingFunctionName.easeInEaseOut)
		self.layer.add(animation, forKey: "transform.scale")
	}
	
}

// MARK: - Vibration
enum Vibration {
	case error
	case success
	case warning
	case light
	case medium
	case heavy
	@available(iOS 13.0, *)
	case soft
	@available(iOS 13.0, *)
	case rigid
	case selection
	case oldSchool
	
	/// Generate selected vubration
	public func vibrate() {
		switch self {
			case .error:
				UINotificationFeedbackGenerator().notificationOccurred(.error)
			case .success:
				UINotificationFeedbackGenerator().notificationOccurred(.success)
			case .warning:
				UINotificationFeedbackGenerator().notificationOccurred(.warning)
			case .light:
				UIImpactFeedbackGenerator(style: .light).impactOccurred()
			case .medium:
				UIImpactFeedbackGenerator(style: .medium).impactOccurred()
			case .heavy:
				UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
			case .soft:
				UIImpactFeedbackGenerator(style: .soft).impactOccurred()
			case .rigid:
				UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
			case .selection:
				UISelectionFeedbackGenerator().selectionChanged()
			case .oldSchool:
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
		}
	}
}

// MARK: - String
extension String {
	
	/// Localize key in "Localizable" file
	/// - Returns: Return lozalized text based on self key
	func localized() -> String {
		return NSLocalizedString(self, tableName: "Localizable", value: "**\(self)**", comment: "")
	}
}

// MARK: - UIFont
extension UIFont {
	
	enum customFonts: String {
		case regular = "Montserrat-Regular"
		case medium = "Montserrat-Medium"
		case bold = "Montserrat-Bold"
		case black = "Montserrat-Black"
		case semi_bold = "Montserrat-SemiBold"
	}
	
	/// Retrieve custom fonts configured by developer
	/// - Parameters:
	///   - font: Font to be configured
	///   - size: Size to be configured
	/// - Returns: UIFont obj configured with custom font and size
	static func retrieveCustomFont(font: customFonts, size: CGFloat = 15.0) -> UIFont {
		switch font {
			case .regular:
				return UIFont.init(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
			case .medium:
				return UIFont.init(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
			case .bold:
				return UIFont.init(name: font.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
			case .black:
				return UIFont.init(name: font.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
			case .semi_bold:
				return UIFont.init(name: font.rawValue, size: size) ?? UIFont.boldSystemFont(ofSize: size)
		}
	}
}


// MARK: - PRINT OVERRIDE
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
	Swift.print(items, separator: separator, terminator: terminator)
#endif
}
