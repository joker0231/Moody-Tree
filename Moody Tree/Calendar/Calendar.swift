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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [])
    var moodRecord: FetchedResults<UserMood>
    @FetchRequest(sortDescriptors: [])
    var noteRecord: FetchedResults<UserNote>

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                Button("跳转到今天") {
                    proxy.scrollTo(2, anchor: .center)
                }
                .padding(.top,15)
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
                                        .font(.system(size: 20))
                                    Text(currentDate.dayOfWeek() ?? "")
                                        .font(.system(size: 16))
                                }
                                .frame(width:55)
                                .padding(25)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        // 过滤出当前日期对应的 moodRecord 数据
                                        let filteredMoods = moodRecord.filter { mood in
                                            if let timestamp = mood.timestamp {
                                                let utcTimestamp = timestamp.addingTimeInterval(-TimeInterval(TimeZone(identifier: "Asia/Shanghai")!.secondsFromGMT(for: timestamp)))
                                                
                                                // 判断日期是否相同
                                                return Calendar.current.isDate(utcTimestamp, inSameDayAs: currentDate)
                                            }
                                            return false
                                        }
                                        ForEach(filteredMoods) { mood in
                                            // 创建并显示每一条 UserMood 数据的视图
                                            let imageDatas = mood.images as? [Data] ?? []
                                            NoteView(style: .mood, title: mood.title!, emotionDescription: mood.mood!, date: mood.timestamp!, description:mood.descriptionText!, images: imageDatas,id: mood.id!)
                                        }
                                        let filteredNotes = noteRecord.filter { note in
                                            if let timestamp = note.timestamp {
                                                let utcTimestamp = timestamp.addingTimeInterval(-TimeInterval(TimeZone(identifier: "Asia/Shanghai")!.secondsFromGMT(for: timestamp)))
                                                
                                                // 判断日期是否相同
                                                return Calendar.current.isDate(utcTimestamp, inSameDayAs: currentDate)
                                            }
                                            return false
                                        }
                                        ForEach(filteredNotes) { note in
                                            // 创建并显示每一条 UserMood 数据的视图
                                            let imageDatas = note.images as? [Data] ?? []
                                            NoteView(style: .note, title: note.title!,date: note.timestamp! ,description:note.descriptionText!, images: imageDatas, id: note.id!)
                                        }
                                    }
                                }
                            }
                            .id(dayOffset) // 使用 dayOffset 作为唯一标识
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.trailing,10)
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
