//
//  ContentView.swift
//  MoodyTree watch Watch App
//
//  Created by 王雨晨 on 2023/12/14.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(
                    destination: MoodSelectionView(),
                    label: {
                        Text("记录心情")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                )
                Spacer()
            }
            
            .padding()
            .frame(width: watchWidth, height: watchHeight)
            .background(Color(red: 169/255, green: 196/255, blue: 148/255))
        }
    }

    var watchHeight: CGFloat {
        return WKInterfaceDevice.current().screenBounds.size.height
    }

    var watchWidth: CGFloat {
        return WKInterfaceDevice.current().screenBounds.size.width
    }
}


