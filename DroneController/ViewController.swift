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
    let updateInterval: TimeInterval = 1
    var oldTime: TimeInterval = 0
    var pointCloud: Dictionary<UInt64, simd_float3> = [:]
    var voxelGrid:VoxelGrid!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        server = DroneServer()
        voxelGrid = VoxelGrid(mid: [0,0,0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Tell the session to automatically detect horizontal planes
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func updateVoxel(mid: simd_float3){
        self.voxelGrid.clear()
        self.voxelGrid.mid = mid
        for point in pointCloud.values {
            self.voxelGrid.addPointToVoxel(point: point)
        }
        self.voxelGrid.getDensity()
//        self.voxelGrid.getVoxelGridNode()
//        if (!self.sceneView.scene.rootNode.childNodes.contains(self.voxelGrid.gridNode!)){
//            self.sceneView.scene.rootNode.addChildNode(self.voxelGrid.gridNode!)
//        }
    }
    


    // MARK: - ARSCNViewDelegate

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()

     return node
     }
     */

    // The following functions are automatically called when the ARSessionView adds, updates, and removes anchors
    
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
                    }
                }
            }
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            updateVoxel(mid: simd_float3(position) + [0,0,-0.5])
            server.sendData(data: DataModel(coordinate: Coordinate(position: simd_float3(position)), pointCloud: newPoints))
            oldTime = time
        }
        
    }


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
