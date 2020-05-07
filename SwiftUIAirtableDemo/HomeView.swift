//
//  HomeView.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

/// A view that loads the `content` tab in our Airtable and displays it.
struct HomeView: View {
    
    // MARK: - Property Wrappers
    
    @EnvironmentObject var state: AppState
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.state.components, id: \.uniqueId) { uiComponent in
                    NavigationLink(destination: self.detailView) {
                        uiComponent.render()
                    }
                }
            }
            .navigationBarTitle("Airtable/SwiftUI Demo", displayMode: .inline)
        }.onReceive(timer) { _ in
            self.refreshContent()
        }
    }
    
    // MARK: - Private Properties
    
    private var detailView: some View {
        DetailView()
            .environmentObject(state)
    }
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    // MARK: - Private Functions
    
    private func refreshContent() {
        AirtableService.fetchContent { result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    fatalError("We should fix something, outside the scope of this demo")
                case let .success(content):
                    if self.state.content != content {
                        self.state.content = []
                        self.state.content = content
                    }
                }
            }
        }
    }
    
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
            .environmentObject(AppState())
    }
    
}
