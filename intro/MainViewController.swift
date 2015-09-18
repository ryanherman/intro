//
//  ViewController.swift
//  intro
//
//  Created by Ryan Herman on 9/17/15.
//  Copyright © 2015 Miller Program. All rights reserved.
//

import UIKit
import Firebase
class MainViewController: UIViewController {
   
    let ref = Firebase(url: "https://flickering-torch-4367.firebaseio.com/users")

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
    
    
}
