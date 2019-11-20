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
    let updateInterval: TimeInterval = 0.05
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
//        createVoxelGridLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    func updateVoxel(camera: ARCamera){
        if(voxelPoints.count > 300) {
            voxelPoints = voxelPoints.suffix(200)
        }
        voxelGrid.clear()
        for point in voxelPoints {
            let projectedPoint = camera.projectPoint(point, orientation: orientation, viewportSize: viewportsize)
            let voxelP = VoxelPoint(spacePoint: point, projectedPoint: projectedPoint)
            voxelGrid.addPoint(point: voxelP)
        }
        DispatchQueue.main.async {
            self.updateVoxelColors()
        }
    }
    
    func createVoxelGridLayer() {
        for i in 0..<voxelGrid.rows {
            for j in 0..<voxelGrid.cols {
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(roundedRect: CGRect(x: CGFloat(j) * voxelGrid.voxelSize.width, y: CGFloat(i) * voxelGrid.voxelSize.height, width: voxelGrid.voxelSize.width, height: voxelGrid.voxelSize.height), cornerRadius: 0).cgPath
                layer.fillColor = CGColor(srgbRed: 0.1 * CGFloat(i), green: 0.1 * CGFloat(j), blue: 0, alpha: 0.3)
                layer.name = String(10*i+j)
                self.view.layer.addSublayer(layer)
            }
        }
    }
    
    func updateVoxelColors(){
        guard let sublayers = self.view.layer.sublayers else { return }
        for layer in sublayers {
            if let layerNumber = Int(layer.name!) {
                let j: Int = layerNumber % 10
                let i: Int = layerNumber / 10
                let normalisedDepth:CGFloat = CGFloat(voxelGrid.getDepthAt(i: j, j: i))
                print(normalisedDepth)
                let shapelayer = layer as! CAShapeLayer
                shapelayer.fillColor = CGColor(srgbRed: 1-normalisedDepth, green: normalisedDepth, blue: 0, alpha: 1-normalisedDepth)
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        if (abs(time-oldTime) > updateInterval) {
            guard let frame = self.sceneView.session.currentFrame else { return }
            let transform = frame.camera.transform
            var newPoints: [Coordinate] = []
//            if let rawFeaturePoints = frame.rawFeaturePoints {
//                for i in 0..<rawFeaturePoints.points.count {
//                    if pointCloud[rawFeaturePoints.identifiers[i]] == nil {
//                        pointCloud[rawFeaturePoints.identifiers[i]] = rawFeaturePoints.points[i]
//                        newPoints.append(Coordinate(position: rawFeaturePoints.points[i]))
//                        voxelPoints.append(rawFeaturePoints.points[i])
//                    }
//                }
//            }
//            updateVoxel(camera: frame.camera)
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
//            voxelGrid.setCurrentCameraPosition(position: simd_float3(position))
            let df = DateFormatter()
            df.dateFormat = "y-MM-dd H:m:ss.SSSS"
            let dateString = df.string(from: Date())
            server.sendData(data: DataModel(coordinate: simd_float3(position), timeStamp: dateString, pointCloud: newPoints))
            oldTime = time
        }
    }
}
