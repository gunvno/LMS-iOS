//
//  HomeView.swift
//  FirstApp
//
//  Created by Tạ Văn Long on 9/10/26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.welcomeMessage)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
