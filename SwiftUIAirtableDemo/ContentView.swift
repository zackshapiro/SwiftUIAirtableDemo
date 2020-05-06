//
//  ContentView.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.state.components, id: \.uniqueId) { uiComponent in
                    NavigationLink(destination: self.detailView) {
                        uiComponent.render()
                    }
                }
            }
        }.onReceive(timer) { _ in
            self.refreshContent()
        }
    }
    
    private var detailView: some View {
        DetailView()
            .environmentObject(state)
    }
    
    private func refreshContent() {
        AirtableService.fetchContent { result in
            DispatchQueue.main.async {
                result.mapError { error in
                    fatalError("We should fix something")
                }
                .map {
                    if self.state.content != $0 {
                        self.state.content = []
                        self.state.content = $0
                    }
                }
            }
        }
    }

    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// TODO: move these

// MARK: -

protocol UIComponent {
    var uniqueId: String { get }
    func render() -> AnyView
}

struct AirtableUIModel {
    let title: String
    let position: String
}

extension View {
 
    func toAny() -> AnyView {
        return AnyView(self)
    }
    
}

// MARK: -

struct HiComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        HiView(viewModel: viewModel).toAny()
    }
    
}

struct HiView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

struct ByeComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        ByeView(viewModel: viewModel).toAny()
    }
    
}

struct ByeView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

struct MiddleComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        MiddleView(viewModel: viewModel).toAny()
    }
    
}


struct MiddleView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text("I'm in the middle")
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

struct SettingsComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        SettingsView(viewModel: viewModel).toAny()
    }
    
}

struct SettingsView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text("Settings: ⚙️")
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

