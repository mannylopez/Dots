// Created by manny_lopez on 1/2/25.

import SwiftUI

// MARK: - AdaptiveShadow

struct AdaptiveShadow: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  let radius: CGFloat
  let x: CGFloat
  let y: CGFloat
  let opacity: CGFloat

  func body(content: Content) -> some View {
    content.shadow(
      color: colorScheme == .light ? .black.opacity(opacity) : .gray.opacity(opacity),
      radius: radius,
      x: x,
      y: y)
  }
}

extension View {
  func adaptiveShadow(
    radius: CGFloat = 8,
    x: CGFloat = 0,
    y: CGFloat = 4,
    opacity: CGFloat = 0.3)
    -> some View
  {
    modifier(AdaptiveShadow(
      radius: radius,
      x: x,
      y: y,
      opacity: opacity))
  }
}
