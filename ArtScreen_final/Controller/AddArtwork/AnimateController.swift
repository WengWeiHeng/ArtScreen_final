//
//  AnimateController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/23.
//

import UIKit

private let reuseIdentifier = "LayerCell"

class AnimateController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    var user: User?
    
    var checkSelectImageIndex: Int = 0
    var checkViewDrawLasso: Bool = false
    var customProtocol: CustomProtocol?
    let featureToolBarView = FeatureToolBarView()
    let penToolBarView = PenToolBarView()
    let animateToolBarView = AnimateToolBarView()
    let lassoToolBarView = LassoToolBarView()
    var animator: UIViewPropertyAnimator!

    private var layers = [UIImage]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .init(white: 1, alpha: 0.5)
        cv.delegate = self
        cv.dataSource = self
//        cv.showsHorizontalScrollIndicator = false
        cv.layer.cornerRadius = 56 / 2
        cv.register(LayerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return cv
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.addTarget(self, action: #selector(handleDeleteLayerItem), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var layerStackView: UIStackView = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.addTarget(self, action: #selector(handleCloseLayerView), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [button, collectionView, deleteButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alpha = 0
        
        return stack
    }()
    
    let settingView : UIView = {
       let view = UIView()
        let buttonPhotoLibrary : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Library"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPhotoLibrary), for: .touchUpInside)
            return button
        }()
        
        let buttonSendImage : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonPhotoLibrary)
        view.addSubview(buttonSendImage)
        buttonPhotoLibrary.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 28, height: 20)
        buttonSendImage.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 12, height: 24)
        
        buttonPhotoLibrary.centerY(inView: view)
        buttonSendImage.centerY(inView: view)
        
        return view
    }()
    
    private let buttonPlay: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapbuttonPlay), for: .touchUpInside)
        button.setDimensions(width: 30, height: 26)
        
        return button
    }()
    
    lazy var undoRedoPlayView : UIView = {
        let view = UIView()
        let buttonUndo : UIButton = {
           let button = UIButton()
           button.setImage(#imageLiteral(resourceName: "undo"), for: .normal)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(tapbuttonUndo), for: .touchUpInside)
           return button
       }()
        
       let buttonRedo : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "redo"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonRedo), for: .touchUpInside)
            return button
        }()
        
        let layerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "layer").withRenderingMode(.alwaysOriginal), for: .normal)
            button.setDimensions(width: 26, height: 26)
            button.addTarget(self, action: #selector(handleShowLayer), for: .touchUpInside)
            
            return button
        }()
        
        view.addSubview(buttonUndo)
        view.addSubview(buttonRedo)
        view.addSubview(buttonPlay)
        view.addSubview(layerButton)
        
        buttonUndo.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 30, height: 20)
        buttonRedo.anchor(top: view.topAnchor, left: buttonUndo.rightAnchor, paddingLeft: 14, width: 30, height: 20)
        buttonPlay.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 14)
        layerButton.anchor(top: view.topAnchor, right: buttonPlay.leftAnchor, paddingRight: 10)
        
        buttonUndo.centerY(inView: view)
        buttonRedo.centerY(inView: view)
        buttonPlay.centerY(inView: view)
        layerButton.centerY(inView: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - PenProperties
    var canvas: Canvas = Canvas()
    var penCroppedImage: UIImage?
    
    //MARK: - LassoProperties
    var cutImagecount : Int = 0
    var allPoints = [CGPoint]()
    var indexLastPoint = [Int]()
    var lines = [Line]()
    private var minX : CGFloat = CGFloat(MAXFLOAT)
    private var maxX : CGFloat = 0
    private var minY : CGFloat = CGFloat(MAXFLOAT)
    private var maxY : CGFloat = 0
    var lineView: DrawView!

    private var lassoLayerImage = UIImage()
    var heightoriginalImageView: CGFloat!
    var widthoriginalImageView: CGFloat!
    
    lazy var originalImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    let sampleImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill

        return iv
    }()
    
    let trimImageView = UIImageView()
    var arrtrimImageView = [UIImageView]()
    
    //MARK: - Animate setting properties
    private var isRunning: Bool = false
    private var offsetX: CGFloat!
    private var offsetY: CGFloat!
    private var centerX: CGFloat = 0.5
    private var centerY: CGFloat = 0.5
    
    private var movePath: UIBezierPath!
    private var moveSpeed: CFTimeInterval!
    
    private var rotateFromValue: CGFloat!
    private var rotateToValue: CGFloat!
    private var rotateAnimateSpeed: CFTimeInterval!
    
    private var scaleFromValue: CGFloat!
    private var scaleToValue: CGFloat!
    private var scaleAnimateSpeed: CFTimeInterval!
    private var isRepeat: Bool!
    
    private var opacityFromValue: CGFloat!
    private var opacityToValue: CGFloat!
    private var opacityAnimateSpeed: CFTimeInterval!
    
    private var moveBottom = NSLayoutConstraint()
    private var rotateBottom = NSLayoutConstraint()
    private var scaleBottom = NSLayoutConstraint()
    private var opacityBottom = NSLayoutConstraint()
    private var emitterBottom = NSLayoutConstraint()
    
    private let moveSettingHeight: CGFloat = 180
    private let rotateSettingHeight: CGFloat = 226
    private let settingViewHeight: CGFloat = 272
    private let emitterViewHeight: CGFloat = 378

    private var moveDrawView: MoveDrawView!
    private var moveSettingView = MoveSettingView()
    private var rotateSettingView = RotateSettingView()
    private var scaleSettingView = ScaleSettingView()
    private var opacitySettingView = OpacitySettingView()
    private var emitterSettingView = EmitterSettingView()
    
    lazy var centerPoint: UIView = {
        let view = UIView()
        view.setDimensions(width: 10, height: 10)
        view.layer.cornerRadius = 10 / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mainCenterPoint.cgColor
        view.alpha = 0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        view.addGestureRecognizer(pan)
        
        return view
    }()
    
    //MARK: - EmitterProperties
    var cells = [CAEmitterCell]()
    var emitter = CAEmitterLayer()
    var emitterSpeed: CGFloat! = 0
    var emitterSize: CGFloat! = 0
    var redValue: CGFloat! = 0
    var greenValue: CGFloat! = 0
    var blueValue: CGFloat! = 0
    
    lazy var particleImage: UIImage = {
        let imageSize = CGSize(width: 5, height: 5)
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
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
        configureRegister()
        configureAnimateSettingView()
    }
    
    //MARK: - Selecotrs
    @objc func tapbuttonPhotoLibrary() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddArtworkController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func tapbuttonFeature() {
        print("Tapped Feature Button...")
    }
    
    @objc func tapbuttonSendImage() {
        getAnimationData()
        guard let itemImage = trimImageView.image else { return }
//        let width = trimImageView.frame.width
//        let height = trimImageView.frame.height
//        let x = trimImageView.frame.minX - originalImageView.frame.minX
//        let y = trimImageView.frame.minY - originalImageView.frame.minY
//        
//        let itemCredentials = ArtworkItemCredentials(artworkItemImage: itemImage, width: Float(width), height: Float(height), x: Float(x), y: Float(y), emitterSize: Float(emitterSize), emitterSpeed: Float(emitterSpeed), emitterRedValue: Float(redValue), emitterGreenValue: Float(greenValue), emitterBlueValue: Float(blueValue), moveAnimateSpeed: moveSpeed, rotateFromValue: Float(rotateFromValue), rotateToValue: Float(rotateToValue), rotateAnimateSpeed: rotateAnimateSpeed, scaleFromValue: Float(scaleFromValue), scaleToValue: Float(scaleToValue), scaleAnimateSpeed: scaleAnimateSpeed, opacityFromValue: Float(opacityFromValue), opacityToValue: Float(opacityToValue), opacityAnimateSpeed: opacityAnimateSpeed)
        
        if trimImageView.image == nil {
            showError("Please make your Animate item!")
        } else {
            guard let user = user else { return }
            let controller = ArtworkInfoSettingController(user: user)
            controller.artworkImage = originalImageView.image
            controller.itemImage = itemImage
//            controller.itemCredentials = itemCredentials
            controller.heightoriginalImageView = heightoriginalImageView
            controller.widthoriginalImageView = widthoriginalImageView
            controller.artworkImageWidth = originalImageView.frame.size.width
            controller.artworkImageHeight = originalImageView.frame.size.height
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func tapbuttonUndo() {
        print("Tapped Undo Button...")
    }
    
    @objc func tapbuttonRedo() {
        print("Tapped Redo Button...")
    }
    
    @objc func tapbuttonPlay() {
        UIView.animate(withDuration: 0.3) {
            self.centerPoint.alpha = 0
        }
        
        AnimateUtilities().setAnchorPoint(anchorPoint: CGPoint(x: centerX, y: centerY), view: trimImageView)
        getAnimationData()
        
        isRunning.toggle()
        if isRunning {
            if layers.count == 0 {
                isRunning = false
                showError("Create your animation objects.")
            } else {
                print("rotateToValue = \(rotateToValue)")
                print("rotateFromValue = \(rotateFromValue)")
                buttonPlay.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
                if (checkViewDrawLasso == true) {
                    view.addSubview(trimImageView)
                    trimImageView.image = arrtrimImageView[checkSelectImageIndex].image
                    trimImageView.frame = arrtrimImageView[checkSelectImageIndex].frame
                    arrtrimImageView[checkSelectImageIndex].removeFromSuperview()
                }
                
                AnimateUtilities().allAction(view: trimImageView, path: movePath, moveDuration: moveSpeed, rotateFrom: rotateFromValue, rotateTo: rotateToValue, rotateDuration: rotateAnimateSpeed, scaleFrom: scaleFromValue, scaleTo: scaleToValue, scaleDuration: scaleAnimateSpeed, autoreverses: true, opacityFrom: opacityFromValue, opacityto: opacityToValue, opacityDuration: opacityAnimateSpeed)
                
//                setEmitter()
            }
        } else {
            buttonPlay.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            AnimateUtilities().removeAnimate(view: trimImageView)
            cells.removeAll()
            emitter.removeFromSuperlayer()
            emitter.removeAllAnimations()
        }
    }
    
    @objc func handleShowLayer() {
        UIView.animate(withDuration: 0.4) {
            self.undoRedoPlayView.alpha = 0
            self.layerStackView.alpha = 1
            
//            self.animateToolBarView.alpha = 1
        }
    }
    
    @objc func handleCloseLayerView() {
        UIView.animate(withDuration: 0.4) {
            self.undoRedoPlayView.alpha = 1
            self.layerStackView.alpha = 0
            self.animateToolBarView.alpha = 0
            self.featureToolBarView.alpha = 1
        }
    }
    
    @objc func handleDeleteLayerItem() {
        print("DEBUG: Delete layer item..")
        ////fixed start
        do {
            resetAnimate()

        } catch {
            print("error with delete layer Item")
        }
        ///fixed end
        
    }
    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
                
        // move direction
        let translation = sender.translation(in: centerPoint)
        
        switch sender.state {

        case .changed:
            offsetX = centerPoint.center.x + translation.x
            offsetY = centerPoint.center.y + translation.y
            
            centerX = (offsetX - trimImageView.frame.minX) / trimImageView.frame.width
            centerY = (offsetY - trimImageView.frame.minY) / trimImageView.frame.height
            
            centerPoint.center = CGPoint(x: offsetX, y: offsetY)
            sender.setTranslation(.zero, in: centerPoint)
        case .ended:
            print("CX: \(centerX), CY: \(centerY)")
//            print("centerPoint anchorPoint: \(centerPoint.center.self)")
        default:
            ()
        }
    }
 
    //MARK: - Helpers
    func getAnimationData() {
        moveDrawView = MoveDrawView(frame: originalImageView.frame)
        movePath = UIBezierPath()
        if view.isDescendant(of: moveDrawView) {
            movePath = moveDrawView.originalImagePath
        }
        moveSpeed = CFTimeInterval(moveSettingView.speedSlider.value)
        
        rotateFromValue = CGFloat(rotateSettingView.fromeValue)
        rotateToValue = CGFloat(rotateSettingView.toValue)
        rotateAnimateSpeed = CFTimeInterval(rotateSettingView.speedSlider.value)
        
        scaleFromValue = CGFloat(scaleSettingView.maxSizeSlider.value)
        scaleToValue = CGFloat(scaleSettingView.minSizeSlider.value)
        scaleAnimateSpeed = CFTimeInterval(scaleSettingView.speedSlider.value)
        
        opacityFromValue = CGFloat(opacitySettingView.maxSizeSlider.value)
        opacityToValue = CGFloat(opacitySettingView.minSizeSlider.value)
        opacityAnimateSpeed = CFTimeInterval(opacitySettingView.speedSlider.value)
    }
    
    func SolveWidthStackView(_ number : Int) -> CGFloat {
        let result = (screenWidth - CGFloat(12 * 2 + (number - 1) * 8))
        return result/CGFloat(number)
    }
    
    func configureRegister() {
        view.addSubview(settingView)
        settingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        
        let centerView = UIView()
        view.addSubview(centerView)
        centerView.anchor(top: settingView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 160)
        
        view.addSubview(originalImageView)
        originalImageView.center(inView: centerView)
        originalImageView.anchor(width : widthoriginalImageView, height: heightoriginalImageView)
        
        view.addSubview(featureToolBarView)
        featureToolBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 100)
        featureToolBarView.alpha = 1
        featureToolBarView.delegate = self
        
        view.addSubview(penToolBarView)
        penToolBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 100)
        penToolBarView.alpha = 0
        penToolBarView.delegate = self
        
        view.addSubview(animateToolBarView)
        animateToolBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 100)
        animateToolBarView.alpha = 0
        animateToolBarView.delegate = self
        
        view.addSubview(lassoToolBarView)
        lassoToolBarView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,  height: 100)
        lassoToolBarView.alpha = 0
        lassoToolBarView.delegate = self
        
        view.addSubview(undoRedoPlayView)
        undoRedoPlayView.anchor(left: view.leftAnchor, bottom: featureToolBarView.topAnchor, right: view.rightAnchor, paddingBottom: 20, height: 38)
        
        view.addSubview(layerStackView)
        layerStackView.anchor(top: undoRedoPlayView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12, height: 56)
    }
    
    
    func configureAnimateSettingView() {
        view.addSubview(moveSettingView)
        moveSettingView.translatesAutoresizingMaskIntoConstraints = false
        moveSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moveSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moveBottom = moveSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: moveSettingHeight)
        moveBottom.isActive = true
        moveSettingView.heightAnchor.constraint(equalToConstant: moveSettingHeight).isActive = true
        moveSettingView.layer.cornerRadius = 24
        moveSettingView.delegate = self
        moveSettingView.layer.zPosition = 10000
        
        view.addSubview(rotateSettingView)
        rotateSettingView.translatesAutoresizingMaskIntoConstraints = false
        rotateSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rotateSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rotateBottom = rotateSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: rotateSettingHeight)
        rotateBottom.isActive = true
        rotateSettingView.heightAnchor.constraint(equalToConstant: rotateSettingHeight).isActive = true
        rotateSettingView.layer.cornerRadius = 24
        rotateSettingView.delegate = self
        rotateSettingView.layer.zPosition = 10000
        
        view.addSubview(scaleSettingView)
        scaleSettingView.translatesAutoresizingMaskIntoConstraints = false
        scaleSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scaleSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scaleBottom = scaleSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: settingViewHeight)
        scaleBottom.isActive = true
        scaleSettingView.heightAnchor.constraint(equalToConstant: settingViewHeight).isActive = true
        scaleSettingView.layer.cornerRadius = 24
        scaleSettingView.delegate = self
        scaleSettingView.layer.zPosition = 10000
        
        view.addSubview(opacitySettingView)
        opacitySettingView.translatesAutoresizingMaskIntoConstraints = false
        opacitySettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        opacitySettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        opacityBottom = opacitySettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: settingViewHeight)
        opacityBottom.isActive = true
        opacitySettingView.heightAnchor.constraint(equalToConstant: settingViewHeight).isActive = true
        opacitySettingView.layer.cornerRadius = 24
        opacitySettingView.delegate = self
        opacitySettingView.layer.zPosition = 10000
        
        view.addSubview(emitterSettingView)
        emitterSettingView.translatesAutoresizingMaskIntoConstraints = false
        emitterSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emitterSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emitterBottom = emitterSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: emitterViewHeight)
        emitterBottom.isActive = true
        emitterSettingView.heightAnchor.constraint(equalToConstant: emitterViewHeight).isActive = true
        emitterSettingView.layer.cornerRadius = 24
        emitterSettingView.delegate = self
        emitterSettingView.selfDelegate = self
        emitterSettingView.layer.zPosition = 10000
    }
    
    func handleDismissal() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.moveBottom.constant = self.moveSettingHeight
            self.scaleBottom.constant = self.settingViewHeight
            self.opacityBottom.constant = self.settingViewHeight
            self.rotateBottom.constant = self.rotateSettingHeight
            self.emitterBottom.constant = self.emitterViewHeight
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    //MARK: - Pen function Helpers
    func configureCanvasView(withDoing doing: Bool) {
        view.addSubview(canvas)
        canvas.layer.anchorPointZ = 0
        canvas.frame = CGRect(x: 0, y: 0, width: originalImageView.frame.width, height: originalImageView.frame.height)
        canvas.anchor(top: originalImageView.topAnchor, width: originalImageView.frame.width, height: originalImageView.frame.height)
        
        canvas.clipsToBounds = true
        canvas.isMultipleTouchEnabled = false
        
        if doing {
            canvas.alpha = 1
        } else {
            canvas.removeFromSuperview()
        }
    }
    
    func penCropImage() -> UIImage? {
        let maskLayer = canvas.setMaskLayer()
        sampleImageView.layer.mask = maskLayer
        /// context start
        UIGraphicsBeginImageContextWithOptions(sampleImageView.frame.size, false, 1)
        if let currentContext = UIGraphicsGetCurrentContext() {
            sampleImageView.layer.render(in: currentContext)
        }
        /// make new image from context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        /// end context
        UIGraphicsEndImageContext()

        let croppedImg = newImage
        return croppedImg
    }
    
    //MARK: - Lasso function Helpers
    func configureLassoCroppedImageView() {
        view.addSubview(sampleImageView)
        sampleImageView.anchor(top: originalImageView.topAnchor, left: originalImageView.leftAnchor, bottom: originalImageView.bottomAnchor, right: originalImageView.rightAnchor)
    }
    
    func drawLineOnImage(_ size: CGSize,_ image: UIImage,_ points : [CGPoint]) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(at: CGPoint.zero)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.blue.cgColor)

        for i in 0..<points.count-1 {
            context.move(to: CGPoint(x: points[i].x - minX , y: points[i].y - minY))
            context.addLine(to: CGPoint(x: points[i+1].x - minX , y: points[i+1].y - minY))
        }
        context.move(to: CGPoint(x: points[points.count-1].x - minX , y: points[points.count-1].y - minY ))
        context.addLine(to: CGPoint(x: points[0].x - minX, y: points[0].y - minY))
        context.strokePath()

        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func solve(_ currentPoint: CGPoint) {
        if (currentPoint.x > maxX) {
            maxX = currentPoint.x
        }
        if (currentPoint.x < minX) {
            minX = currentPoint.x
        }
        if (currentPoint.y > maxY) {
            maxY = currentPoint.y
        }
        if (currentPoint.y < minY) {
            minY = currentPoint.y
        }
    }

    func trimImage(image: UIImage, area: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        guard let imageCropping = cgImage.cropping(to: area) else { return nil }
        let trimImage = UIImage(cgImage: imageCropping, scale: image.scale, orientation: image.imageOrientation)
        return trimImage
    }
    func resetAnimate() {

        cells.removeAll()
        emitter.removeFromSuperlayer()
        emitter.removeAllAnimations()
        rotateSettingView.resetButton()
        rotateSettingView.fromeValue = 0
        rotateSettingView.toValue = 0
        rotateSettingView.speedSlider.value = 0
        
        scaleSettingView.maxSizeSlider.value = 0
        scaleSettingView.minSizeSlider.value = 0
        scaleSettingView.speedSlider.value = 0
        
        opacitySettingView.maxSizeSlider.value = 0
        opacitySettingView.minSizeSlider.value = 0
        opacitySettingView.speedSlider.value = 0
    }
    
    //MARK: - EmitterHelperS
    func setEmitter() {
        emitterSize = CGFloat(emitterSettingView.sizeSlider.value)
        emitterSpeed = CGFloat(emitterSettingView.speedSlider.value)
        redValue = CGFloat(emitterSettingView.redSlider.value)
        greenValue = CGFloat(emitterSettingView.greenSlider.value)
        blueValue = CGFloat(emitterSettingView.blueSlider.value)
        
        for _ in 0..<10 {
            let cell = CAEmitterCell()
            cell.birthRate = 2
            cell.lifetime = 2
            cell.lifetimeRange = 1
            cell.scale = 1
            cell.scaleRange = 0.5
            cell.emissionLongitude = CGFloat(0)
            cell.emissionRange = CGFloat(0)
            cell.velocity = CGFloat(emitterSpeed)
            cell.velocityRange = 25
            cell.color = UIColor(red: CGFloat(redValue)/255, green: CGFloat(greenValue)/255, blue: CGFloat(blueValue)/255, alpha: 1.0).cgColor
            cell.contents = particleImage.cgImage
            cells.append(cell)
        }
        /// Emitter's position
        let emitterXOffset = trimImageView.center.x
        let emitterYOffset = trimImageView.center.y
        let point = CGPoint(x: emitterXOffset , y: emitterYOffset)
        
        /// Set up CAEmitterLayer
        emitter.emitterPosition = point
        emitter.emitterSize = CGSize(width: CGFloat(emitterSize), height: CGFloat(emitterSize))
        emitter.emitterShape = .circle
        emitter.emitterMode = .outline
        emitter.emitterCells = cells
        self.view.layer.addSublayer(emitter)
    }
}

//MARK: - UICollectionViewDataSource
extension AnimateController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LayerCell
        cell.layerImageView.image = layers[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (checkViewDrawLasso == true) {
            checkSelectImageIndex = indexPath.row
        }
    }
    
}

//MARK: - UICollectionViewDelegate
extension AnimateController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            self.featureToolBarView.alpha = 0
            self.penToolBarView.alpha = 0
            self.lassoToolBarView.alpha = 0
            self.animateToolBarView.alpha = 1
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AnimateController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 36)
    }
}

//MARK: - FeatureToolBarViewDelegate
extension AnimateController: FeatureToolBarViewDelegate {
    func deletePenAndLasso() {
        ////fixed start
        do {
            let count = try arrtrimImageView.count
            for i in 0..<count {
                arrtrimImageView[i].removeFromSuperview()
            }
            arrtrimImageView.removeAll()
            trimImageView.image = UIImage()
            trimImageView.removeFromSuperview()
            layers.removeAll()
            collectionView.reloadData()
            originalImageView.alpha = 1.0
            resetAnimate()
        } catch {
            print("Crash with deletePenAndLasso")
        }

        ////fixed end
    }
    
    func showPenToolBar() {
        UIView.animate(withDuration: 0.4) {
            self.featureToolBarView.alpha = 0
            self.penToolBarView.alpha = 1
            self.checkViewDrawLasso = false
        }
        configureLassoCroppedImageView()
        self.configureCanvasView(withDoing: true)
    }
    func showLassoToolBarAndDraw() {
        self.checkViewDrawLasso = true
        UIView.animate(withDuration: 0.4) {
            self.featureToolBarView.alpha = 0
            self.lassoToolBarView.alpha = 1
        }
        configureLassoCroppedImageView()
        lineView = DrawView(frame: originalImageView.frame)
        view.addSubview(lineView)
    }
}

//MARK: - PenToolBarDelegate
extension AnimateController: PenToolBarDelegate {
    func penCloseAction() {
        UIView.animate(withDuration: 0.4) {
            self.penToolBarView.alpha = 0
            self.featureToolBarView.alpha = 1
        }
        configureCanvasView(withDoing: false)
    }
    
    func penClearAction() {
        canvas.clearCanvas()
    }
    
    func penCropAction() {
        let beCropped = penCropImage()
        let finalPath = canvas.getPath()
        print("\(beCropped) , \(finalPath)")
        if (finalPath != UIBezierPath()) {
            penCroppedImage = UIImage(cgImage: (beCropped?.cgImage?.cropping(to: finalPath.bounds))!)
            sampleImageView.removeFromSuperview()
            
            view.addSubview(trimImageView)
            trimImageView.image = penCroppedImage
            trimImageView.frame = finalPath.bounds
            trimImageView.frame.origin.x = finalPath.bounds.minX + originalImageView.frame.origin.x
            trimImageView.frame.origin.y = finalPath.bounds.minY + originalImageView.frame.origin.y
            
            originalImageView.alpha = 0.3
            
            layers.append(penCroppedImage!)
            collectionView.reloadData()
            configureCanvasView(withDoing: false)
        }
        
    }
    
    func penJointAction() {
        canvas.endDrawingStatus = true
        canvas.endDrawing()
    }
}

//MARK: - LassoToolBarDelegate
extension AnimateController: LassoToolBarDelegate {
    func backAction() {
        UIView.animate(withDuration: 0.4) {
            self.lassoToolBarView.alpha = 0
            self.featureToolBarView.alpha = 1
            self.originalImageView.alpha = 1
        }
        lineView.removeFromSuperview()
        
    }
    
    func jointAction() {
        let lasspoint: [CGPoint] = lineView.getPoints()
        if lasspoint.count > 1 {
        lassoLayerImage = ZImageCropper.cropImage(ofImageView: sampleImageView, withinPoints: lasspoint)!
//        self.lassoLayerImage = lassoLayerImage
        
        let line: [Line] = lineView.getLines()
        
        //cut ImageView with point
        view.addSubview(trimImageView)
        let points =  lineView.getPoints()
        for i in 0..<points.count {
            solve(points[i])
        }
        let height: CGFloat = maxY - minY
        let width: CGFloat = maxX - minX
        let minXImageView = originalImageView.frame.minX
        let minYImageView = originalImageView.frame.minY
        trimImageView.frame = CGRect(x: minX + minXImageView , y: minY + minYImageView, width: width , height: height)
        let uiImage: UIImage = lassoLayerImage
        let origin = CGPoint(x: minX, y: minY)
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: origin, size: size)
        trimImageView.image = trimImage(image: uiImage, area: rect)
        trimImageView.image = drawLineOnImage(trimImageView.frame.size, trimImageView.image!, line[line.count-1].points)
        sampleImageView.removeFromSuperview()
        
        view.addSubview(centerPoint)
        centerPoint.centerX(inView: trimImageView)
        centerPoint.centerY(inView: trimImageView)
        
        lineView.removeFromSuperview()
        layers.append(lassoLayerImage)
        arrtrimImageView.append(UIImageView())
        let lastIndex = arrtrimImageView.count-1
        view.addSubview(arrtrimImageView[lastIndex])
        arrtrimImageView[lastIndex].frame = trimImageView.frame
        arrtrimImageView[lastIndex].image = trimImageView.image
        arrtrimImageView[lastIndex].tag = lastIndex
        trimImageView.removeFromSuperview()
        }
    }
    
    func undoAction() {
        lines = try lineView.getLines()
        print(lines.count)
        _ = lines.popLast()
        lineView.removeFromSuperview()
        lineView = DrawView(frame: originalImageView.frame)
        view.addSubview(lineView)
        lineView.setting(lines)
        lineView.undo()
    }
    
    func cutAction() {
        lineView.removeFromSuperview()
        originalImageView.alpha = 0.3
        collectionView.reloadData()
    }
    
    func cleanAction() {
        trimImageView.image = UIImage()
        lineView.reset()
        lineView.removeFromSuperview()
        showLassoToolBarAndDraw()
    
    }
}

//MARK: - AnimateToolBarViewDelegate
extension AnimateController: AnimateToolBarViewDelegate {
    func emitterSetting() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.emitterBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        setEmitter()
    }
    
    func moveSetting() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.moveBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    
        moveDrawView.delegate = self
        view.addSubview(moveDrawView)
    }
    
    func rotateSetting() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.rotateBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        
        UIView.animate(withDuration: 0.3) {
            self.centerPoint.alpha = 1
        }
    }
    
    func scaleSetting() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.scaleBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        
        UIView.animate(withDuration: 0.3) {
            self.centerPoint.alpha = 1
        }
    }
    
    func opacitySetting() {
        animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.opacityBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

//MARK: - SettingViewDelegate
extension AnimateController: SettingViewDelegate {

    
    func dismissSettingView() {
        handleDismissal()
        guard let moveDrawView = moveDrawView else { return }
        moveDrawView.removeFromSuperview()
    }
}

//MARK: - MoveDrawViewDelegate
extension AnimateController: MoveDrawViewDelegate {
    func drawMovePath(_ path: UIBezierPath) {
        print("DEBUG : LastLinePath = \(path)")
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(circleLayer)
    }
}

//MARK: - EmitterSettingViewDelegate
extension AnimateController: EmitterSettingViewDelegate {
    func sliderValueDidChange() {
        cells.removeAll()
        emitter.removeFromSuperlayer()
        emitter.removeAllAnimations()
        setEmitter()
    }
}

