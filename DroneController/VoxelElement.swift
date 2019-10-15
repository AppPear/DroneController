//
//  VoxelElement.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 14..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

struct VoxelElement: Comparable {
    let size:simd_float3 = [0.3,0.3,0.5]
    var voxel: Voxel
    var points: [simd_float3]
    var density: CGFloat {
        return CGFloat(points.count)
//        return points.count == 0 ? 0.0 : min(1,30.0/CGFloat(points.count))
    }
    
    init(mid: simd_float3){
        self.voxel = Voxel(mid: mid, size: self.size)
        self.points = []
    }
    
    static func < (lhs: VoxelElement, rhs: VoxelElement) -> Bool {
        return lhs.density < rhs.density
    }
    
    static func == (lhs: VoxelElement, rhs: VoxelElement) -> Bool {
        return lhs.density == rhs.density
    }
}
