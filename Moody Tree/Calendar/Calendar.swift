//
//  Calendar.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/7.
//

import SwiftUI

struct CalendarItem: Identifiable {
    var id = UUID()
    var date: String
    var dayOfWeek: String
}

struct CalendarView: View {
    @State private var todayIndex: Int?
    @State private var position:Int = 0
    @State private var scrollOffset: CGFloat = 0

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                Button("跳转到今天") {
                    proxy.scrollTo(2, anchor: .center)
                }
                .padding(.bottom,0)
                .foregroundColor(Color("628C41"))
                .frame(maxWidth: .infinity, alignment: .top)
                
                ScrollView {
                    LazyVStack {
                        ForEach(-365..<365) { dayOffset in
                            let currentDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
                            let date = dateFormatter.string(from: currentDate)

                            HStack {
                                VStack(alignment: .center) {
                                    Text(date)
                                        .font(.system(size: 24))
                                    Text(currentDate.dayOfWeek() ?? "")
                                        .font(.system(size: 16))
                                }
                                .frame(width:35)
                                .padding(30)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        NoteView(style: .style1, text: "Note 1")
                                        NoteView(style: .style2, text: "Note 2")
                                        // ... 其他便条
                                    }
                                }
                            }
                            .id(dayOffset) // 使用 dayOffset 作为唯一标识
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(2, anchor: .center)
                    }
                }
            }
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
