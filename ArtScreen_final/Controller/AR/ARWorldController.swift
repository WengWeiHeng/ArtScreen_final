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
    
    //MARK: - Renderer Properties
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        guard let touchLocation = touches.first?.location(in: sceneView) else { return }
        guard let hitNode = sceneView.hitTest(touchLocation, options: nil).first?.node else { return }
        guard let nodeName = hitNode.name else { return }
        
        print("DEBUG: hit node position \(hitNode.name)")
        
        for index in 0..<artworks.count {
            if nodeName == "artworkNode\(index)" {
                
                let physicalWidth = artworks[index].width * 0.0008
                let physicalHeight = artworks[index].height * 0.0008
                let animatePlane = SCNPlane(width: CGFloat(physicalWidth), height: CGFloat(physicalHeight))
                
                DispatchQueue.main.async {
                    let controller = ARResultController()
                    controller.artwork = self.artworks[index]
                    animatePlane.firstMaterial?.diffuse.contents = controller.view
                    hitNode.geometry = animatePlane
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
        DispatchQueue.main.async { [self] in
            for index in 0..<self.artworks.count {
                let artworkWidth = CGFloat(self.artworks[index].width)
                let artworkHeight = CGFloat(self.artworks[index].height)
                let artworkBox = SCNBox(width: artworkWidth * 0.0008, height: artworkHeight * 0.0008, length: 0.01, chamferRadius: 0)

                let artworkNode = SCNNode()
                
                if index <= 4 {
                    artworkNode.position = SCNVector3Make(0.5, 0.3, 1 - (self.artworkDistance * Float(index)))
                    artworkNode.eulerAngles = SCNVector3(0, -Float.pi / 2, 0)
                    print("DEBUG: index: \(index)")
                    print("DEBUG: artworkNode position: \(artworkNode.position) <= 4")
                } else if index > 4 && index < 7{
                    
                    artworkNode.position = SCNVector3Make(0.2 - (self.artworkDistance * Float(index - 5)), 0.3, -0.65)
                    artworkNode.eulerAngles = SCNVector3(0, -Float.pi / 1, 0)
                    
                    print("DEBUG: index: \(index)")
                    print("DEBUG: artworkNode position: \(artworkNode.position) > 4")
                } else if index > 6 {
                    artworkNode.position = SCNVector3Make(-0.5, 0.3, -0.5 + (self.artworkDistance * Float(index - 7)))
                    artworkNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
                }
                
                
                let artworkMaterial = SCNMaterial()
                self.artworkImage = self.getImageByUrl(url: self.artworks[index].path)
                artworkMaterial.diffuse.contents = self.artworkImage

                artworkBox.firstMaterial = artworkMaterial
                artworkNode.geometry = artworkBox
                artworkNode.name = "artworkNode\(index)"
                artworkNode.renderingOrder = 200
                node.addChildNode(artworkNode)
            }
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
    
    //MARK: - Renderer Helper
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
    
    func configureGalleryNode(withNode node: SCNNode) {
        let galleryScene = SCNScene(named: "art.scnassets/gallery.scn")!
        if let galleryNode = galleryScene.rootNode.childNode(withName: "gallery", recursively: true) {
            if let camera = self.sceneView.pointOfView {
                let mat = camera.transform
                let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
                galleryNode.position = SCNVector3Make(camera.position.x, camera.position.y - 0.4, camera.position.z - 3)
                galleryNode.physicsBody?.applyForce(dir, asImpulse: true)
                node.addChildNode(galleryNode)
            }

            self.configureArtworkNode(withNode: galleryNode)
        }
    }
}

//MARK: - ARSCNViewDelegate
extension ARWorldController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let physicalWidth = planeAnchor.extent.x
                let physicalHeight = planeAnchor.extent.z
                
                let mainPlane = SCNPlane(width: CGFloat(physicalWidth), height: CGFloat(physicalHeight))
                mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
                
                let mainNode = SCNNode()
                mainNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                mainNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
                mainNode.name = "mainNode"
                node.addChildNode(mainNode)
                
                self.highlightDetection(on: mainNode, width: CGFloat(physicalWidth), height: CGFloat(physicalHeight)) {
                    self.configureGalleryNode(withNode: node)
                }
            }
        }
    }
}
