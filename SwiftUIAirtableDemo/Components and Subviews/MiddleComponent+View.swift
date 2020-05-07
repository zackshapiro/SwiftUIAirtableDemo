//
//  MiddleComponent+View.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

// MARK: - MiddleComponent

struct MiddleComponent: UIComponent {
    
    var uniqueId: String
    
    var viewModel: AirtableUIModel
    
    func render() -> AnyView {
        MiddleView(viewModel: viewModel).toAny()
    }
    
}

// MARK: - MiddleView

struct MiddleView: View {
    
    var viewModel: AirtableUIModel

    var body: some View {
        HStack {
            Text(viewModel.title)
            Spacer()
            Text(viewModel.position)
        }
    }
    
}

// MARK: - MiddleView_Previews

struct MiddleView_Previews: PreviewProvider {
    
    static var previews: some View {
        MiddleView(viewModel: AirtableUIModel(title: "Everything, everything will be just fine", position: "3"))
    }
    
}
