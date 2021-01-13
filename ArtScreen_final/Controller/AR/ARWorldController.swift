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
    var exhibition: ExhibitionDetail {
        didSet {
            fetchArtwork()
        }
    }
    var artworks = [ArtworkDetail]()
    var artworkDistance: Float = -0.138
    
    //MARK: - Init
    init(exhibition: ExhibitionDetail) {
        self.exhibition = exhibition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            let raycast = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any)
            
            if let hitResult = sceneView.session.raycast(raycast!).first {
                let boxScene = SCNScene(named: "art.scnassets/gallery.scn")!
                if let boxNode = boxScene.rootNode.childNode(withName: "gallery", recursively: true) {
                    
                    
                    boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.15, hitResult.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }
    
    //MARK: - API
    func fetchArtwork() {
        ArtworkService.shared.fetchExhibitionArtwork(forExhibitionID: exhibition.exhibitionID) { (artworks) in
            DispatchQueue.main.async {
                self.artworks = artworks
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
    
    func configureArtworkNode(withNode node: SCNNode) {
        let artworkPlane = SCNPlane(width: 0.25, height: 0.25)
        let artworkNode = SCNNode()
        artworkNode.position = SCNVector3(0, 0, 0)
        artworkNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let artworkMaterial = SCNMaterial()
        artworkMaterial.diffuse.contents = UIImage()
        artworkPlane.materials = [artworkMaterial]
        artworkNode.geometry = artworkPlane
        node.addChildNode(artworkNode)
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
