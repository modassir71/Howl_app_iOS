
//  SwitchSliderAnimation.swift
//  VivoCabsDriver
//
//  Created by FatbitDeveloper on 09/12/21.
//

import Foundation

var startRide : Bool?
public protocol DSSliderDelegate: AnyObject {
  func sliderDidFinishSliding(_ slider: DSSlider, at position: DSSliderPosition)
}

import UIKit

// MARK: DSSlider

public class DSSlider: UIView {

  // MARK: Public Properties

  // MARK: Views

  public let sliderView = UIView()
  public let sliderBackgroundView = UIView()
  public let sliderBackgroundViewTextLabel = UILabel()
  public let sliderDraggedView = UIView()
  public let sliderDraggedViewTextLabel = UILabel()
  public let sliderImageView = DSRoundImageView()
  public var isUserLogin: Bool = false
  public var isdisabled: Bool = true

  public var comeFromStartRide: String = ""

  // MARK: Delegate

  public weak var delegate: DSSliderDelegate?

  // MARK: Flags

  public var isDoubleSideEnabled: Bool = true
  public var isImageViewRotating: Bool = true
  public var isTextChangeAnimating: Bool = true
  public var isDebugPrintEnabled: Bool = false
 

  public var isShowSliderText: Bool = true {
    didSet {
      sliderDraggedViewTextLabel.isHidden = !isShowSliderText
    }
  }

  public var isEnabled: Bool = true {
    didSet {
      animationChangedEnabledBlock?(isEnabled)
    }
  }

  // MARK: Parameters

  public var sliderAnimationVelocity: Double = 0.2

  public var sliderViewTopDistance: CGFloat = 0.0 {
    didSet {
      topSliderConstraint?.constant = sliderViewTopDistance
      layoutIfNeeded()
    }
  }

  public var sliderImageViewTopDistance: CGFloat = 0.0 {
    didSet {
      topImageViewConstraint?.constant = sliderImageViewTopDistance
      sliderImageViewStartingDistance = sliderImageViewTopDistance
      layoutIfNeeded()
    }
  }

  public var sliderImageViewStartingDistance: CGFloat = 0.0 {
      
    didSet {
        let viewwidth = sliderView.frame.width
        let constant = viewwidth - 50.0
        leadingImageViewConstraint?.constant = startRide ?? false ? constant :  5.0
        sliderPosition = startRide ?? false ? .rigth : .left
        let angle =   startRide ?? false ? 3.0 : 0.0
            updateImageView(withAngle: CGFloat(angle))
          trailingDraggedViewConstraint?.constant = sliderImageViewStartingDistance
      setNeedsLayout()
    }
  }

  public var sliderTextLabelLeadingDistance: CGFloat = 0 {
    didSet {
      leadingTextLabelConstraint?.constant = sliderTextLabelLeadingDistance
      setNeedsLayout()
    }
  }

  public var sliderCornerRadius: CGFloat = 30.0 {
    didSet {
      sliderBackgroundView.layer.cornerRadius = sliderCornerRadius
      sliderDraggedView.layer.cornerRadius = sliderCornerRadius
    }
  }

  // MARK: Colors

  public var sliderBackgroundColor: UIColor = UIColor.white {
    didSet {
      sliderBackgroundView.backgroundColor = sliderBackgroundColor
      sliderDraggedViewTextLabel.textColor = sliderBackgroundColor
    }
  }

  public var sliderBackgroundViewTextColor: UIColor = UIColor.dsSliderRedColor {
    didSet {
      sliderBackgroundViewTextLabel.textColor = sliderBackgroundViewTextColor
    }
  }

  public var sliderDraggedViewTextColor: UIColor = UIColor.dsSliderRedColor {
    didSet {
      sliderDraggedViewTextLabel.textColor = sliderDraggedViewTextColor
    }
  }

  public var sliderDraggedViewBackgroundColor: UIColor = UIColor.white {
    didSet {
      sliderDraggedView.backgroundColor = sliderDraggedViewBackgroundColor
    }
  }

  public var sliderImageViewBackgroundColor: UIColor = UIColor.dsSliderRedColor {
    didSet {
      sliderImageView.backgroundColor = sliderImageViewBackgroundColor
    }
  }

  // MARK: Font

  public var sliderTextFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
    didSet {
      sliderBackgroundViewTextLabel.font = sliderTextFont
      sliderDraggedViewTextLabel.font = sliderTextFont
    }
  }

  // MARK: Private Properties

    var leadingImageViewConstraint: NSLayoutConstraint?
  private var leadingTextLabelConstraint: NSLayoutConstraint?
  private var topSliderConstraint: NSLayoutConstraint?
  private var topImageViewConstraint: NSLayoutConstraint?
  private var trailingDraggedViewConstraint: NSLayoutConstraint?
  private var panGestureRecognizer: UIPanGestureRecognizer?
   var sliderPosition: DSSliderPosition = .left

  private var xEndingPoint: CGFloat {
    get {
      let endPoint = self.sliderView.frame.maxX - sliderImageView.bounds.width - sliderImageViewStartingDistance
      return endPoint
    }
  }

  private var xStartPoint: CGFloat {
    get {
      return sliderImageViewStartingDistance
    }
  }

  private var animationChangedEnabledBlock:((Bool) -> Void)?

  // MARK: - View Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setupView()
  }

  convenience public init(frame: CGRect, delegate: DSSliderDelegate? = nil) {
    self.init(frame: frame)
    self.delegate = delegate
  }

  // MARK: - Setup Methods

  private func setupView() {
    self.addSubview(sliderView)

    setupViews()
    setupConstraints()
    addPanGesture()
    setupBaseStyle()
  }

  private func setupViews() {
    sliderView.addSubview(sliderImageView)
    sliderView.addSubview(sliderBackgroundView)
    sliderView.addSubview(sliderDraggedView)
    sliderDraggedView.addSubview(sliderDraggedViewTextLabel)
    sliderBackgroundView.addSubview(sliderBackgroundViewTextLabel)
    sliderView.bringSubviewToFront(sliderImageView)
  }

  private func addPanGesture() {
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
    panGestureRecognizer?.minimumNumberOfTouches = 1
    if let panGestureRecognizer = panGestureRecognizer {
      sliderImageView.addGestureRecognizer(panGestureRecognizer)
    }
  }

  private func setupConstraints() {
    sliderView.translatesAutoresizingMaskIntoConstraints = false
    sliderImageView.translatesAutoresizingMaskIntoConstraints = false
    sliderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    sliderBackgroundViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
    sliderDraggedViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
    sliderDraggedView.translatesAutoresizingMaskIntoConstraints = false

    sliderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    sliderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    sliderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    sliderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    leadingImageViewConstraint = sliderImageView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor)
    leadingImageViewConstraint?.isActive = true
    topImageViewConstraint = sliderImageView.topAnchor.constraint(equalTo: sliderView.topAnchor,
                                                                  constant: sliderImageViewTopDistance)
    topImageViewConstraint?.isActive = true
    sliderImageView.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
    sliderImageView.heightAnchor.constraint(equalTo: sliderImageView.widthAnchor).isActive = true

    topSliderConstraint = sliderBackgroundView.topAnchor.constraint(equalTo: sliderView.topAnchor,
                                                                    constant: sliderViewTopDistance)
    topSliderConstraint?.isActive = true
    sliderBackgroundView.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor).isActive = true
    sliderBackgroundView.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor).isActive = true
    sliderBackgroundView.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor).isActive = true

    sliderBackgroundViewTextLabel.topAnchor.constraint(equalTo: sliderBackgroundView.topAnchor).isActive = true
    sliderBackgroundViewTextLabel.centerYAnchor.constraint(equalTo: sliderBackgroundView.centerYAnchor).isActive = true
    leadingTextLabelConstraint = sliderBackgroundViewTextLabel.leadingAnchor.constraint(equalTo: sliderBackgroundView.leadingAnchor,
                                                                                        constant: sliderTextLabelLeadingDistance)
    leadingTextLabelConstraint?.isActive = true
    sliderBackgroundViewTextLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor,
                                                            constant: CGFloat(-8)).isActive = true

    sliderDraggedViewTextLabel.topAnchor.constraint(equalTo: sliderBackgroundViewTextLabel.topAnchor).isActive = true
    sliderDraggedViewTextLabel.centerYAnchor.constraint(equalTo: sliderBackgroundViewTextLabel.centerYAnchor).isActive = true
    sliderDraggedViewTextLabel.leadingAnchor.constraint(equalTo: sliderBackgroundViewTextLabel.leadingAnchor).isActive = true
    sliderDraggedViewTextLabel.trailingAnchor.constraint(equalTo: sliderBackgroundViewTextLabel.trailingAnchor).isActive = true
    sliderDraggedView.leadingAnchor.constraint(equalTo: sliderBackgroundView.leadingAnchor).isActive = true
    sliderDraggedView.topAnchor.constraint(equalTo: sliderBackgroundView.topAnchor).isActive = true
    sliderDraggedView.centerYAnchor.constraint(equalTo: sliderBackgroundView.centerYAnchor).isActive = true
    trailingDraggedViewConstraint = sliderDraggedView.trailingAnchor.constraint(equalTo: sliderImageView.trailingAnchor,
                                                                                constant: sliderImageViewStartingDistance)
    trailingDraggedViewConstraint?.isActive = true
  }

  private func setupBaseStyle() {
    sliderImageView.backgroundColor = sliderImageViewBackgroundColor

    sliderBackgroundViewTextLabel.font = sliderTextFont
    sliderBackgroundViewTextLabel.textColor = sliderBackgroundViewTextColor
    sliderBackgroundViewTextLabel.textAlignment = .center

    sliderDraggedViewTextLabel.font = sliderTextFont
    sliderDraggedViewTextLabel.textColor = sliderDraggedViewTextColor
    sliderDraggedViewTextLabel.textAlignment = .center
    sliderDraggedViewTextLabel.isHidden = !isShowSliderText

    sliderBackgroundView.backgroundColor = sliderBackgroundColor
    sliderBackgroundView.layer.cornerRadius = sliderCornerRadius
    sliderDraggedView.backgroundColor = sliderDraggedViewBackgroundColor
    sliderDraggedView.layer.cornerRadius = sliderCornerRadius
    sliderDraggedView.clipsToBounds = true
    sliderDraggedView.layer.masksToBounds = true
  }

  // MARK: - Public Methods

  public func resetStateWithAnimation(_ animated: Bool) {
    updateThumbnail(withPosition: xStartPoint, andAnimation: animated)
    updateTextLabels(withPosition: 0)
    sliderPosition = .left
    layoutIfNeeded()
  }

  public static func dsSliderRedColor() -> UIColor {
    return UIColor.dsSliderRedColor
  }
    
    public func slideToEnd(){
        updateThumbnail(withPosition: xEndingPoint, andAnimation: false)
        updateTextLabels(withPosition: xEndingPoint)
        sliderPosition = .rigth
        layoutIfNeeded()
    }

  // MARK: - Private Methods

  private func isTapOnSliderImageView(withPoint point: CGPoint) -> Bool {
    return sliderImageView.frame.contains(point)
  }

  private func updateThumbnail(withPosition position: CGFloat, andAnimation animation: Bool = false) {
    leadingImageViewConstraint?.constant = position
    setNeedsLayout()
    if animation {
      UIView.animate(withDuration: sliderAnimationVelocity) {
        self.sliderView.layoutIfNeeded()
      }
    }
  }

  private func updateTextLabels(withPosition position: CGFloat) {
    guard isDoubleSideEnabled else { return }
    guard isTextChangeAnimating else { return }
    let textAlpha = (xEndingPoint - position) / xEndingPoint
    let sliderTextAlpha = 1.0 - (xEndingPoint - position) / xEndingPoint
    sliderBackgroundViewTextLabel.alpha = textAlpha
    sliderDraggedViewTextLabel.alpha = sliderTextAlpha
  }

  private func updateImageView(withAngle angle: CGFloat) {
    guard isDoubleSideEnabled else { return }
    guard isImageViewRotating else { return }
    print("Last Angle --\(angle)")
    sliderImageView.transform = CGAffineTransform(rotationAngle: angle)
      
  }

  @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    guard isEnabled else { return }
    let translatedPoint = sender.translation(in: sliderView).x
    switch sender.state {
    case .began:
      dsSliderPrint("Began")
    case .changed:
      if translatedPoint > 0 {
        dsSliderPrint("Changed - Right")
        guard sliderPosition == .left else {
          if translatedPoint >= xEndingPoint {
            updateThumbnail(withPosition: xEndingPoint)
          }
          return
        }
        if translatedPoint >= xEndingPoint {
          updateThumbnail(withPosition: xEndingPoint)
          return
        }
        updateThumbnail(withPosition: translatedPoint)
        updateTextLabels(withPosition: translatedPoint)
        let ratio = xEndingPoint / CGFloat.pi
        let angle = translatedPoint / ratio
        updateImageView(withAngle: angle)
      } else if translatedPoint <= 0 {
        dsSliderPrint("Changed - Left")
        guard sliderPosition == .rigth else {
          if translatedPoint <= xStartPoint {
            updateThumbnail(withPosition: xStartPoint)
          }
          return
        }
        let reverseTranslatedPoint = xEndingPoint + translatedPoint
        if reverseTranslatedPoint <= xStartPoint {
          updateThumbnail(withPosition: xStartPoint)
          return
        }
        updateThumbnail(withPosition: reverseTranslatedPoint)
        updateTextLabels(withPosition: reverseTranslatedPoint)
        let ratio = xEndingPoint / CGFloat.pi
        let angle = reverseTranslatedPoint / ratio
        updateImageView(withAngle: angle)
      }
      break
    case .ended:
      if translatedPoint > 0 {
        dsSliderPrint("Ended - Right")
        guard sliderPosition == .left else { return }
        if translatedPoint > xStartPoint && translatedPoint < xEndingPoint {
          updateThumbnail(withPosition: xStartPoint, andAnimation: true)
          updateTextLabels(withPosition: xStartPoint)
          updateImageView(withAngle: 0)
          sliderPosition = .left
        } else if translatedPoint >= xEndingPoint {
          guard isDoubleSideEnabled else {
            delegate?.sliderDidFinishSliding(self, at: .rigth)
            resetStateWithAnimation(true)
            return
          }
          updateThumbnail(withPosition: xEndingPoint, andAnimation: true)
          updateTextLabels(withPosition: xEndingPoint)
          updateImageView(withAngle: CGFloat.pi)
          sliderPosition = .rigth
          delegate?.sliderDidFinishSliding(self, at: .rigth)
        }
      } else if translatedPoint <= 0 {
        dsSliderPrint("Ended - Left")
        guard sliderPosition == .rigth else { return }
        let reverseTranslatedPoint = xEndingPoint + translatedPoint
        if reverseTranslatedPoint > xStartPoint && reverseTranslatedPoint < xEndingPoint {
          updateThumbnail(withPosition: xEndingPoint, andAnimation: true)
          updateTextLabels(withPosition: xEndingPoint)
          updateImageView(withAngle: CGFloat.pi)
          sliderPosition = .rigth
        } else if reverseTranslatedPoint <= xStartPoint {
          updateThumbnail(withPosition: xStartPoint, andAnimation: true)
          updateTextLabels(withPosition: xStartPoint)
          updateImageView(withAngle: 0)
          sliderPosition = .left
          delegate?.sliderDidFinishSliding(self, at: .left)
        }
      }
      break
    default:
      break
    }
  }
}


public enum DSSliderPosition {
  case left
  case rigth
  
  public func getBoolValue() -> Bool {
    switch self {
    case .left:
      return false
    case .rigth:
      return true
    }
  }
}

extension DSSlider {
  
  func dsSliderPrint(_ string: String) {
    guard isDebugPrintEnabled else { return }
    debugPrint("DSSlider: \(string)")
  }
}


extension UIColor {
  static let dsSliderRedColor = UIColor(red: 0.92, green: 0.31, blue: 0.27, alpha: 1.0)
}


public class DSRoundImageView: UIImageView {
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = bounds.size.width / 2.0
    isUserInteractionEnabled = true
    contentMode = .center
  }
}
