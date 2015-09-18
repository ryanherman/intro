//
//  ViewController.swift
//  intro
//
//  Created by Ryan Herman on 9/17/15.
//  Copyright © 2015 Miller Program. All rights reserved.
//

import UIKit
import Firebase
import MediaPlayer
import AVKit
class MainViewController: UIViewController {
   
    let ref = Firebase(url: "https://flickering-torch-4367.firebaseio.com/users")
    var moviePlayer : MPMoviePlayerController?

    private func initialize() {
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            print(snapshot.value.objectForKey("users"))
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let postRef = ref.childByAppendingPath("posts")
        let post1 = ["author2": "setit", "title": "Announcing COBOL, a New Programming Language!!"]
        let post1Ref = postRef.childByAutoId()
      //  post1Ref.setValue(post1)
        self.initialize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playIntro(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.playVideo()
        }
    }
    
    func playVideo() {
        let path = NSBundle.mainBundle().pathForResource("aju", ofType:"mov")
        let url = NSURL.fileURLWithPath(path!)
        moviePlayer = MPMoviePlayerController(contentURL: url)
 
        if let player = moviePlayer {
            player.view.frame = self.view.bounds
            player.prepareToPlay()
            player.scalingMode = .AspectFit
            player.controlStyle = .Fullscreen
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "videoHasFinishedPlaying:",
                name: MPMoviePlayerPlaybackDidFinishNotification,
                object: nil)
            
            self.view.addSubview(player.view)
        }
    }
    
    func videoHasFinishedPlaying(notification: NSNotification){
        print("Video finished playing")
        moviePlayer!.view.removeFromSuperview()
    }
    
    
    
}
