//
//  ViewController.swift
//  FloorIsLava
//
//  Created by Arielle Vaniderstine on 2017-06-06.
//  Copyright © 2017 Arielle Vaniderstine. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var server: DroneServer!
    let updateInterval: TimeInterval = 0.2
    var oldTime: TimeInterval = 0
    var pointCloud: Dictionary<UInt64, simd_float3> = [:]
    var voxelPoints = [simd_float3]()
    var voxelGrid: VoxelGrid!
    var orientation: UIInterfaceOrientation!
    var viewportsize: CGSize!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [.showFeaturePoints]
        let scene = SCNScene()
        sceneView.scene = scene
        server = DroneServer()
        voxelGrid = VoxelGrid(bounds: self.sceneView!.bounds.size)
        orientation = UIApplication.shared.statusBarOrientation
        viewportsize = self.sceneView.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    func updateVoxel(camera: ARCamera){
        if(voxelPoints.count > 3000) {
            voxelPoints = voxelPoints.suffix(3000)
        }
        voxelGrid.clear()
        for point in voxelPoints {
            let projectedPoint = camera.projectPoint(point, orientation: orientation, viewportSize: viewportsize)
            let voxelP = VoxelPoint(spacePoint: point, projectedPoint: projectedPoint)
//            voxelGrid.addPoint(point: voxelP)
        }
//        voxelGrid.printDensityMatrix()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        if (abs(time-oldTime) > updateInterval) {
            guard let frame = self.sceneView.session.currentFrame else { return }
            let transform = frame.camera.transform
            var newPoints: [Coordinate] = []
            if let rawFeaturePoints = frame.rawFeaturePoints {
                for i in 0..<rawFeaturePoints.points.count {
                    if pointCloud[rawFeaturePoints.identifiers[i]] == nil {
                        pointCloud[rawFeaturePoints.identifiers[i]] = rawFeaturePoints.points[i]
                        newPoints.append(Coordinate(position: rawFeaturePoints.points[i]))
                        voxelPoints.append(rawFeaturePoints.points[i])
                    }
                }
            }
//            updateVoxel(camera: frame.camera)
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            server.sendData(data: DataModel(coordinate: simd_float3(position), pointCloud: newPoints))
            oldTime = time
        }
    }
}
