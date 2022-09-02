//
//  UIView+ZGUIkit.swift
//  ZegoUIKit
//
//  Created by zego on 2022/7/18.
//

import Foundation
import UIKit

extension UIView {
    // EqualTo
    @discardableResult
    func zgu_constraint(equalTo view: UIView,
                        leading: CGFloat? = nil,
                        trailing: CGFloat? = nil,
                        left: CGFloat? = nil,
                        right: CGFloat? = nil,
                        top: CGFloat? = nil,
                        bottom: CGFloat? = nil,
                        centerX: CGFloat? = nil,
                        centerY: CGFloat? = nil,
                        priority: UILayoutPriority? = nil) -> UIView {
        
        return self.zgu_constraint_equalTo(
            leadingAnchor: view.leadingAnchor,
            leading: leading,
            trailingAnchor: view.trailingAnchor,
            trailing: trailing,
            leftAnchor: view.leftAnchor,
            left: left,
            rightAnchor: view.rightAnchor,
            right: right,
            topAnchor: view.topAnchor,
            top: top,
            bottomAnchor: view.bottomAnchor,
            bottom: bottom,
            centerXAnchor: view.centerXAnchor,
            centerX: centerX,
            centerYAnchor: view.centerYAnchor,
            centerY: centerY,
            priority: priority
        )
    }
    
    @discardableResult
    func zgu_constraint_equalTo(
        leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, leading: CGFloat? = nil,
        trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, trailing: CGFloat? = nil,
        leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, left: CGFloat? = nil,
        rightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, right: CGFloat? = nil,
        topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, top: CGFloat? = nil,
        bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, bottom: CGFloat? = nil,
        centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, centerX: CGFloat? = nil,
        centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, centerY: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let leadingAnchor = leadingAnchor, let leading = leading {
            layoutConstraints.append(
                self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading)
            )
        }
        
        if let trailingAnchor = trailingAnchor, let trailing = trailing {
            layoutConstraints.append(
                self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing)
            )
        }
        
        if let leftAnchor = leftAnchor, let left = left {
            layoutConstraints.append(
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: left)
            )
        }
        
        if let rightAnchor = rightAnchor, let right = right {
            layoutConstraints.append(
                self.rightAnchor.constraint(equalTo: rightAnchor, constant: -right)
            )
        }
        
        if let topAnchor = topAnchor, let top = top {
            layoutConstraints.append(
                self.topAnchor.constraint(equalTo: topAnchor, constant: top)
            )
        }
        
        if let bottomAnchor = bottomAnchor, let bottom = bottom {
            layoutConstraints.append(
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom)
            )
        }
        
        if let centerXAnchor = centerXAnchor, let centerX = centerX {
            layoutConstraints.append(
                self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerX)
            )
        }
        
        if let centerYAnchor = centerYAnchor, let centerY = centerY {
            layoutConstraints.append(
                self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerY)
            )
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    //GreaterThanOrEqualTo
    @discardableResult
    func zgu_constraint(greaterThanOrEqualTo view: UIView,
                        leading: CGFloat? = nil,
                        trailing: CGFloat? = nil,
                        left: CGFloat? = nil,
                        right: CGFloat? = nil,
                        top: CGFloat? = nil,
                        bottom: CGFloat? = nil,
                        centerX: CGFloat? = nil,
                        centerY: CGFloat? = nil,
                        priority: UILayoutPriority? = nil) -> UIView {
        
        return self.zgu_constraint_greater(
            leadingAnchor: view.leadingAnchor,
            leading: leading,
            trailingAnchor: view.trailingAnchor,
            trailing: trailing,
            leftAnchor: view.leftAnchor,
            left: left,
            rightAnchor: view.rightAnchor,
            right: right,
            topAnchor: view.topAnchor,
            top: top,
            bottomAnchor: view.bottomAnchor,
            bottom: bottom,
            centerXAnchor: view.centerXAnchor,
            centerX: centerX,
            centerYAnchor: view.centerYAnchor,
            centerY: centerY,
            priority: priority
        )
    }
    
    @discardableResult
    func zgu_constraint_greater (
        leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, leading: CGFloat? = nil,
        trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, trailing: CGFloat? = nil,
        leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, left: CGFloat? = nil,
        rightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, right: CGFloat? = nil,
        topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, top: CGFloat? = nil,
        bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, bottom: CGFloat? = nil,
        centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, centerX: CGFloat? = nil,
        centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, centerY: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let leadingAnchor = leadingAnchor, let leading = leading {
            layoutConstraints.append(
                self.leadingAnchor.constraint(
                    greaterThanOrEqualTo: leadingAnchor,
                    constant: leading
                )
            )
        }
        
        if let trailingAnchor = trailingAnchor, let trailing = trailing {
            layoutConstraints.append(
                self.trailingAnchor.constraint(
                    greaterThanOrEqualTo: trailingAnchor,
                    constant: trailing
                )
            )
        }
        
        if let leftAnchor = leftAnchor, let left = left {
            layoutConstraints.append(
                self.leftAnchor.constraint(
                    greaterThanOrEqualTo: leftAnchor,
                    constant: left
                )
            )
        }
        
        if let rightAnchor = rightAnchor, let right = right {
            layoutConstraints.append(
                self.rightAnchor.constraint(
                    greaterThanOrEqualTo: rightAnchor,
                    constant: -right
                )
            )
        }
        
        if let topAnchor = topAnchor, let top = top {
            layoutConstraints.append(
                self.topAnchor.constraint(
                    greaterThanOrEqualTo: topAnchor,
                    constant: top
                )
            )
        }
        
        if let bottomAnchor = bottomAnchor, let bottom = bottom {
            layoutConstraints.append(
                self.bottomAnchor.constraint(
                    greaterThanOrEqualTo: bottomAnchor,
                    constant: -bottom
                )
            )
        }
        
        if let centerXAnchor = centerXAnchor, let centerX = centerX {
            layoutConstraints.append(
                self.centerXAnchor.constraint(
                    greaterThanOrEqualTo: centerXAnchor,
                    constant: centerX
                )
            )
        }
        
        if let centerYAnchor = centerYAnchor, let centerY = centerY {
            layoutConstraints.append(
                self.centerYAnchor.constraint(
                    greaterThanOrEqualTo: centerYAnchor,
                    constant: centerY
                )
            )
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    //LessThanOrEqualTo
    @discardableResult
    func zgu_constraint(lessThanOrEqualTo view: UIView,
                        leading: CGFloat? = nil,
                        trailing: CGFloat? = nil,
                        left: CGFloat? = nil,
                        right: CGFloat? = nil,
                        top: CGFloat? = nil,
                        bottom: CGFloat? = nil,
                        centerX: CGFloat? = nil,
                        centerY: CGFloat? = nil,
                        priority: UILayoutPriority? = nil) -> UIView {
        
        return self.zgu_constraint_less(
            leadingAnchor: view.leadingAnchor,
            leading: leading,
            trailingAnchor: view.trailingAnchor,
            trailing: trailing,
            leftAnchor: view.leftAnchor,
            left: left,
            rightAnchor: view.rightAnchor,
            right: right,
            topAnchor: view.topAnchor,
            top: top,
            bottomAnchor: view.bottomAnchor,
            bottom: bottom,
            centerXAnchor: view.centerXAnchor,
            centerX: centerX,
            centerYAnchor: view.centerYAnchor,
            centerY: centerY,
            priority: priority
        )
    }
    
    @discardableResult
    func zgu_constraint_less (
        leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, leading: CGFloat? = nil,
        trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, trailing: CGFloat? = nil,
        leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, left: CGFloat? = nil,
        rightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, right: CGFloat? = nil,
        topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, top: CGFloat? = nil,
        bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, bottom: CGFloat? = nil,
        centerXAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil, centerX: CGFloat? = nil,
        centerYAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil, centerY: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let leadingAnchor = leadingAnchor, let leading = leading {
            layoutConstraints.append(
                self.leadingAnchor.constraint(
                    lessThanOrEqualTo: leadingAnchor,
                    constant: leading
                )
            )
        }
        
        if let trailingAnchor = trailingAnchor, let trailing = trailing {
            layoutConstraints.append(
                self.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: trailing
                )
            )
        }
        
        if let leftAnchor = leftAnchor, let left = left {
            layoutConstraints.append(
                self.leftAnchor.constraint(
                    lessThanOrEqualTo: leftAnchor,
                    constant: left
                )
            )
        }
        
        if let rightAnchor = rightAnchor, let right = right {
            layoutConstraints.append(
                self.rightAnchor.constraint(
                    lessThanOrEqualTo: rightAnchor,
                    constant: -right
                )
            )
        }
        
        if let topAnchor = topAnchor, let top = top {
            layoutConstraints.append(
                self.topAnchor.constraint(
                    lessThanOrEqualTo: topAnchor,
                    constant: top
                )
            )
        }
        
        if let bottomAnchor = bottomAnchor, let bottom = bottom {
            layoutConstraints.append(
                self.bottomAnchor.constraint(
                    lessThanOrEqualTo: bottomAnchor,
                    constant: -bottom
                )
            )
        }
        
        if let centerXAnchor = centerXAnchor, let centerX = centerX {
            layoutConstraints.append(
                self.centerXAnchor.constraint(
                    lessThanOrEqualTo: centerXAnchor,
                    constant: centerX
                )
            )
        }
        
        if let centerYAnchor = centerYAnchor, let centerY = centerY {
            layoutConstraints.append(
                self.centerYAnchor.constraint(
                    lessThanOrEqualTo: centerYAnchor,
                    constant: centerY
                )
            )
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    @discardableResult
    func zgu_constraint(width: CGFloat? = nil,
                        height: CGFloat? = nil,
                        priority: UILayoutPriority? = nil) -> UIView {
        
        return self.zgu_constraint(
            widthAnchor: nil, width: width,
            heightAnchor: nil, height: height,
            priority: priority
        )
    }
    
    // Width, Height -> If Anchor set nil value, AnchorConstant set value work as equalToConstant.
    // example, (..leadingAnchor: nil, leadingAnchorConstant: 30,..) -> (..equalToConstant: 30..)
    @discardableResult
    func zgu_constraint(
        widthAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, width: CGFloat? = nil,
        heightAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, height: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let width = width {
            if let widthAnchor = widthAnchor {
                layoutConstraints.append(
                    self.widthAnchor.constraint(equalTo: widthAnchor, constant: width)
                )
            } else {
                layoutConstraints.append(
                    self.widthAnchor.constraint(equalToConstant: width))
            }
        }
        
        if let height = height {
            if let heightAnchor = heightAnchor {
                layoutConstraints.append(
                    self.heightAnchor.constraint(equalTo: heightAnchor, constant: height))
            } else {
                layoutConstraints.append(
                    self.heightAnchor.constraint(equalToConstant: height))
            }
        }
        
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    @discardableResult
    func zgu_constraint_greaterThan(
        widthAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, width: CGFloat? = nil,
        heightAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, height: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let width = width {
            if let widthAnchor = widthAnchor {
                layoutConstraints.append(
                    self.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, constant: width)
                )
            } else {
                layoutConstraints.append(
                    self.widthAnchor.constraint(greaterThanOrEqualToConstant: width)
                )
            }
        }
        
        if let height = height {
            if let heightAnchor = heightAnchor {
                layoutConstraints.append(
                    self.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: height))
            } else {
                layoutConstraints.append(
                    self.heightAnchor.constraint(greaterThanOrEqualToConstant: height))
            }
        }
        
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    @discardableResult
    func zgu_constraint_lessThan(
        widthAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, width: CGFloat? = nil,
        heightAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil, height: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        if let width = width {
            if let widthAnchor = widthAnchor {
                layoutConstraints.append(
                    self.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: width)
                )
            } else {
                layoutConstraints.append(
                    self.widthAnchor.constraint(lessThanOrEqualToConstant: width)
                )
            }
        }
        
        if let height = height {
            if let heightAnchor = heightAnchor {
                layoutConstraints.append(
                    self.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: height))
            } else {
                layoutConstraints.append(
                    self.heightAnchor.constraint(lessThanOrEqualToConstant: height))
            }
        }
        
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        return self
    }
    
    
    
    //////////////////////////////////////////////////////
    /// vv Will be removed. vv
    //////////////////////////////////////////////////////
    
    // Set left, right, top, bottom
    @discardableResult
    func setConstraint(from view: UIView,
                       leading: CGFloat? = nil,
                       trailing: CGFloat? = nil,
                       left: CGFloat? = nil,
                       right: CGFloat? = nil,
                       top: CGFloat? = nil,
                       bottom: CGFloat? = nil,
                       priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let leading = leading {
            constraints += [
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading)
            ]
        }
        
        if let trailing = trailing {
            constraints += [
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)
            ]
        }
        
        if let left = left {
            constraints += [
                self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left)
            ]
        }
        if let right = right {
            constraints += [
                self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -right)
            ]
        }
        if let top = top {
            constraints += [
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: top)
            ]
        }
        if let bottom = bottom {
            constraints += [
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom)
            ]
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return self
    }
    
    // Set width, height
    @discardableResult
    func setConstraint(width: CGFloat? = nil,
                       height: CGFloat? = nil,
                       priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = width {
            constraints += [self.widthAnchor.constraint(equalToConstant: width)]
        }
        
        if let height = height {
            constraints += [self.heightAnchor.constraint(equalToConstant: height)]
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return self
    }
    
    // Set CenterX, CenterY
    @discardableResult
    func setConstraint(from view: UIView,
                       centerX: Bool = false,
                       centerY: Bool = false,
                       priority: UILayoutPriority? = nil) -> UIView {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if centerX {
            constraints += [self.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        }
        
        if centerY {
            constraints += [self.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        }
        
        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return self
    }
    
    
    func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    /**
         Removes all constrains for this view
         */
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    
    func cornerCut(_ radius: Int, corner: UIRectCorner) {
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
        
}
