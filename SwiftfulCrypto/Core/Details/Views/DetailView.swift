//
//  Copyright © Ahmed Ali. All rights reserved.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State private var showFullDescription = false
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let columnsSpacing: CGFloat = 30
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
             
                VStack(spacing: 20) {
                    overview
                    
                    additionalDetails
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                    
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
        }
    }
}

extension DetailView {
    private var overview: some View {
        VStack {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            description
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: columnsSpacing,
                pinnedViews: []) {
                    ForEach(vm.overviewStatistics) { stat in
                        StatisticView(stat: stat)
                    }
                }
        }
    }
    
    private var additionalDetails: some View {
        VStack {
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            LazyVGrid(
                columns: columns,
                alignment: .leading,
                spacing: columnsSpacing,
                pinnedViews: []) {
                    ForEach(vm.additionalStatistics) { stat in
                        StatisticView(stat: stat)
                    }
                }
        }
    }
    
    private var description: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Show Less.." : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
