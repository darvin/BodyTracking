//
//  ARSUIViewHandTracking3D.swift
//  BodyTracking-Example
//
//  Created by Grant Jarvis on 4/29/22.
//

import ARKit
import RealityKit
//import BodyTracking

class ARSUIViewHandTracking3D: BodyARView {
    

    private var handTracker: HandTracker3D!
    
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        guard #available(iOS 14, *) else {
            let title = "Uh oh..."
            let errorMessage = "Hand tracking requires iOS 14.0 or later"
            print(errorMessage)
            showAlert(title: title, message: errorMessage)
            return
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        runNewConfig()
        
        self.handTracker = HandTracker3D(arView: self)
        
        let sceneAnchor = AnchorEntity()
        
        self.scene.addAnchor(sceneAnchor)
        
        sceneAnchor.addChild(handTracker)
        
        makeHandJointsVisible()
        
        //Can modify this to improve performance.
        //handTracker.requestRate = .quarter
    }
    
    func runNewConfig(){
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        
        //Goes with (currentFrame.smoothedSceneDepth ?? currentFrame.sceneDepth)?.depthMap
        //let frameSemantics: ARConfiguration.FrameSemantics = [.smoothedSceneDepth, .sceneDepth]
        
        //Goes with currentFrame.estimatedDepthData
        let frameSemantics: ARConfiguration.FrameSemantics = .personSegmentationWithDepth
        
        if ARFaceTrackingConfiguration.supportsFrameSemantics(frameSemantics) {
            configuration.frameSemantics.insert(frameSemantics)
        }
        // Run the view's session
        session.run(configuration)
    }
    
    ///This is an example for how to show multiple joints, iteratively.
    private func makeHandJointsVisible(){
        
        //Another way to attach views to the skeletion, but iteratively this time:
        HandTracker2D.allHandJoints.forEach { joint in
            let sphere = Entity.makeSphere(color: .white, radius: 0.01, isMetallic: true)
            self.handTracker.attach(thisEnt: sphere, toThisJoint: joint)
        }
    }

    
    override func stopSession(){
        super.stopSession()
           self.handTracker.destroy()
            self.handTracker = nil
       }
    
    deinit {
        self.stopSession()
    }
    
    
    //required function.
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

