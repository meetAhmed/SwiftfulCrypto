//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var coins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistics: [StatisticModel] = []
    @Published var searchedText = ""
    var selectedCoin: CoinModel?
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubcribers()
    }
    
    func addSubcribers() {
        $searchedText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, startingCoins) -> [CoinModel] in
                guard !text.isEmpty else {
                    return startingCoins
                }
                let lowercasedText = text.lowercased()
                return startingCoins.filter {
                    $0.name.lowercased().contains(lowercasedText) ||
                    $0.symbol.lowercased().contains(lowercasedText) ||
                    $0.id.lowercased().contains(lowercasedText)
                }
            }
            .sink { [weak self] returnedCoins in
                guard let self else { return }
                self.coins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map { marketData -> [StatisticModel] in
                var statistics: [StatisticModel] = []
                guard let marketData else { return statistics }
                let marketCap = StatisticModel(title: "Market Cap", value: marketData.marketCap, percentageChange: marketData.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: marketData.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: marketData.btcDominance)
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                
                statistics.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                
                return statistics
            }
            .sink { [weak self] models in
                guard let self else { return }
                self.statistics = models
            }
            .store(in: &cancellables)
    }
}
