//
//  DroneControllerTests.swift
//  DroneControllerTests
//
//  Created by Samu András on 2019. 10. 09..
//  Copyright © 2019. Samu András. All rights reserved.
//

import XCTest
import SceneKit
@testable import DroneController

class DroneControllerTests: XCTestCase {

    func testFloat3Comparable() {
        let lhs: simd_float3 = [0,0,0]
        let rhs: simd_float3 = [1,1,1]
        let isSmaller = lhs < rhs
        XCTAssertTrue(isSmaller)
    }
    
    func testCGPointComparable() {
          let lhs: CGPoint = CGPoint(x: 0, y: 0)
          let rhs: CGPoint = CGPoint(x: 78, y: 7)
          let isSmaller = lhs < rhs
          XCTAssertTrue(isSmaller)
      }
    
    
    
//    func testVoxel(){
//        let voxel = Voxel(mid: [45,45], size: [30,30])
//        XCTAssertEqual(voxel.min, [30,30])
//        XCTAssertEqual(voxel.max, [60,60])
//        XCTAssertEqual(voxel.mid, [45,45])
//    }
    
//    func testVoxelElement(){
//        var lhs = VoxelElement(mid: [0,0])
//        lhs.points.append(VoxelPoint(spacePoint: [1,1,1], projectedPoint: [1,2]))
//        var rhs = VoxelElement(mid: [0,1])
//        rhs.points.append(VoxelPoint(spacePoint: [1,1,1], projectedPoint: [1,2]))
//        rhs.points.append(VoxelPoint(spacePoint: [1,1,1], projectedPoint: [1,2]))
//        XCTAssertTrue(lhs < rhs)
//    }
//
//    func testVoxelGrid(){
//        let voxelGrid = VoxelGrid(bounds: CGSize(width: 180, height: 90))
//        XCTAssertEqual(voxelGrid.rows, 3)
//        XCTAssertEqual(voxelGrid.cols, 6)
//        let p = VoxelPoint(spacePoint: [12,34,54], projectedPoint: [64,33])
//        voxelGrid.addPoint(point: p)
//        XCTAssertEqual(voxelGrid.grid[1][2].points.count, 1)
//        voxelGrid.printDensityMatrix()
//    }

}
