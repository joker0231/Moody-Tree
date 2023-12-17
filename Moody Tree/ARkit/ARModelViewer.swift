//
//  ARModelViewer.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/17.
//

import Foundation
import SwiftUI
import ARKit

struct ARModelViewer: UIViewControllerRepresentable {
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARModelViewer

        init(parent: ARModelViewer) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let planeNode = createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent)
                node.addChildNode(planeNode)

                if let modelURL = Bundle.main.url(forResource: parent.modelName, withExtension: "usdz") {
                    let modelNode = createModelNode(url: modelURL)
                    node.addChildNode(modelNode)
                }
            }
        }

        private func createPlaneNode(center: simd_float3, extent: simd_float3) -> SCNNode {
            let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(center)
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.opacity = 0.25
            return planeNode
        }

        private func createModelNode(url: URL) -> SCNNode {
            let referenceNode = SCNReferenceNode(url: url)
            referenceNode?.load()

            let wrapperNode = SCNNode()
            wrapperNode.addChildNode(referenceNode!)
            return wrapperNode
        }
    }

    let modelName: String

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.autoenablesDefaultLighting = true

        let scene = SCNScene()
        arView.scene = scene

        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = .horizontal
        arView.session.run(arConfiguration)

        viewController.view.addSubview(arView)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update code if needed
    }
}
