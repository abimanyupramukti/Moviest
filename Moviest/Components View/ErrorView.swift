//
//  ErrorView.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 15/09/23.
//

import SwiftUI

struct ErrorView: View {
    
    let errorMessage: String
    var onTapAction: (() -> Void)?
    
    init(errorMessage: String, onTapAction: (() -> Void)? = nil) {
        self.errorMessage = errorMessage
        self.onTapAction = onTapAction
    }
    
    var body: some View {
        VStack {
            Button {
                onTapAction?()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }

            Text(errorMessage)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.red)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: "invalid response")
    }
}
