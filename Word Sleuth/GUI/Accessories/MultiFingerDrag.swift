//
//  MultiFingerDrag.swift
//  Word Hunt
//
//  Created by Itsuki on Medium.
//

import SwiftUI

struct MultiFingerDrag: View {
	@State var position: CGPoint = CGPoint(x: 180, y: 360)
	var body: some View {
		VStack {
			if #available(iOS 18.0, *) {
				Circle()
					.fill(Color.red.opacity(0.8))
					.frame(width: 120)
					.position(position)
					.gesture(
						MultiFingerDragGesture(minimumDistance: 0)
							.onChange { value in
								position = value.location
							}
					)
			} else {
				// Fallback on earlier versions
				Circle()
					.fill(Color.red.opacity(0.8))
					.frame(width: 120)
					.position(position)
					.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								position = value.location
							}
					)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background(.gray.opacity(0.2))
	}
}

extension MultiFingerDragGesture {
	@MainActor @preconcurrency func onEnd(perform action: @escaping (MultiFingerDragGesture.Value) -> Void) -> Self {
		var mutableSelf = self
		mutableSelf.onEnd = action
		return mutableSelf
	}
	
	@MainActor @preconcurrency public func onChange(perform action: @escaping (MultiFingerDragGesture.Value) -> Void) -> Self {
		var mutableSelf = self
		mutableSelf.onChange = action
		return mutableSelf
	}
}



struct MultiFingerDragGesture: UIGestureRecognizerRepresentable {
	public struct Value : Equatable, Sendable {
		public var time: Date
		public var location: CGPoint
		public var startLocation: CGPoint
		public var translation: CGSize {
			return CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)
		}
		public static func == (a: MultiFingerDragGesture.Value, b: MultiFingerDragGesture.Value) -> Bool {
			return a.time == b.time && a.location == b.location && a.startLocation == b.startLocation
		}
	}
	
	@MainActor @preconcurrency public var minimumNumberOfTouches: Int
	@MainActor @preconcurrency public var maximumNumberOfTouches: Int
	
	@MainActor @preconcurrency public var minimumDistance: CGFloat
	@MainActor @preconcurrency public var coordinateSpace: CoordinateSpaceProtocol
	
	@MainActor @preconcurrency public init(
		minimumDistance: CGFloat = 10,
		coordinateSpace: CoordinateSpaceProtocol = .local,
		minimumNumberOfTouches: Int = 1,
		maximumNumberOfTouches: Int = 1
	) {
		self.coordinateSpace = coordinateSpace
		self.minimumDistance = minimumDistance
		self.minimumNumberOfTouches = minimumNumberOfTouches
		self.maximumNumberOfTouches = maximumNumberOfTouches
	}
	
	
	@MainActor @preconcurrency private var onEnd: ((Value) -> Void)?
	@MainActor @preconcurrency private var onChange: ((Value) -> Void)?

	
	func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
		let gesture = UIPanGestureRecognizer()
		gesture.maximumNumberOfTouches = maximumNumberOfTouches
		gesture.minimumNumberOfTouches = minimumNumberOfTouches
		return gesture
	}

	
	func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
				
		switch recognizer.state {
		case .began:
			context.coordinator.dragStart(context.converter.location(in: coordinateSpace))
			break
		case .changed:
			let location = context.converter.location(in: coordinateSpace)
			if !context.coordinator.shouldEnableGesture(to: location, minimumDistance: minimumDistance) {
				return
			}
			onChange?(Value(
				time: Date(),
				location: location,
				startLocation: context.coordinator.startLocation ?? .zero
			))
			break
		case .ended:
			defer {
				context.coordinator.dragEnd()
			}
			let location = context.converter.location(in: coordinateSpace)
			if !context.coordinator.shouldEnableGesture(to: location, minimumDistance: minimumDistance)  {
				return
			}
			onEnd?(Value(
				time: Date(),
				location: context.converter.location(in: coordinateSpace),
				startLocation: context.coordinator.startLocation ?? .zero
			))
			break
		default:
			break
		}
	}
	
	func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
		Coordinator()
	}
	
	
	final class Coordinator: NSObject {
		var startLocation: CGPoint?
		private var gestureSucceed: Bool = false
		
		func shouldEnableGesture(to point: CGPoint, minimumDistance: CGFloat) -> Bool {
			if gestureSucceed { return true }
			guard let startLocation else { return false }
			let distance =  abs(hypot(startLocation.x - point.x, startLocation.y - point.y))
			gestureSucceed = distance > minimumDistance
			return gestureSucceed
		}
		
		func dragStart(_ location: CGPoint) {
			self.startLocation = location
		}
		
		func dragEnd() {
			self.startLocation = nil
			gestureSucceed = false
			
		}
	}
	
}

#Preview {
    MultiFingerDrag()
}
