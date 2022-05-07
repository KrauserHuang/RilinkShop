//
//  NSCollectionLayoutSize + Ext.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/4.
//

import Foundation
import UIKit
// Define the Layout Protocol
protocol DefinesCompositionalLayout {
    /// Required. Provides the meta data needed to layout the cells
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption
    
    /// Optional. Override only if you want to provide additional insets (spacing) around each section
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets
    
    /// Optional. Override only if you want to provide additional spacing around each cell
    var interItemSpacing: CGFloat { get }
    
    /// Optional. Override only if you want to provide additional spacing around each group
    var interGroupSpacing: CGFloat { get }
}
// Provide default implementations
extension DefinesCompositionalLayout {
    var interItemSpacing: CGFloat {
        return .zero
    }
    
    var interGroupSpacing: CGFloat {
        return .zero
    }
    
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        return .zero
    }
}
// Extend NSCollectionLayoutSize
extension NSCollectionLayoutSize {
    convenience init(with layoutInfo: CompositionalLayoutOption) {
        switch layoutInfo {
        case .dynamicWidthFixedHeight(let estimatedWidth, let fixedHeight):
            self.init(
                widthDimension: .estimated(estimatedWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .dynamicWidthDynamicHeight(let estimatedWidth, let estimatedHeight):
            self.init(
                widthDimension: .estimated(estimatedWidth),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fixedWidthFixedHeight(let fixedWidth, let fixedHeight):
            self.init(
                widthDimension: .absolute(fixedWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .fixedWidthDynamicHeight(let fixedWidth, let estimatedHeight):
            self.init(
                widthDimension: .absolute(fixedWidth),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fractionalWidthDynamicHeight(let fractionalWidth, let estimatedHeight):
            self.init(
                widthDimension: .fractionalWidth(fractionalWidth),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fractionalWidthFixedHeight(let fractionalWidth, let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(fractionalWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .fullWidthDynamicHeight(let estimatedHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fullWidthFixedHeight(let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(fixedHeight)
            )
        case .halfWidthDynamicHeight(let estimatedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(estimatedHeight)
            )
        case .halfWidthFixedHeight(let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(fixedHeight)
            )
        case .thirdWidthDynamicHeight(let estimatedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.333333),
                heightDimension: .estimated(estimatedHeight)
            )
        case .thirdWidthFixedHeight(let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.333333),
                heightDimension: .absolute(fixedHeight)
            )
        case .quarterWidthDynamicHeight(let estimatedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .estimated(estimatedHeight)
            )
        case .quarterWidthFixedHeight(let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(0.25),
                heightDimension: .absolute(fixedHeight)
            )
        case .minWidthDynamicHeight, .minWidthFixedHeight:
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(1)
            )
        }
    }
}
