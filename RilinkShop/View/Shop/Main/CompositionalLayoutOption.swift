//
//  CompositionalLayoutOption.swift
//  RilinkShop
//
//  Created by Tai Chin Huang on 2022/5/4.
//

import Foundation
import CoreGraphics
// Define layout possibilities as enum
enum CompositionalLayoutOption {
    /// cell will adjust its width to fit its contents.
    case dynamicWidthFixedHeight(estimatedWidth: CGFloat, fixedHeight: CGFloat)

    /// cell will adjust its width and height to fit its content.
    case dynamicWidthDynamicHeight(estimatedWidth: CGFloat, estimatedHeight: CGFloat)

    /// cells will have a predetermined size
    case fixedWidthFixedHeight(fixedWidth: CGFloat, fixedHeight: CGFloat)

    /// cells will adjust its height to fit its content.
    case fixedWidthDynamicHeight(fixedWidth: CGFloat, estimatedHeight: CGFloat)

    // fractional width
    /// cell will take the provided fraction of the screen while adjusting its height to fit its contents.
    case fractionalWidthDynamicHeight(fractionalWidth: CGFloat, estimatedHeight: CGFloat)

    /// cell will take the provided fraction of the screen.
    case fractionalWidthFixedHeight(fractionalWidth: CGFloat, fixedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 1.0
    case fullWidthDynamicHeight(estimatedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 1.0
    case fullWidthFixedHeight(fixedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.5
    case halfWidthDynamicHeight(estimatedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.5
    case halfWidthFixedHeight(fixedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.3333
    case thirdWidthDynamicHeight(estimatedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.3333
    case thirdWidthFixedHeight(fixedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.25
    case quarterWidthDynamicHeight(estimatedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 0.25
    case quarterWidthFixedHeight(fixedHeight: CGFloat)

    /// you use min width cells depending on the available screen size.
    /// compositional layout will try to fit as many cells as possible in the same row
    case minWidthDynamicHeight(minWidth: CGFloat, estimatedHeight: CGFloat)

    /// you use flexible width cells depending on the available screen size.
    /// compositional layout will try to fit as many cells as possible in the same row
    case minWidthFixedHeight(minWidth: CGFloat, fixedHeight: CGFloat)
}
