//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String?
    @Published var websiteUrl: String?
    @Published var redditUrl: String?
    
    init(coin: CoinModel) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map { [weak self] (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
                guard let self else { return ([], []) }
                self.coinDescription = coinDetailModel?.readableDescription
                self.websiteUrl = coinDetailModel?.links?.homepage?.first
                self.redditUrl = coinDetailModel?.links?.subredditURL
                
                // overview
                let price = coinModel.currentPrice.asCurrency
                let pricePercentChange = coinModel.priceChangePercentage24H
                let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
                
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                let marketCapPercentChange = coinModel.marketCapChangePercentage24H
                let marketCapStat = StatisticModel(title: "Market Captilization", value: marketCap, percentageChange: marketCapPercentChange)
                
                let rank = "\(coinModel.rank)"
                let rankStat = StatisticModel(title: "Rank", value: rank)
                
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = StatisticModel(title: "Volume", value: volume)
                
                let overviewStatistics: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
                
                // additional
                let high = coinModel.high24H?.asCurrency ?? "n/a"
                let highStat = StatisticModel(title: "24 High", value: high)
                
                let low = coinModel.low24H?.asCurrency ?? "n/a"
                let lowStat = StatisticModel(title: "24 Low", value: low)
                
                let priceChange = coinModel.priceChange24H?.asCurrency ?? "n/a"
                let pricePercentChange2 = coinModel.priceChangePercentage24HInCurrency
                let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
                
                let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
                let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
                
                let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
                
                let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
                
                let additionalStatistics: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
                
                return (overviewStatistics, additionalStatistics)
            }.sink { returnedData in
                self.overviewStatistics = returnedData.overview
                self.additionalStatistics = returnedData.additional
            }
            .store(in: &cancellables)
    }
}
