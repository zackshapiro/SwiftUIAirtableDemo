//
//  HiComponent+View.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

// MARK: - HiComponent

struct HiComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        HiView(viewModel: viewModel).toAny()
    }
    
}

// MARK: - HiView

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

// MARK: - HiView_Previews

struct HiView_Previews: PreviewProvider {
    
    static var previews: some View {
        HiView(viewModel: AirtableUIModel(title: "Hi", position: "1"))
    }
    
}
