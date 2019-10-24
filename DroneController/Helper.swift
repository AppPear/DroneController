//
//  Helper.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 14..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

extension simd_float3: Comparable {
    public static func < (lhs: simd_float3, rhs: simd_float3) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    public static func == (lhs: simd_float3, rhs: simd_float3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension simd_float2: Comparable {
    public static func < (lhs: simd_float2, rhs: simd_float2) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    public static func == (lhs: simd_float2, rhs: simd_float2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
