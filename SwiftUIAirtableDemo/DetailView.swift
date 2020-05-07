//
//  DetailView.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

/// A view that loads the `tags` tab in our Airtable and displays it.
struct DetailView: View {
    
    // MARK: - Property Wrappers
    
    @EnvironmentObject var state: AppState
    
    @State private var option = 0
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Picker("", selection: $option) {
                ForEach(Category.allCases, id: \.self) {
                    Text($0.rawValue.capitalized).tag($0 == .fruit ? 0 : 1)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(20)
            
            List {
                ForEach(0..<tags.count, id: \.self) { i in
                    Text(self.tags[i].value)
                }
                .onDelete(perform: removeItems)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var tags: [Tag] {
        state.tags.filter {
            return self.option == 0
                ? $0.category == .fruit
                : $0.category == .vegetables
        }
    }
    
    // MARK: - Private Functions
    
    private func removeItems(at offset: IndexSet) {
        state.tags.remove(atOffsets: offset)
    }
    
}

// MARK: - DetailView_Previews

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailView()
    }
    
}
