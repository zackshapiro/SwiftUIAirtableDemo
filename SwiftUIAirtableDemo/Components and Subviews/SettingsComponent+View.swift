//
//  SettingsComponent+View.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

// MARK: - SettingsComponent

struct SettingsComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        SettingsView(viewModel: viewModel).toAny()
    }
    
}

// MARK: - SettingsView

struct SettingsView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

// MARK: - SettingsView_Previews

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: AirtableUIModel(title: "View Settings", position: "4"))
    }
}
