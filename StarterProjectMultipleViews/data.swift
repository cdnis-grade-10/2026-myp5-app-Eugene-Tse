//
//  data.swift
//  StarterProjectMultipleViews
//
//  Created by Eugene Tse on 13/3/2026.
//

import Foundation

struct SleepDataPoint: Identifiable {
    
    var id = UUID().uuidString
    var day: String
    var hours: Int
}
