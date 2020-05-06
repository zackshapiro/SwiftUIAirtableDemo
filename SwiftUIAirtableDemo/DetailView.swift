//
//  DetailView.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/6/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var state: AppState
    @State var option = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $option) {
                ForEach(["Fruit", "Vegetables"], id: \.self) {
                    Text($0).tag($0 == "Fruit" ? 0 : 1)
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
    
    private var tags: [Tag] {
        state.tags.filter {
            return self.option == 0
                ? $0.category == .fruit
                : $0.category == .vegetables
        }
    }
    
    private func removeItems(at offset: IndexSet) {
        state.tags.remove(atOffsets: offset)
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
