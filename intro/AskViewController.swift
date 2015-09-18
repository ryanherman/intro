//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Firebase
import MobileCoreServices
import MediaPlayer

class AskViewController : UIViewController {
    let ref = Firebase(url: "https://flickering-torch-4367.firebaseio.com/ask")
    var base64String:NSString!
    var moviePlayer : MPMoviePlayerController?
    
    @IBOutlet weak var imageReview: UIImageView!
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var recordImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func AskQuestion(sender: AnyObject) {
        startCameraFromViewController(self, withDelegate: self)
        /*
        let questionAsked : String = question.text!
        let theQuestion = ["user":"ryan","question":questionAsked]
        let postRef = ref.childByAppendingPath("questions")
        let post1Ref = postRef.childByAutoId()
        post1Ref.setValue(theQuestion)
        */
    }
    @IBAction func dismissResponder(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        
        if let saveError = error {
            title = "Error"
            message = "Video failed to save"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
    extension AskViewController : UIImagePickerControllerDelegate
    {
        func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool
        {
            if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
                return false
            }
            
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .Camera
            cameraController.mediaTypes = [kUTTypeMovie as String]

            cameraController.allowsEditing = false
            cameraController.delegate = delegate
            
            presentViewController(cameraController, animated: true, completion: nil)
            return true
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo info: [String : AnyObject]?) {
            dismissViewControllerAnimated(true, completion: nil)
            imageReview.image = image
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
             let mediaType = info[UIImagePickerControllerMediaType] as! NSString
            dismissViewControllerAnimated(true, completion: nil)
            // Handle a movie capture
            if mediaType == kUTTypeMovie {
                let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path!) {
                    UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "video:didFinishSavingWithError:contextInfo:", nil)
                    var x: NSData? = NSData(contentsOfFile: path!)
                    
                    base64String = x?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                    
                    let postRef = ref.childByAppendingPath("questions")
                    let post1 = ["username": "bitz", "data": base64String]
                    let post1Ref = postRef.childByAutoId()
                    post1Ref.setValue(post1)
                    playVideo(path!)
                }
            }
        }
        
        func playVideo(fullPath: String) {
            print(fullPath)
            let url = NSURL.fileURLWithPath(fullPath)

            moviePlayer = MPMoviePlayerController(contentURL: url)
            if let player = moviePlayer {
                player.view.frame = self.view.bounds
                player.prepareToPlay()
                player.scalingMode = .AspectFill
                self.view.addSubview(player.view)
            }
        }

    }
    



extension AskViewController: UINavigationControllerDelegate{
    
}
