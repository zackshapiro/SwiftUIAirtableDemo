//
//  UIComponent.swift
//  SwiftUIAirtableDemo
//
//  Created by Zack Shapiro on 5/7/20.
//  Copyright © 2020 Zack Shapiro. All rights reserved.
//

import SwiftUI

/// This is a simple example protocol that our `Component`s conform to. The `uniqueId` is an Airtable row ID
/// and the `render` function ultimately returns the `View` type for that Airtable data.
/// See the files in the `Components and Subviews` folder for implementation
protocol UIComponent {
    
    var uniqueId: String { get }
    func render() -> AnyView
    
}
