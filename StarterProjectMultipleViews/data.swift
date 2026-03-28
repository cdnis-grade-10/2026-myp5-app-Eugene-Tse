//
//  data.swift
//  StarterProjectMultipleViews
//
//  Created by Eugene Tse on 13/3/2026.
//

import Foundation

struct WorkDataPoint: Identifiable {
    
    var id = UUID().uuidString
    var day: String
    var hours: Int
    var type: String = "Working Hours"
}
