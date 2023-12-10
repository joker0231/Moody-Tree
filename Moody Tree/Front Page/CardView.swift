//
//  CardView.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

// CardView.swift

// CardView.swift

import SwiftUI
import CoreData

struct CardView: View {
    @State private var quote: Quote?
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [])
    var quotes: FetchedResults<Quote>
    let index = Calendar.current.component(.day, from: Date())
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd / yyyy.MM"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text(String(date.prefix(2)))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0, green: 0, blue: 0))
                Text(String(date.suffix(from: date.index(date.startIndex, offsetBy: 2))))
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0, green: 0, blue: 0))
            }
            Divider()
                .background(Color(red: 123 / 255, green: 139 / 255, blue: 111 / 255))
            HStack{
                Text(quote?.author ?? "--")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 123 / 255, green: 139 / 255, blue: 111 / 255))
                    .padding(.bottom, 2)
                Text(quote?.source ?? "--")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(Color(red: 123 / 255, green: 139 / 255, blue: 111 / 255))
                    .padding(.bottom, 2)
            }
            Text(quote?.content ?? "--")
                .font(.system(size: 16))
                .lineSpacing(3)
            HStack {
                Spacer()
                
                VStack {
                    Text("0")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .padding(.bottom, 1)

                    Text("今日已记录")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.black)
                }
                .padding(.horizontal,20)
                
                Divider()
                    .frame(height: 55)
                    .background(Color("7B8B6F"))

                VStack {
                    Text("开心")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .padding(.bottom, 1)

                    Text("今日情绪")
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.black)
                }
                .padding(.horizontal,20)
                
                Spacer()
            }
            .padding(.top,15)
            .padding(.bottom,25)
        }
        .padding(20)
        .background(Color(red: 246 / 255, green: 251 / 255, blue: 240 / 255))
        .cornerRadius(10)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .onAppear{
            if quotes.indices.contains(index-1) {
                quote = quotes[index-1]
            } else {
                // 如果数据库中不存在对应的数据，创建默认的 Quote 对象并返回
                let newQuote = Quote(context: managedObjectContext)
                newQuote.content = "你不需要这世界理解你，因为有的人永远不会理解他们没经历过的事情，要对有些理解你的人心怀感激。"
                newQuote.author = "马特·海格"
                newQuote.source = "《活下去的理由》"
                quote = newQuote
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
