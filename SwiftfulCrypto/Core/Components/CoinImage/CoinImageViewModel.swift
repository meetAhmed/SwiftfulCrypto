//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = true
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubcribers()
    }
    
    private func addSubcribers() {
        dataService.$image.sink { [weak self] _ in
            guard let self else { return }
            self.isLoading.toggle()
        } receiveValue: { [weak self] returnedImage in
            guard let self else { return }
            self.image = returnedImage
        }
        .store(in: &cancellables)
    }
}
