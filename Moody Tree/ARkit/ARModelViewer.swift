//
//  ARModelViewer.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/17.
//

import SwiftUI
import ARKit
import RealityKit

struct ARModelViewer: UIViewRepresentable {
    @Binding var model: String?
    func makeUIView(context: Context) -> ARView {
        print("makeUIView modelName:\(model)")
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = self.model{
            print("update modelName:\(modelName)")
            // Load the model into a ModelEntity
            guard let modelEntity = try? ModelEntity.loadModel(named: modelName + ".usdz") else {
                print("Failed to load model")
                return
            }
            
            if modelName == "fighting"{
                modelEntity.setScale(SIMD3<Float>(repeating: 0.1), relativeTo: nil)
                let position = SIMD3<Float>(0, -3, -6) // Adjust the position as needed
                let anchorEntity = AnchorEntity(world: position)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            }else if modelName == "happy" || modelName == "begin"{
                modelEntity.setScale(SIMD3<Float>(repeating: 0.008), relativeTo: nil)
                let position = SIMD3<Float>(0, -3, -6) // Adjust the position as needed
                let anchorEntity = AnchorEntity(world: position)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            }else{
                modelEntity.setScale(SIMD3<Float>(repeating: 0.015), relativeTo: nil)
                let position = SIMD3<Float>(0, -3, -6) // Adjust the position as needed
                let anchorEntity = AnchorEntity(world: position)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            }
        }
    }
}
