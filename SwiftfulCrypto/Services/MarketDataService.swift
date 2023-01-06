//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import Foundation

class MarketDataService {
    @Published var marketData: MarketDataModel?
    
    init() {
        getData()
    }
    
    private var marketSubcription: AnyCancellable?
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        marketSubcription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedData in
                self?.marketData = returnedData.data
                self?.marketSubcription?.cancel()
            })
    }
}
