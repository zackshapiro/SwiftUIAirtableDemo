//
//  AppState.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI


final class AppState: ObservableObject {
    
    @Published var content: [Content] = [] {
        didSet {
            self.components = self.content.map { self.parseToUIComponent($0) }
        }
    }
    
    @Published var tags: [Tag] = []
    
    @Published var components: [UIComponent] = []
    
    // MARK: - Public Functions
    
    /// Inspired by: https://medium.com/better-programming/build-a-server-driven-ui-using-ui-components-in-swiftui-466ecca97290#ef62-ec4eacc8bdf2-reply
    func parseToUIComponent(_ content: Content) -> UIComponent {
        let component: UIComponent
        
        switch content.type {
        case .hi:
            component = HiComponent(uniqueId: content.id, viewModel: .init(title: content.title, position: content.position.description))
        case .bye:
            component = ByeComponent(uniqueId: content.id, viewModel: .init(title: content.title, position: content.position.description))
        case .middle:
            component = MiddleComponent(uniqueId: content.id, viewModel: .init(title: content.title, position: content.position.description))
        case .settings:
            component = SettingsComponent(uniqueId: content.id, viewModel: .init(title: content.title, position: content.position.description))
        }

        return component
    }
    
}
