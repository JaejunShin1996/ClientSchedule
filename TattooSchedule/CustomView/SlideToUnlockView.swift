//
//  SlideToUnlockView.swift
//  TattooSchedule
//
//  Created by Jaejun Shin on 12/11/2022.
//

import SwiftUI

struct SlideToUnlockView: View {
    @Binding var isLocked: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))

                Text(
                    isLocked ? "Slide to edit" : "Slide to save")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)

                DraggingComponent(isLocked: $isLocked, maxWidth: geometry.size.width * 0.666)
            }
            .frame(width: geometry.size.width * 0.666)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .padding(.vertical)
    }
}

struct DraggingComponent: View {
    @Binding var isLocked: Bool
    let maxWidth: CGFloat

    private let minWidth = CGFloat(50)
    @State private var width = CGFloat(50)

    var saveAction: () = ()

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isLocked ? Color.blue.opacity(0.4) : Color.green.opacity(0.4))
            .frame(width: width)
            .overlay(
                ZStack {
                    image(name: "arrow.right", isShown: isLocked)
                    image(name: "arrow.left", isShown: !isLocked)
                },
                alignment: .trailing
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isLocked {
                            if value.translation.width > 0 {
                                width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                            }
                        } else {
                            width = max(min(value.translation.width + maxWidth, maxWidth), minWidth)
                        }
                    }
                    .onEnded {_ in
                        if isLocked {
                            if width < maxWidth {
                                width = minWidth
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            } else {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                withAnimation(.spring()) {
                                    isLocked.toggle()
                                }
                            }
                        } else {
                            if width > minWidth {
                                width = maxWidth
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            } else {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                withAnimation(.spring()) {
                                    isLocked.toggle()
                                }
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0), value: width)
    }

    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
          .font(.title)
          .foregroundColor(isLocked ? Color.blue : Color.green)
          .frame(width: 42, height: 42)
          .background(RoundedRectangle(cornerRadius: 14).fill(.white))
          .padding(4)
          .opacity(isShown ? 1 : 0)
          .scaleEffect(isShown ? 1 : 0.01)
      }

}

struct SlideToUnlockView_Previews: PreviewProvider {
    static let exampleAction = {}

    static var previews: some View {
        SlideToUnlockView(isLocked: .constant(true))
    }
}
