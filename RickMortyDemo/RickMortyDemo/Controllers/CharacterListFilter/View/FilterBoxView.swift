//
//  FilterBoxView.swift
//  RickMortyDemo
//
//  Created by Sergio Rovira on 20/4/24.
//

import UIKit

import UIKit

enum filterType {
	case gender(title:String, arrayData:[Character_Gender], currentSelected:[Character_Gender])
	case status(title:String, arrayData:[Character_Status], currentSelected:[Character_Status])
	case none
}

struct filterElement {
	var object:AnyObject
	var isSelected:Bool = false
}

class FilterBoxView: UIView {
	
	//-----------------------
	// MARK: Outlets
	// MARK: ============
	//-----------------------
	
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var CS_collectionView_height: NSLayoutConstraint!
	
	//-----------------------
	// MARK: Constants
	// MARK: ============
	//-----------------------
	
	let nibName = "FilterBoxView"
	
	// flow layout to setup collectionView items
	let layoutFamily: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	
	//-----------------------
	// MARK: Variables
	// MARK: ============
	//-----------------------
	
	var contentView:UIView?
	
	/// Parent controller
	private var fromController = UIViewController()
	
	/// Type of filter that contains data to configure the view and it's content
	private var filterType:filterType!
	
	
	/// Elements to be listed on collectionView
	private var elements:[filterElement] = []
	
	//-----------------------
	// MARK: - LIVE APP
	//-----------------------
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	init() {
		super.init(frame: .zero)
		commonInit()
		
	}
	func commonInit() {
		guard let view = loadViewFromNib() else { return }
		view.frame = self.bounds
		self.addSubview(view)
		contentView = view
		
		// Configure collection view layout
		collectionView.register(UINib(nibName: "FilterBoxCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FilterBoxCollectionCell")
		layoutFamily.scrollDirection = .vertical
		layoutFamily.minimumInteritemSpacing = 8
		layoutFamily.minimumLineSpacing = 8
		layoutFamily.estimatedItemSize = .zero
		collectionView!.collectionViewLayout = layoutFamily
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.contentInset.left = 0
		collectionView.contentInset.right = 0
		collectionView.allowsMultipleSelection = true
		
		// Style --
		lblTitle.font = .retrieveCustomFont(font: .bold, size: 17.0)
		// -- Style
		
	}
	
	func loadViewFromNib() -> UIView? {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as? UIView
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutIfNeeded()
		
		// Reload layout to prevent sizing troubles
		layoutFamily.itemSize = CGSize(width: (self.collectionView.bounds.width - 8) / 2, height: 45)
		
		// Adjunt collectionView height contraint based on content
		CS_collectionView_height.constant = collectionView.contentSize.height + collectionView.contentInset.top + collectionView.contentInset.bottom
	}
	
	
	//-----------------------
	// MARK: - ACTIONS
	//-----------------------
	
	
	
	//-----------------------
	// MARK: - METHODS
	//-----------------------
	
	
	/// Configure view based on parameters
	/// - Parameters:
	///   - cont: Controller that will use the view
	///   - delegate: Delegate that will recive data collected
	///   - type: Type of filter to be desplayed with all data
	func configView(_ cont: UIViewController, type: filterType) {
		self.fromController = cont
		self.filterType = type
		
		// Clear elements (prevent reuse troubles)
		elements.removeAll()
		
		// Generate all elements that will be displayed on collectionView as option
		switch type {
			case .gender(let title, let arrayData, let currentSelected):
				lblTitle.text = title
				for datum in arrayData {
					elements.append(filterElement(object: datum as AnyObject, isSelected: currentSelected.contains(where: {($0 == datum)})))
				}
				
			case .status(let title, let arrayData, let currentSelected):
				lblTitle.text = title
				for datum in arrayData {
					elements.append(filterElement(object: datum as AnyObject, isSelected: currentSelected.contains(where: {($0 == datum)})))
					
				}
			case .none:
				break
		}
		
		collectionView.reloadData()
		self.layoutSubviews()
	}
	
	
	
	/// Get all selected data by collectionView to send
	/// - Returns: Object will all elements selected on collectionView
	func getAllSelectedObjects() -> filterType {
		var objs:[AnyObject] = []
		
		// Get indexPath selected and add the items to array
		let indexSelected = collectionView.indexPathsForSelectedItems ?? []
		for element in indexSelected {
			objs.append(elements[element.row].object)
		}
		
		// Check what kind of filter it is and fill 'currentSelected' with data
		switch filterType {
			case .gender(let title, let currentData, _):
				return .gender(title: title, arrayData: currentData, currentSelected: objs as! [Character_Gender])
			case .status(let title, let currentData, _):
				return .status(title: title, arrayData: currentData, currentSelected: objs as! [Character_Status])
			default:
				return .none
		}
	}
}

extension FilterBoxView: UICollectionViewDelegate, UICollectionViewDataSource {
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return elements.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let indentifier = "FilterBoxCollectionCell"
		var cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as? FilterBoxCollectionCell
		
		if cell == nil {
			collectionView.register(UINib.init(nibName: indentifier, bundle: nil), forCellWithReuseIdentifier: indentifier)
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as? FilterBoxCollectionCell
		}
		
		let element = elements[indexPath.row]
		
		///Configurem la cel·la segons la posició i el tipus a avaluar.
		switch filterType {
			case .gender(_, _, _):
				///Altrament configurem segons l'objecte de l'element
				if let obj = element.object as? Character_Gender {
					cell?.configCell(obj.rawValue)
				}
			case .status(_, _, _):
				///Altrament configurem segons l'objecte de l'element
				if let obj = element.object as? Character_Status {
					cell?.configCell(obj.rawValue)
				}
				
			default:
				break
		}
		
		if element.isSelected {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
		}
		
		cell?.needsUpdateConstraints()
		cell?.updateConstraintsIfNeeded()
		
		return cell!
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		for index in collectionView.indexPathsForSelectedItems ?? [] {
			collectionView.deselectItem(at: index, animated: true)
		}
		collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
		Vibration.selection.vibrate()
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		Vibration.selection.vibrate()
	}
}
