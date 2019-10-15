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
    
    func testVoxel(){
        let voxel = Voxel(mid: [2,2,2], size: [1,1,1])
        XCTAssertEqual(voxel.min, [1.5,1.5,1.5])
        XCTAssertEqual(voxel.max, [2.5,2.5,2.5])
        XCTAssertEqual(voxel.mid, [2,2,2])
    }
    
    func testVoxelElement(){
        var lhs = VoxelElement(mid: [0,0,0])
        lhs.points.append([1,2,3])
        var rhs = VoxelElement(mid: [0,0,1])
        rhs.points.append([1,2,3])
        rhs.points.append([3,4,3])
        XCTAssertTrue(lhs < rhs)
    }
    
    func testVoxelGrid(){
        let voxelGrid = VoxelGrid(mid: [1,1,1])
        let (i,j) = voxelGrid.getArrayPosition(relativePosition: [0.901,0.901,0.9])
        XCTAssertEqual(i,3)
        XCTAssertEqual(j,3)
        let p: simd_float3 =  [1,1,1]
        XCTAssertTrue(p > voxelGrid.min)
        XCTAssertTrue(p < voxelGrid.max)
        voxelGrid.addPointToVoxel(point:p)
        XCTAssertEqual(voxelGrid.grid[3][3].points.count, 1)
    }

}
