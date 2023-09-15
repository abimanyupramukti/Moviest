//
//  RateView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 15/09/23.
//

import SwiftUI

struct RateView: View {
    let rate: String
    
    var body: some View {
        Text("\(rate) ⭐️")
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .font(.subheadline)
            .padding([.leading, .trailing], 4)
            .padding([.top, .bottom], 2)
            .background {
                Rectangle()
                    .fill(.black.opacity(0.7))
                    .cornerRadius(6)
                    .shadow(color: .white, radius: 4)
            }
            .padding(10)
    }
}

struct RateView_Previews: PreviewProvider {
    static var previews: some View {
        RateView(rate: "8.5")
    }
}
