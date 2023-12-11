//
//  Note.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/8.
//

import Foundation
import SwiftUI

enum NoteStyle {
    case mood, note

    var topColor: Color {
        switch self {
        case .mood:
            return Color(hex: "FBEAD3")
        case .note:
            return Color(hex: "A9C494")
        }
    }

    var bottomColor: Color {
        switch self {
        case .mood:
            return Color(hex: "FDF9EE")
        case .note:
            return Color(hex: "E8ECE7")
        }
    }
}

struct NoteView: View {
    var style: NoteStyle
    var title: String
    var emotionDescription: String?
    var date: Date
    var description: String
    var images: [Data]?
    var id: UUID

    var body: some View {
        NavigationLink(destination: RecordPreviewView(
            date: date,
            emotionDescription: emotionDescription,
            title: title,
            description: description,
            images: images,
            id: id,
            style: style
        )) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(style.topColor)
                    .frame(height: 25)
                    .cornerRadius(10, corners: [.topLeft, .topRight])

                Rectangle()
                    .fill(style.bottomColor)
                    .frame(height: 75)
                    .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    .overlay(
                        Text(title)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .padding(8)
                    )
            }
            .frame(width: 90, height: 100)
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 10) {
//            NoteView(style: .style1, title: "Note 1")
//        }
//        .padding()
//    }
//}
