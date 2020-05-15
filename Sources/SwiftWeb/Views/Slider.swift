//
//  Slider.swift
//  SwiftWebServer
//
//  Created by Quirin Schweigert on 10.05.20.
//  Copyright © 2020 Quirin Schweigert. All rights reserved.
//

import Foundation
import SwiftWeb

struct Slider: View, ChangeInputEventResponder, GrowingAxesModifying {
    @Binding var value: Double
    
    func onChangeInputEvent(newValue: String) {
        value = Double(newValue) ?? 0
    }
    
    func modifiedGrowingLayoutAxes(forGrowingAxesOfSubnodes: Set<GrowingLayoutAxis>) -> Set<GrowingLayoutAxis> {
        [.horizontal]
    }
    
    func html(forHTMLOfSubnodes htmlOfSubnodes: [HTMLNode]) -> HTMLNode {
        let elementID: String = UUID().uuidString
        
        return .div {
            .raw("""
            <div id="slider-\(elementID)-container">
                <div id="slider-\(elementID)-track"></div>
                <div id="slider-\(elementID)-track-progress"></div>
                <input type="range" min="0" max="1" step="0.001" value="\(String(value))" id="slider-\(elementID)"
                    oninput="document.getElementById('slider-\(elementID)-track-progress').style.width = `calc(${this.value * 100}% - 12px)`"
                />
            </div>
            <style>
                #slider-\(elementID) {
                    position: absolute;
                    pointer-events: all;
                    width: 100%;
                    background: none;
                }

                #slider-\(elementID)::-webkit-slider-thumb {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 25px;
                    height: 25px;
                    border-radius: 50%;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
                    background: white;
                }

                #slider-\(elementID)-container {
                    position: relative;
                    width: 100%;
                    height: 25px;
                }

                #slider-\(elementID)-track {
                    position: absolute;
                    background-color: #E4E4E6;
                    height: 3px;
                    border-radius: 3px;
                    top: 13px;
                    left: 12px;
                    right: 12px;
                }

                #slider-\(elementID)-track-progress {
                    position: absolute;
                    background-color: #027AFF;
                    height: 3px;
                    border-radius: 3px;
                    top: 13px;
                    left: 12px;
                    width: calc(\(String(value * 100))% - 12px);
                }
            </style>
            """
            )
        }
    }
}
