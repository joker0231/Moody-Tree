//
//  DataBlock.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/5.
//

import Foundation
import SwiftUI

struct DataBlock<AdditionalContent: View>: View {
    var title: String
    var detail: String
    var color: Color
    var additionalContent: (() -> AdditionalContent)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Color("7B8B6F"))
                .padding(.bottom, 5)

            Divider().frame(height: 1).background(Color("7B8B6F"))

            VStack(alignment: .leading) {
                Text(detail)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(color)
                    .padding(.top, 10)
                    .lineSpacing(3)

                additionalContent?()
            }
            .padding(.bottom, 10)
        }
        .padding(20)
        .cornerRadius(10)
        .background(Color.white.cornerRadius(10))
    }
}


struct DataBlock_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
