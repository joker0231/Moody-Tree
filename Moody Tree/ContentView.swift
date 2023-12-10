//
//  ContentView.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import SwiftUI

enum TabItem: Hashable {
    case tab1, tab2, tab3
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var selectedTab: TabItem? = nil
    
    var body: some View {
        NavigationView{
            TabView() {
                // 树叶页面
                FrontPageView()
                    .frame(height:UIScreen.main.bounds.height)
                    .tabItem {
                        Image(systemName: "leaf.fill")
                    }
                    .tag(TabItem.tab1)
                
                // 日历页面
                CalendarView()
                    .frame(height:UIScreen.main.bounds.height - 150)
                    .tabItem {
                        Image(systemName: "calendar")
                    }
                    .tag(TabItem.tab2)
                
                // 个人页面
                ProfileView()
                    .padding(.bottom)
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                    .tag(TabItem.tab3)
            }
            .accentColor(Color(red: 132/255, green: 155/255, blue: 128/255))      // 设置 TabItem 的颜色
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
