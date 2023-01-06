//
//  Copyright © Ahmed Ali. All rights reserved.
//

import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage?
    
    private let coin: CoinModel
    private var imageSubcription: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private let coinFolder = "coins_images"
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: coinFolder) {
            image = savedImage
        } else {
            downloadCoinImage(urlString: coin.image)
        }
    }
    
    private func downloadCoinImage(urlString: String) {
        guard let url = URL(string: urlString)
        else { return }
        
        imageSubcription = NetworkingManager.download(url: url)
            .tryMap { data -> UIImage? in
                UIImage(data: data)
            }
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self else { return }
                self.image = returnedImage
                self.imageSubcription?.cancel()
                self.fileManager.saveImage(image: returnedImage, imageName: self.coin.id, folderName: self.coinFolder)
            })
    }
}
