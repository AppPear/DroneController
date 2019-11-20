//
//  VoxelPoint.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 15..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

struct VoxelPoint {
    var spacePoint: simd_float3
    var projectedPoint: CGPoint
}

extension CGPoint: Comparable {
    public static func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
           return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
