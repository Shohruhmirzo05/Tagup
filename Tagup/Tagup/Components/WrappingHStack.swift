//
//  WrappingHStack.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 23/06/24.
//

import SwiftUI

public struct WrappingHStack: View {
    private struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout CGFloat , nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    public enum Spacing {
        case constant(CGFloat)
        case dynamic(minSpacing: CGFloat)
        case dynamicIncludingBorders(minSpacing: CGFloat)
        
        internal var minSpacing: CGFloat {
            switch self {
            case .constant(let constantSpacing):
                return constantSpacing
            case .dynamic(minSpacing: let minSpacing), .dynamicIncludingBorders(minSpacing: let minSpacing):
                return minSpacing
            }
        }
    }

    let alignment: HorizontalAlignment
    let spacing: Spacing
    let lineSpacing: CGFloat
    let contentManager: ContentManager
    @State private var height: CGFloat = 0
    
    public var body: some View {
        GeometryReader { geo in
            InternalWrappingHStack (
                width: geo.size.width,
                alignment: alignment,
                spacing: spacing,
                lineSpacing: lineSpacing,
                contentManager: contentManager
            )
            .anchorPreference(
                key: HeightPreferenceKey.self,
                value: .bounds,
                transform: {
                    geo[$0].size.height
                }
            )
        }
        .frame(height: height)
        .onPreferenceChange(HeightPreferenceKey.self, perform: {
            if abs(height - $0) > 1 {
                height = $0
            }
        })
    }
}

// Convenience inits that allows 10 Elements (just like HStack).
// Based on https://alejandromp.com/blog/implementing-a-equally-spaced-stack-in-swiftui-thanks-to-tupleview/
public extension WrappingHStack {
    @inline(__always) private static func getWidth<V: View>(of view: V) -> Double {
        if view is NewLine {
            return .infinity
        }

#if os(macOS)
        let hostingController = NSHostingController(rootView: view)
#else
        let hostingController = UIHostingController(rootView: view)
#endif
        return hostingController.sizeThatFits(in: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }
    
    /// Instatiates a WrappingHStack
    /// - Parameters:
    ///   - data: The items to show
    ///   - id: The `KeyPath` to use as id for the items
    ///   - alignment: Controls the alignment of the items. This may get
    ///    ignored when combined with `.dynamicIncludingBorders` or
    ///    `.dynamic` spacing.
    ///   - spacing: Use `.constant` for fixed spacing, `.dynamic` to have
    ///    the items fill the width of the WrappingHSTack and
    ///    `.dynamicIncludingBorders` to fill the full width with equal spacing
    ///    between items and from the items to the border.
    ///   - lineSpacing: The distance in points between the bottom of one line
    ///    fragment and the top of the next
    ///   - content: The content and behavior of the view.
    init<Data: RandomAccessCollection, Content: View>(_ data: Data, id: KeyPath<Data.Element, Data.Element> = \.self, alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: data.map { ViewType(rawView: content($0[keyPath: id])) },
            getWidths: {
                data.map {
                    Self.getWidth(of: content($0[keyPath: id]))
                }
            })
    }
    
    init<A: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> A) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content())],
            getWidths: {
                [Self.getWidth(of: content())]
            })
    }
    
    init<A: View, B: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items:  [ViewType(rawView: content().value.0),
                     ViewType(rawView: content().value.1)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1)
                ]
            })
    }
    
    init<A: View, B: View, C: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View, E: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4)],
                    getWidths: {
                        [
                            Self.getWidth(of: content().value.0),
                            Self.getWidth(of: content().value.1),
                            Self.getWidth(of: content().value.2),
                            Self.getWidth(of: content().value.3),
                            Self.getWidth(of: content().value.4)
                        ]
                    })
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E, F)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4),
                    ViewType(rawView: content().value.5)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3),
                    Self.getWidth(of: content().value.4),
                    Self.getWidth(of: content().value.5)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View, G: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E, F, G)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4),
                    ViewType(rawView: content().value.5),
                    ViewType(rawView: content().value.6)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3),
                    Self.getWidth(of: content().value.4),
                    Self.getWidth(of: content().value.5),
                    Self.getWidth(of: content().value.6)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View, G: View, H: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E, F, G, H)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4),
                    ViewType(rawView: content().value.5),
                    ViewType(rawView: content().value.6),
                    ViewType(rawView: content().value.7)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3),
                    Self.getWidth(of: content().value.4),
                    Self.getWidth(of: content().value.5),
                    Self.getWidth(of: content().value.6),
                    Self.getWidth(of: content().value.7)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View, G: View, H: View, I: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E, F ,G, H, I)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4),
                    ViewType(rawView: content().value.5),
                    ViewType(rawView: content().value.6),
                    ViewType(rawView: content().value.7),
                    ViewType(rawView: content().value.8)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3),
                    Self.getWidth(of: content().value.4),
                    Self.getWidth(of: content().value.5),
                    Self.getWidth(of: content().value.6),
                    Self.getWidth(of: content().value.7),
                    Self.getWidth(of: content().value.8)
                ]
            })
    }
    
    init<A: View, B: View, C: View, D: View, E: View, F: View, G: View, H: View, I: View, J: View>(alignment: HorizontalAlignment = .leading, spacing: Spacing = .constant(8), lineSpacing: CGFloat = 0, @ViewBuilder content: @escaping () -> TupleView<(A, B, C, D, E, F ,G, H, I, J)>) {
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.alignment = alignment
        self.contentManager = ContentManager(
            items: [ViewType(rawView: content().value.0),
                    ViewType(rawView: content().value.1),
                    ViewType(rawView: content().value.2),
                    ViewType(rawView: content().value.3),
                    ViewType(rawView: content().value.4),
                    ViewType(rawView: content().value.5),
                    ViewType(rawView: content().value.6),
                    ViewType(rawView: content().value.7),
                    ViewType(rawView: content().value.8),
                    ViewType(rawView: content().value.9)],
            getWidths: {
                [
                    Self.getWidth(of: content().value.0),
                    Self.getWidth(of: content().value.1),
                    Self.getWidth(of: content().value.2),
                    Self.getWidth(of: content().value.3),
                    Self.getWidth(of: content().value.4),
                    Self.getWidth(of: content().value.5),
                    Self.getWidth(of: content().value.6),
                    Self.getWidth(of: content().value.7),
                    Self.getWidth(of: content().value.8),
                    Self.getWidth(of: content().value.9)
                ]
            })
    }
}

// ---------------------------------------------
enum ViewType {
    case any(AnyView)
    case newLine

    init<V: View>(rawView: V) {
        switch rawView {
        case is NewLine: self = .newLine
        default: self = .any(AnyView(rawView))
        }
    }
}

// ---------------------------------------------
/// Use this item to force a line break in a WrappingHStack
public struct NewLine: View {
    public init() { }
    public let body = Spacer(minLength: .infinity)
}

// ---------------------------------------------
/// This View draws the WrappingHStack content taking into account the passed width, alignment and spacings.
/// Note that the passed LineManager and ContentManager should be reused whenever possible.
struct InternalWrappingHStack: View {
    let width: CGFloat
    let alignment: HorizontalAlignment
    let spacing: WrappingHStack.Spacing
    let lineSpacing: CGFloat
    let firstItemOfEachLine: [Int]
    let contentManager: ContentManager

    init(width: CGFloat, alignment: HorizontalAlignment, spacing: WrappingHStack.Spacing, lineSpacing: CGFloat, contentManager: ContentManager) {
        self.width = width
        self.alignment = alignment
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.contentManager = contentManager
        self.firstItemOfEachLine = {
            var firstOfEach = [Int]()
            var currentWidth: Double = width
            for (index, element) in contentManager.items.enumerated() {
                switch element {
                case .newLine:
                    firstOfEach += [index]
                    currentWidth = width
                case .any where contentManager.isVisible(viewIndex: index):
                    let itemWidth = contentManager.widths[index]
                    if currentWidth + itemWidth + spacing.minSpacing > width {
                        currentWidth = itemWidth
                        firstOfEach.append(index)
                    } else {
                        currentWidth += itemWidth + spacing.minSpacing
                    }
                default:
                    break
                }
            }

            return firstOfEach
        }()
    }
    
    func shouldHaveSideSpacers(line i: Int) -> Bool {
        if case .constant = spacing {
            return true
        }
        if case .dynamic = spacing, hasExactlyOneElement(line: i) {
            return true
        }
        return false
    }

    var totalLines: Int {
        firstItemOfEachLine.count
    }

    func startOf(line i: Int) -> Int {
        firstItemOfEachLine[i]
    }

    func endOf(line i: Int) -> Int {
        i == totalLines - 1 ? contentManager.items.count - 1 : firstItemOfEachLine[i + 1] - 1
    }

    func hasExactlyOneElement(line i: Int) -> Bool {
        startOf(line: i) == endOf(line: i)
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: lineSpacing) {
            ForEach(0 ..< totalLines, id: \.self) { lineIndex in
                HStack(spacing: 0) {
                    if alignment == .center || alignment == .trailing, shouldHaveSideSpacers(line: lineIndex) {
                        Spacer(minLength: 0)
                    }
                    
                    ForEach(startOf(line: lineIndex) ... endOf(line: lineIndex), id: \.self) {
                        if case .dynamicIncludingBorders = spacing,
                            startOf(line: lineIndex) == $0
                        {
                            Spacer(minLength: spacing.minSpacing)
                        }
                        
                        if case .any(let anyView) = contentManager.items[$0], contentManager.isVisible(viewIndex: $0) {
                            anyView
                        }
                        
                        if endOf(line: lineIndex) != $0 {
                            if case .any = contentManager.items[$0], !contentManager.isVisible(viewIndex: $0) { } else {
                                if case .constant(let exactSpacing) = spacing {
                                    Spacer(minLength: 0)
                                        .frame(width: exactSpacing)
                                } else {
                                    Spacer(minLength: spacing.minSpacing)
                                }
                            }
                        } else if case .dynamicIncludingBorders = spacing {
                            Spacer(minLength: spacing.minSpacing)
                        }
                    }
                    
                    if alignment == .center || alignment == .leading, shouldHaveSideSpacers(line: lineIndex) {
                        Spacer(minLength: 0)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// ---------------------------------------------
/// This class manages content and the calculation of their widths (reusing it).
/// It should be reused whenever possible.
class ContentManager {
    let items: [ViewType]
    let getWidths: () -> [Double]
    lazy var widths: [Double] = {
        getWidths()
    }()

    init(items: [ViewType], getWidths: @escaping () -> [Double]) {
        self.items = items
        self.getWidths = getWidths
    }
    
    func isVisible(viewIndex: Int) -> Bool {
        widths[viewIndex] > 0
    }
}

public struct WrappedCollectionView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let spacing: CGFloat
    private let singleItemHeight: CGFloat
    private let content: (Data.Element) -> Content
    @State private var totalHeight: CGFloat = .zero
    
    public init(
        data: Data,
        spacing: CGFloat = 8,
        singleItemHeight: CGFloat,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.singleItemHeight = singleItemHeight
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                generateContent(in: geometry)
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                    })
            }
        }
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            totalHeight = height
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(data) { item in
                content(item)
                    .alignmentGuide(
                        .leading,
                        computeValue: { dimension in
                            if abs(width - dimension.width) > geometry.size.width {
                                width = 0
                                height -= dimension.height + spacing
                            }
                            
                            let result = width
                            if item.id == data.last?.id {
                                width = 0
                            } else {
                                width -= dimension.width + spacing
                            }
                            return result
                        }
                    )
                    .alignmentGuide(
                        .top,
                        computeValue: { _ in
                            let result = height
                            if item.id == data.last?.id {
                                height = 0
                            }
                            return result
                        }
                    )
            }
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
