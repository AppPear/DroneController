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
    var min: simd_float3 // lower left back corner
    var max: simd_float3 // upper right front corner
    var mid: simd_float3 {
        return (min + max) / 2
    }
    
    init(mid: simd_float3, size: simd_float3) {
        self.min = mid - (size/2)
        self.max = mid + (size/2)
    }
    
    init(min: simd_float3, max: simd_float3){
        self.min = min
        self.max = max
    }
}
