//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    
    init() {
        getCoins()
    }
    
    private var coinSubcription: AnyCancellable?
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        coinSubcription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] models in
                self?.allCoins = models
                self?.coinSubcription?.cancel()
            })
    }
}
