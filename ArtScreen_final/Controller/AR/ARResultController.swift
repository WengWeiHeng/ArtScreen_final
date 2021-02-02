//
//  ARResultController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/3.
//

import UIKit

class ARResultController: UIViewController {
    
    //MARK: - Properties
    var artwork: ArtworkDetail? {
        didSet {
            configureArtworkData()
            fetchArtworkItem()
        }
    }
    
    var artworkItem: ArtworkItem? {
        didSet {
            configureArtworkItemData()
        }
    }
    
    var circleWidth: CGFloat!
    var circleHeight: CGFloat!
    var trimImageView = UIImageView()
    
    var originImageView: UIImageView = {
        let iv = UIImageView()
        
        let iv2 = UIImageView()
        iv.addSubview(iv2)
        return iv
    }()
    
    // Emitter animate
    lazy var particleImage: UIImage = {
        let imageSize = CGSize(width: circleWidth, height: circleHeight)
        let margin: CGFloat = 0
        let circleSize = CGSize(width: imageSize.width - margin * 2, height: imageSize.height - margin * 2)
        UIGraphicsBeginImageContext(imageSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.white.cgColor)
            context.fillEllipse(in: CGRect(origin: CGPoint(x: margin, y: margin), size: circleSize))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return image!
    }()
    /// Emitter cells and layer
    var cells = [CAEmitterCell]()
    var emitter = CAEmitterLayer()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDarkGray
        view.addSubview(originImageView)
        originImageView.frame = view.frame
        originImageView.alpha = 0.75
        
        view.addSubview(trimImageView)
    }
    
    //MARK: - API
    func fetchArtworkItem() {
        guard let artwork = artwork else { return }
        
        ArtworkItemService.shared.fetchArtworkItem(artwork: artwork) { artworkItem in
            self.artworkItem = artworkItem
            print("DEBUG: ArtworkItem in Result: \(artworkItem)")
        }
    }
    
    //MARK: - Helpers
    func configureArtworkData() {
        guard let artwork = artwork else { return }
        originImageView.sd_setImage(with: artwork.path)
    }
    
    func configureArtworkItemData() {
        guard let artworkItem = artworkItem else { return }
        guard let artwork = artwork else { return }
        
        DispatchQueue.main.async {
            let widthOriginal = CGFloat(artwork.width)
            let heightOriginal = CGFloat(artwork.height)
            let scaleX = self.view.frame.size.width / widthOriginal
            let scaleY = self.view.frame.size.height / heightOriginal
            let minX = CGFloat(artworkItem.x) * scaleX
            let minY = CGFloat(artworkItem.y) * scaleY
            let widthtrimImageView = CGFloat(artworkItem.width) * scaleX
            let heighttrimImageView = CGFloat(artworkItem.height) * scaleY
            self.trimImageView.frame = CGRect(x: minX, y: minY, width: widthtrimImageView, height: heighttrimImageView)
    //        particleImage.size = CGSize(width: 10, height: 10)
            
            self.trimImageView.sd_setImage(with: artworkItem.path)
            let rotateFrom = CGFloat(artworkItem.rotateFrom)
            let rotateTo = CGFloat(artworkItem.rotateTo)
            let rotateSpeed = CFTimeInterval(CGFloat(artworkItem.rotateSpeed))

            let scaleFrom = CGFloat(artworkItem.scaleFrom)
            let scaleTo = CGFloat(artworkItem.scaleTo)
            let scaleSpeed = CFTimeInterval(CGFloat(artworkItem.scaleSpeed))

            let opacityFrom = CGFloat(artworkItem.opacityFrom)
            let opacityto = CGFloat(artworkItem.opacityTo)
            let opacitySpeed = CFTimeInterval(CGFloat(artworkItem.opacitySpeed))
            
            AnimateUtilities().allAction(view: self.trimImageView, rotateFrom: rotateFrom, rotateTo: rotateTo, rotateDuration: rotateSpeed, scaleFrom: scaleFrom, scaleTo: scaleTo, scaleDuration: scaleSpeed, autoreverses: true, opacityFrom: opacityFrom, opacityto: opacityto, opacityDuration: opacitySpeed)
            
            let size = CGFloat(artworkItem.emitterSize) * scaleY
            let speed = CGFloat(artworkItem.emitterSpeed)
            let red = CGFloat(artworkItem.emitterRed)
            let green = CGFloat(artworkItem.emitterGreen)
            let blue = CGFloat(artworkItem.emitterBlue)
            self.circleWidth = 5 * scaleX
            self.circleHeight = 5 * scaleY
            
            self.setEmitter(size: size, speed: speed, red: red, green: green, blue: blue)
        }
    }
    
    func setEmitter(size: CGFloat, speed: CGFloat, red: CGFloat, green: CGFloat, blue: CGFloat) {
        /// Set cells
        for _ in 0..<10 {
            let cell = CAEmitterCell()
            cell.birthRate = 2
            cell.lifetime = 2
            cell.lifetimeRange = 1
            cell.scale = 1
            cell.scaleRange = 0.5
            cell.emissionLongitude = CGFloat(0)
            cell.emissionRange = CGFloat(0)
            cell.velocity = CGFloat(speed)
            cell.velocityRange = 25
            cell.color = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0).cgColor
            cell.contents = particleImage.cgImage
            cells.append(cell)
        }
        /// Emitter's position
        let emitterXOffset = trimImageView.center.x
        let emitterYOffset = trimImageView.center.y
        let point = CGPoint(x: emitterXOffset , y: emitterYOffset)
        
        /// Set up CAEmitterLayer
        emitter.emitterPosition = point
        emitter.emitterSize = CGSize(width: CGFloat(size), height: CGFloat(size))
        emitter.emitterShape = .circle
        emitter.emitterMode = .outline
        emitter.emitterCells = cells
        
        if size == 0 && speed == 0 && red == 0 && green == 0 && blue == 0 {
            print("DEBUG: Have not data.")
        } else {
            self.view.layer.addSublayer(emitter)
        }
        
    }
}

