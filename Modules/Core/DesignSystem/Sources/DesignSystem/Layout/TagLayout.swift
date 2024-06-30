import SwiftUI

// MARK: - TagLayout

public struct TagLayout: Layout {
  public init(
    alignment: Alignment = .leading,
    spacing: CGFloat = 10)
  {
    self.alignment = alignment
    self.spacing = spacing
  }
  
  // Layout Properties
  let alignment: Alignment
  // Both Horizontal & Vertical
  let spacing: CGFloat

  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
    let maxWidth = proposal.width ?? .zero
    var height: CGFloat = .zero
    let rowList = generateRowList(maxWidth, proposal, subviews)

    for (index, row) in rowList.enumerated() {
      // Finding max Height in each row and adding it to the View's Total Height
      if index == (rowList.count - 1) {
        // Since there is no spacing needed for the last item
        height = height + row.maxHeight(proposal)
      } else {
        height = height + row.maxHeight(proposal) + spacing
      }
    }

    return .init(width: maxWidth, height: height)
  }

  public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
    // Placing Views
    var origin = bounds.origin
    let maxWidth = bounds.width
    let rowList = generateRowList(maxWidth, proposal, subviews)

    for row in rowList {
      // Chaning Origin X based on Alignments
      let leading: CGFloat = bounds.maxX - maxWidth
      let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { curr, next in
        let width = next.sizeThatFits(proposal).width

        if next == row.last {
          // No Spacing
          return curr + width
        }
        // With Spacing
        return curr + width + spacing
      })
      let center = (trailing + leading) / 2

      // Resetting Origin X to Zero for Each Row
      origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : alignment == .center ? center : .zero)

      for view in row {
        let viewSize = view.sizeThatFits(proposal)
        view.place(at: origin, proposal: proposal)
        // Updating Origin X
        origin.x = origin.x + (viewSize.width + spacing)
      }

      // Updating Origin Y
      origin.y = origin.y + (row.maxHeight(proposal) + spacing)
    }
  }

  // Generating Rows based on Available Size
  func generateRowList(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
    var row: [LayoutSubviews.Element] = []
    var rowList: [[LayoutSubviews.Element]] = []

    var origin = CGRect.zero.origin

    for view in subviews {
      let viewSize = view.sizeThatFits(proposal)

      // Pushing to New Row

      if (origin.x + viewSize.width + spacing) > maxWidth {
        rowList.append(row)
        row.removeAll()
        // Resetting X Origin since it needs to start form left to right
        origin.x = .zero
        row.append(view)
        // Updating Origin X
        origin.x = origin.x + (viewSize.width + spacing)
      } else {
        // Adding item to Same row
        row.append(view)
        // Updating Origin X
        origin.x = origin.x + (viewSize.width + spacing)
      }
    }

    // Checking for any exhaust row
    if !row.isEmpty {
      rowList.append(row)
      row.removeAll()
    }

    return rowList
  }
}

extension [LayoutSubviews.Element] {
  func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
    self.compactMap { view in
      view.sizeThatFits(proposal).height
    }.max() ?? .zero
  }
}
