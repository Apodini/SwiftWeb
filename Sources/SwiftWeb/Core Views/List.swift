//
//  List.swift
//  App
//
//  Created by Quirin Schweigert on 12.12.19.
//

import Foundation

//class List: View {
//    var body: View? = nil
//    var subviews: [View]
//    
//    init(@ListFunctionBuilder buildSubviews: () -> [View]) {
//        subviews = buildSubviews()
//    }
//    
//    init<Data>(_ data: Data, buildSubview: (Data.Element) -> View) where Data: RandomAccessCollection {
//        subviews = data.map(buildSubview)
//    }
//    
//    func renderHTML() -> String {
//        return """
//            <div class="list">
//                <div class=\"list-separator\"></div>
//                \(subviews.map({ $0.renderHTML() }).joined(separator: "<div class=\"list-separator\"></div>"))
//                <div class=\"list-separator\"></div>
//            </div>
//        """
//    }
//}
//
//@_functionBuilder
//class ListFunctionBuilder {
//    static func buildBlock(_ subComponents: View...) -> [View] {
//        return subComponents
//    }
//}
