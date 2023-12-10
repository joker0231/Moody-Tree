//
//  test.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/10.
//

import Foundation
import SwiftUI

struct item: View {
    let record: UserMood
    
    var body: some View{
        HStack{
            Text(record.title ?? "-")
            Text(record.descriptionText ?? "-")
            Text(record.mood ?? "-")
        }
    }
}

struct TestView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [])
    
    var records: FetchedResults<UserMood>
    var body: some View{
        List(records, id:\.self){
            item(record: $0)
        }
        .onAppear{
            print(records)
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
