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
    let size:simd_float2 = [30,30]
    var voxel: Voxel
    var points: [VoxelPoint]
    var density: Int {
        return points.count
    }
    
    init(mid: simd_float2){
        self.voxel = Voxel(mid: mid, size: self.size)
        self.points = []
    }
    
    init(min: simd_float2){
        self.voxel = Voxel(min: min, max: min+size)
        self.points = []
    }
    
    static func < (lhs: VoxelElement, rhs: VoxelElement) -> Bool {
        return lhs.density < rhs.density
    }
    
    static func == (lhs: VoxelElement, rhs: VoxelElement) -> Bool {
        return lhs.density == rhs.density
    }
}
