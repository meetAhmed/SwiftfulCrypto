//
//  Copyright © Ahmed Ali. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchedText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchedText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            
            TextField("Search by name or symbol...", text: $searchedText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchedText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchedText = ""
                            UIApplication.shared.endEditing()
                        },
                    alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10,
                    x: 0,
                    y: 0
                )
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchedText: .constant(""))
    }
}
