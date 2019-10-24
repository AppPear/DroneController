//
//  Voxel.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 14..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

struct Voxel {
    var min: simd_float2 // lower left back corner
    var max: simd_float2 // upper right front corner
    var mid: simd_float2 {
        return (min + max) / 2
    }
    
    init(mid: simd_float2, size: simd_float2) {
        self.min = mid - (size/2)
        self.max = mid + (size/2)
    }
    
    init(min: simd_float2, max: simd_float2){
        self.min = min
        self.max = max
    }
}
