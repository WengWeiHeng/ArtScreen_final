//
//  ARCameraController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/2.
//

import UIKit
import ARKit

class ARCameraController: UIViewController {
    
    //MARK: - Properties
    private var sceneView = ARSCNView()
    let configuration = ARImageTrackingConfiguration()
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    
    var artworkImages = [UIImage]()
    var artworks = [ArtworkDetail]()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Cancel"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(handleDismissal))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        configureSceneView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add Images
        loadingStorageUrl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func loadingStorageUrl() {
        ArtworkService.shared.fetchArtwork { artworks in
            self.artworks = artworks
        
            DispatchQueue.main.async {
                for i in 0..<artworks.count {
                    let url = try? URL(resolvingAliasFileAt: self.artworks[i].path)
                    let data = try? Data(contentsOf: url!)
                    print("url = \(url)")
                    print("data = \(data)")
                    self.artworkImages.append(UIImage(data: data!)!)
                }
                
                print("DEBUG: artwork Image array is \(self.artworkImages.count)")
                self.configuration.trackingImages = self.loadedImagesFromDirectoryContents(self.artworkImages)
                print("DEBUG: artworksImages.count \(self.artworkImages.count)")
                self.sceneView.session.run(self.configuration)
            }
        }
    }
    
    func configureSceneView() {
        view.addSubview(sceneView)
        sceneView.addConstraintsToFillView(view)
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
         return cgImage
        }
        return nil
    }
    
    func loadDynamicImageReferences(_ str : String){
        guard let imageFromBundle = UIImage(named: str),
        let imageToCIImage = CIImage(image: imageFromBundle),
        let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
        arImage.name = str
        configuration.trackingImages = [arImage]
    }
    
    func loadDynamicImageReferences(_ image : UIImage){
        guard let imageToCIImage = CIImage(image: image),
        let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
//        arImage.name = str
        configuration.trackingImages = [arImage]
    }
    
    func loadedImagesFromDirectoryContents(_ images: [UIImage]) -> Set<ARReferenceImage>{
        var index = 0
        var customReferenceSet = Set<ARReferenceImage>()
        images.forEach { (image) in
            guard let imageToCIImage = CIImage(image: image),
            let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
            let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
            arImage.name = "MyCustomARImage\(index)"
            //4. Insert The Reference Image Into Our Set
            customReferenceSet.insert(arImage)
//            print("ARReference Image == \(arImage)")
            index += 1
        }
        return customReferenceSet

    }
    
    //MARK: - Image height light
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.mainDarkGray
        planeNode.opacity = 0
        
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
    }
    
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
}

extension ARCameraController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        updateQueue.async {
            let physicalWidth = imageAnchor.referenceImage.physicalSize.width
            let physicalHeight = imageAnchor.referenceImage.physicalSize.height
            let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
            mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
            
            let mainNode = SCNNode(geometry: mainPlane)
            mainNode.eulerAngles.x = -.pi / 2
            mainNode.renderingOrder = -1
            mainNode.opacity = 1
            
            node.addChildNode(mainNode)
            
            self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight) {
                
                let animatePlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                var index = -1
                for i in 0..<self.artworkImages.count {
                    index += 1
                    let tmp = "MyCustomARImage\(i)"
                    if tmp == imageAnchor.name {
                        break;
                    }
                }
                
                DispatchQueue.main.async {
                    let controller = ARResultController()
                    controller.artwork = self.artworks[index]
                    animatePlane.firstMaterial?.diffuse.contents = controller.view
                }
                
                let animateNode = SCNNode(geometry: animatePlane)
                animateNode.eulerAngles.x = -.pi / 2
                node.addChildNode(animateNode)
                node.runAction(.sequence([.wait(duration: 3)]))
            }
        }
    }
}
