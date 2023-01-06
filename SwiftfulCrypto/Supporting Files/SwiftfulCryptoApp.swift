//
//  Copyright © Ahmed Ali. All rights reserved.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    @State private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
