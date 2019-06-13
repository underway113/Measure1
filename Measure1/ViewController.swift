//
//  ViewController.swift
//  Measure1
//
//  Created by Jeremy Adam on 13/06/19.
//  Copyright © 2019 Underway. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotArr = [SCNNode()]
    var textNode = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotArr.count > 2 {
            for dot in dotArr {
                dot.removeFromParentNode()
            }
            dotArr = [SCNNode()]
        }
        if let touchLoc = touches.first?.location(in: sceneView) {
            let hitTestResuls = sceneView.hitTest(touchLoc, types: .featurePoint)
            
            if let hitResult = hitTestResuls.first {
                addDot(hitResult)
            }
            
        }
    }
    
    func addDot(_ hitResult:ARHitTestResult) {
        let dotGeo = SCNSphere(radius: 0.003)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        dotGeo.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeo)
        
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y, z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotArr.append(dotNode)
        
        if dotArr.count > 2 {
            calculate()
        }
        
    }
    
    
    func calculate() {
        let start = dotArr[0]
        let end = dotArr[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2 ) + pow(c, 2))
        
        updateText(String(format: "%.2f", distance), end.position)
        
    }
    
    func updateText(_ text:String, _ position:SCNVector3) {
        textNode.removeFromParentNode()
        
        let textGeo = SCNText(string: text + "m", extrusionDepth: 0.5)
        textGeo.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeo)
        textNode.position = SCNVector3(x: position.x, y: position.y, z: position.z)
        
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
}
