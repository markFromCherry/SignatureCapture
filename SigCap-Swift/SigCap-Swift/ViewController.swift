//
//  ViewController.swift
//  SigCap-Swift
//
//  Created by Mark Burns on 6/19/17.
//  Copyright © 2017 Cambi Solutions, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //ImageView to be drawn in
    var imageView : UIImageView!
    //ImageView to present drawn image for example purposes
    var savedView : UIImageView!
    //Image to store signature
    var sigImage : UIImage!
    //Point to capture location of touch
    var lastPoint = CGPoint.zero
    //Boolean to see if touch movement is occurring
    var swiped = false
    
    override func viewDidLoad() {
        //Creates the two image views
        buildImageViews()
        //Creates the two buttons
        generateButtons()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Creates the two image views
    func buildImageViews() {
        //Builds the frame for the image view
        imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        //gives the view a light gray background just for this example
        imageView.backgroundColor = UIColor.lightGray
        //add imageView to the view
        self.view.addSubview(imageView)
        
        //Builds the frame for the saved view that will present a saved signature
        savedView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 200))
        //gives the view a white background just for this example
        savedView.backgroundColor = UIColor.white
        //add savedView to the view
        self.view.addSubview(savedView)
        
    }
    
    //Creates the two buttons
    func generateButtons() {
        //Builds the frame for the save button
        let btnSave = UIButton(frame: CGRect(x: 0, y: imageView.frame.maxY, width: self.view.frame.width, height: 30))
        //gives button a black background
        btnSave.backgroundColor = UIColor.black
        //gives button white font color
        btnSave.setTitleColor(.white, for: .normal)
        //gives the button a font and font size
        btnSave.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //gives the button a title
        btnSave.setTitle("Save Signature", for: UIControlState.normal)
        //aligns the title in the center of the button
        btnSave.titleLabel?.textAlignment = NSTextAlignment.center
        //calls savePressed function when the button is touched
        btnSave.addTarget(self, action:#selector(savePressed), for: .touchUpInside)
        //add btnSave to the view
        self.view.addSubview(btnSave)
        
        //Builds the frame for the save button
        let btnReset = UIButton(frame: CGRect(x: 0, y: imageView.frame.minY - 30, width: self.view.frame.width, height: 30))
        //gives button a black background
        btnReset.backgroundColor = UIColor.black
        //gives button white font color
        btnReset.setTitleColor(.white, for: .normal)
        //gives the button a font and font size
        btnReset.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //gives the button a title
        btnReset.setTitle("Reset", for: UIControlState.normal)
        //aligns the title in the center of the button
        btnReset.titleLabel?.textAlignment = NSTextAlignment.center
        //calls savePressed function when the button is touched
        btnReset.addTarget(self, action:#selector(resetPressed), for: .touchUpInside)
        //add btnReset to the view
        self.view.addSubview(btnReset)
        
    }
    
    //When save is pressed, set all necessary variables
    func savePressed() {
        //save signature into an image
        sigImage = imageView.image
        //present saved signature in the saved view for example
        savedView.image = sigImage
        
    }
    
    //When reset is pressed, clear the image view to allow person to start over
    func resetPressed() {
        //set imageView to nil to reset it
        imageView.image = nil
        
    }
    
    //called when touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //set swiped to false to initialize/reset the variable
        swiped = false
        //set initial touch point
        if let touch = touches.first {
            lastPoint = touch.location(in: self.imageView)
        }
    }
    
    //draw the lines
    //@param - formPoint: CGPoint for last point touched
    //@param - toPoint: CGPoint for current point touched
    func drawLines(fromPoint : CGPoint, toPoint: CGPoint) {
        //the image we are accessing is imageView
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        //we are drawing within imageViews frame. x and y are 0 to represent the 0,0 location within imageView
        //set height and width the imageView's height and width
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height))
        //we are grabbing the current context within imageView
        let context = UIGraphicsGetCurrentContext()
        //trace through the context with the last point to current point
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        //add a line from the last point to the current point
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        //set blend mode to normal to give a better look to the line
        context?.setBlendMode(CGBlendMode.normal)
        //make the line have a rounded cap for aesthetic purposes
        context?.setLineCap(CGLineCap.round)
        //set line width to whatever number best represents a pen/pencil
        context?.setLineWidth(2)
        //set stroke color to black
        context?.setStrokeColor(UIColor.black.cgColor)
        //stroke the path
        context?.strokePath()
        //update imageView with the new line
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        //The following line can be used to have a real time update the saved image variable
        //sigImage = UIGraphicsGetImageFromCurrentImageContext()!
        //End the image context to finish capture
        UIGraphicsEndImageContext()
    }
    
    //called when touch moves
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //set swiped to true to show movement
        swiped = true
        //if the touch is moving, call drawLines with the last point of touch and the current point of touch
        if let touch = touches.first {
            //current point equals current touch location
            let currentPoint = touch.location(in: self.imageView)
            //call drawLines with the two points
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            //update lastPoint to the current touch location
            lastPoint = currentPoint
        }
    }
    
    //called when touch ends
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if touch is not moving, this will create a dot on the view
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
}

