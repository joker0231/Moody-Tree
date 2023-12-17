//
//  ModelViewer.swift
//  Moody Tree
//
//  Created by 王雨晨 on 2023/12/17.
//

import Foundation
import SwiftUI
import SceneKit

struct ModelViewer: UIViewRepresentable {
    let modelName: String

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()

        if let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") {
            let referenceNode = SCNReferenceNode(url: modelURL)
            referenceNode?.load()

            let wrapperNode = SCNNode()
            wrapperNode.addChildNode(referenceNode!)
            sceneView.scene?.rootNode.addChildNode(wrapperNode)

            sceneView.allowsCameraControl = true
            sceneView.autoenablesDefaultLighting = true

            // Set the background color of the SCNView to clear (transparent)
            sceneView.backgroundColor = UIColor.clear
        }

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update code if needed
    }
}

