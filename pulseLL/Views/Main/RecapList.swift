//
//  RunList.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 12.07.24.
//

import SwiftUI

struct RecapList: View {
    var body: some View {
        List(recaps){recap in
            WorkoutCardHolderView(recap: recap)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RecapList()
}
