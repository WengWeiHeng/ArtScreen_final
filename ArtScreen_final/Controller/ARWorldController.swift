//
//  ARWorldController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/6.
//

import UIKit
import SceneKit
import ARKit

class ARWorldController: UIViewController {
    
    //MARK: - Properties
    private var sceneView = ARSCNView()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, options: [SCNHitTestOption.searchMode: 1])
            
            if let hitResult = results.first {
                let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
                    boxNode.position = SCNVector3(hitResult.simdModelTransform.columns.3.x, hitResult.simdModelTransform.columns.3.y + 0.05, hitResult.simdModelTransform.columns.3.z)

                    sceneView.scene.rootNode.addChildNode(boxNode)
                    
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismissal))

        view.addSubview(sceneView)
        sceneView.addConstraintsToFillView(view)
        sceneView.delegate = self
    }
}

extension ARWorldController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            let gridMeterial = SCNMaterial()
            gridMeterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMeterial]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
}
