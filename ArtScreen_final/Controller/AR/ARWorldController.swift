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
    var exhibition: ExhibitionDetail
    var artworks = [ArtworkDetail]()
    var artworkDistance: Float = 0.375
    var artworkImage = UIImage()
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
    //MARK: - Init
    init(exhibition: ExhibitionDetail) {
        self.exhibition = exhibition
        super.init(nibName: nil, bundle: nil)
        
        fetchArtwork()
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
        guard let location = touches.first?.location(in: sceneView) else { return }
        
        let raycast = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any)
        if let hitResult = sceneView.session.raycast(raycast!).first {
            let boxScene = SCNScene(named: "art.scnassets/gallery.scn")!
            if let boxNode = boxScene.rootNode.childNode(withName: "gallery", recursively: true) {
                let nodeX = hitResult.worldTransform.columns.3.x
                let nodeY = hitResult.worldTransform.columns.3.y
                let nodeZ = hitResult.worldTransform.columns.3.z

                boxNode.position = SCNVector3(nodeX, nodeY + 0.15, nodeZ)
                sceneView.scene.rootNode.addChildNode(boxNode)

                configureArtworkNode(withNode: boxNode)
                
                let nodes = boxNode.childNodes
                for index in 0..<nodes.count {
                    let nodeName = nodes[index].name
                    
                    if nodeName == "artworkNode0" {
                        print("DEBUG: artworkNode0")
                    }
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
        for index in 0..<artworks.count {
            let artworkWidth = CGFloat(artworks[index].width)
            let artworkHeight = CGFloat(artworks[index].height)
            let artworkBox = SCNBox(width: artworkWidth * 0.0008, height: artworkHeight * 0.0008, length: 0.01, chamferRadius: 0)

            let artworkNode = SCNNode()
            artworkNode.position = SCNVector3Make(0.5, 0.3, 1 - (artworkDistance * Float(index)))
            artworkNode.eulerAngles = SCNVector3(0, -Float.pi / 2, 0)
            
            let artworkMaterial = SCNMaterial()
            artworkImage = getImageByUrl(url: artworks[index].path)
            artworkMaterial.diffuse.contents = artworkImage

            artworkBox.firstMaterial = artworkMaterial
            artworkNode.geometry = artworkBox
            artworkNode.name = "artworkNode\(index)"
            node.addChildNode(artworkNode)
        }
    }
    
    func getImageByUrl(url: URL) -> UIImage {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        planeNode.position.z += 0.1
        planeNode.opacity = 0
        
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
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
