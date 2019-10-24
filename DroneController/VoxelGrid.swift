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
    var bounds: CGSize
    let voxelSize: CGSize = CGSize(width: 30, height: 30)
    
    var rows: Int {
        return Int(floor(bounds.height/voxelSize.height))
    }
    var cols: Int {
        return Int(floor(bounds.width/voxelSize.width))
    }
    var min: CGPoint = .zero
    var max:CGPoint {
        return CGPoint(x: voxelSize.width, y: voxelSize.height)
    }
    public var grid = [[VoxelElement]]()
    
    init (bounds: CGSize) {
        self.bounds = bounds
        for i in 0..<rows{
            var tempArray = [VoxelElement]()
            for j in 0..<cols{
                tempArray.append(VoxelElement(min:[Float(j)*Float(voxelSize.width), Float(i)*Float(voxelSize.height)]))
            }
            grid.append(tempArray)
        }
    }
    
    func clear(){
        for i in 0..<rows{
            for j in 0..<cols{
                grid[i][j].points.removeAll()
            }
        }
    }
    
    func addPoint(point: VoxelPoint) {
        if (point.projectedPoint > min && point.projectedPoint < max) {
            let i = Swift.max(0,Swift.min(cols-1,Int(floor(point.projectedPoint.x/voxelSize.width))))
            let j = Swift.max(0,Swift.min(rows-1,Int(floor(point.projectedPoint.y/voxelSize.height))))
            grid[j][i].points.append(point)
        }
    }
    
    func printDensityMatrix(){
        for i in 0..<rows{
            for j in 0..<cols{
                print(grid[i][j].density," ", terminator: "")
            }
            print("\n")
        }
    }
}
