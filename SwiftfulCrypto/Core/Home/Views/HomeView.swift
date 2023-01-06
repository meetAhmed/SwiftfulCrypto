//
//  Copyright © Ahmed Ali. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio = false
    @State private var showPortfolioView = false
    @State private var showDetailView = false
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            // Content layer
            VStack {
                header
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchedText: $vm.searchedText)
                
                columnTitles
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                } else {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $vm.selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() }
            )
        )
    }
}

extension HomeView {
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animationWithoutValue(.none)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.coins) { coin in
                CoinRowView(coin: coin)
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle() )
    }
    
    private func segue(coin: CoinModel) {
        vm.selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
            }
        }
        .listStyle(PlainListStyle() )
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            if showPortfolio {
                Text("Holding")
            }
            
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
