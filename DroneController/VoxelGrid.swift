//
//  VoxelGrid.swift
//  DroneController
//
//  Created by Samu András on 2019. 10. 14..
//  Copyright © 2019. Samu András. All rights reserved.
//

import Foundation
import SceneKit

class VoxelGrid {
    private let cols: Int = 6
    private let rows: Int = 6
    private let voxelSize: simd_float3 = [0.3,0.3,0.5]
    public var mid: simd_float3
    public var grid: [[VoxelElement]] = [[VoxelElement]]()
    public var gridNode: SCNNode?
    private let voxelNode:SCNNode
    var gridSize: simd_float3 {
        return [Float(cols)*voxelSize.x, Float(rows)*voxelSize.y, voxelSize.z]
    }
    
    var min: simd_float3 {
        return mid - (gridSize/2)
    }
    
    var max: simd_float3 {
        return mid + (gridSize/2)
    }
    
    init(mid: simd_float3) {
        self.mid = mid
        let box = SCNBox(width: CGFloat(voxelSize.x), height: CGFloat(voxelSize.y), length: CGFloat(voxelSize.z), chamferRadius: 0)
        self.voxelNode = SCNNode(geometry: box)
        for i in 0..<rows {
            var tempArray:[VoxelElement] = []
            for j in 0..<cols {
                tempArray.append(VoxelElement(mid: min + simd_float3(Float(j)*voxelSize.x, Float(i)*voxelSize.y, 0)))
            }
            grid.append(tempArray)
            tempArray.removeAll(keepingCapacity: true)
        }
    }
    
    func addPointToVoxel(point:simd_float3){
        if(point > min && point < max){
            let relativePos = point - min
            let (i,j) = getArrayPosition(relativePosition: relativePos)
            grid[i][j].points.append(point)
        }
    }
    
    func getArrayPosition(relativePosition: simd_float3) -> (i:Int, j:Int) {
        let i = Int(floor(relativePosition.x / voxelSize.x))
        let j = Int(floor(relativePosition.y / voxelSize.y))
        return (i,j)
    }
    
    func getDensity(){
        for i in 0..<rows {
            for j in 0..<rows {
                print("", self.grid[i][j].density, separator: " ", terminator:"")
            }
            print("\n")
        }
    }
    
    func clear() {
        for i in 0..<rows {
            for j in 0..<rows {
                self.grid[i][j].points.removeAll()
            }
        }
    }
    
    func getVoxelGridNode(){
        self.gridNode = SCNNode()
        gridNode?.simdPosition = self.mid
        updateVoxelGridNode()
    }
    
    func updateVoxelGridNode(){
        if let childs = self.gridNode?.childNodes {
            for node in childs {
                node.removeFromParentNode()
            }
        }
        for i in 0..<rows {
            for j in 0..<rows {
                let box = self.voxelNode.copy() as! SCNNode
                box.simdPosition = min + simd_float3(Float(j)*voxelSize.x, Float(i)*voxelSize.y, 0)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor(red: grid[i][j].density, green: 1-grid[i][j].density, blue: 0, alpha: 0.5)
                box.geometry!.materials = [material]
                gridNode?.addChildNode(box)
            }
        }
    }
}
