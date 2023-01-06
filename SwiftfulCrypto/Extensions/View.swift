//
//  Copyright © Ahmed Ali. All rights reserved.
//

import SwiftUI

extension View {
    func animationWithoutValue(_ animation: Animation?) -> some View {
        self.animation(animation, value: UUID())
    }
}
