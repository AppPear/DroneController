//
//  DataModel.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 10..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

struct Coordinate: Encodable {
    var position: simd_float3
}

struct DataModel: Encodable {
    var coordinate: simd_float3
    var pointCloud: [Coordinate]
}

extension SCNVector3: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.x)
        try container.encode(self.y)
        try container.encode(self.z)
    }
}
