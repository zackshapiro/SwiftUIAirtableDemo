//
//  ByeComponent+View.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

// MARK: - ByeComponent

struct ByeComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        ByeView(viewModel: viewModel).toAny()
    }
    
}

// MARK: - ByeView

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

// MARK: - ByeView_Previews

struct ByeView_Previews: PreviewProvider {
    
    static var previews: some View {
        ByeView(viewModel: AirtableUIModel(title: "Bye", position: "2"))
    }
    
}
