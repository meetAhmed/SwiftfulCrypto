//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel?
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    private var coinSubcription: AnyCancellable?
    
    private func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
        coinSubcription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coinDetails in
                self?.coinDetails = coinDetails
                self?.coinSubcription?.cancel()
            })
    }
}
