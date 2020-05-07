//
//  View+Extensions.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

extension View {
 
    func toAny() -> AnyView {
        AnyView(self)
    }
    
}
