//
//  ViewController.swift
//  What is This
//
//  Created by Sami Sharaf on 7/19/17.
//  Copyright © 2017 Sami Sharaf. All rights reserved.
//

import UIKit
import ALCameraViewController
import CoreML

class ViewController: UIViewController {

  @IBOutlet weak var imagesView: UIView!
  @IBOutlet weak var displayImageView: UIImageView!
  @IBOutlet weak var logoView: UIImageView!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var choosePhotoButton: UIButton!
  @IBOutlet weak var dummyView: UIView!
  @IBOutlet weak var buttonsContainer: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var labelConstraint: NSLayoutConstraint!
  
  let model = VGG16()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.setUpHomeView()
    
  }
  
  func setUpHomeView() {
    
    self.showLogo()
    self.imagesView.layer.cornerRadius = 10.0
    self.displayImageView.layer.cornerRadius = 10.0
    self.displayImageView.layer.masksToBounds = true
    self.cameraButton.layer.cornerRadius = 10.0
    self.choosePhotoButton.layer.cornerRadius = 10.0
    self.buttonsContainer.backgroundColor = UIColor(red: 41.0/255.0, green: 38.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    self.dummyView.backgroundColor = UIColor(red: 41.0/255.0, green: 38.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
  }
  
  func showLogo() {
    
    self.displayImageView.isHidden = true
    self.logoView.isHidden = false
    self.dummyView.isHidden = true
    self.labelConstraint.constant = 0
    self.view.backgroundColor = UIColor(red: 41.0/255.0, green: 38.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
  }
  
  func showImage() {
    
    self.displayImageView.isHidden = false
    self.logoView.isHidden = true
    self.dummyView.isHidden = false
    self.view.backgroundColor = UIColor.black
    self.labelConstraint.constant = 60.0
    
  }
  
  func showCamera() {
    
    let croppingEnabled = true
    let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
      // Do something with your image here.
      // If cropping is enabled this image will be the cropped version
      
      self?.processImage(image: image)
      
      self?.dismiss(animated: true, completion: nil)
    }
    
    present(cameraViewController, animated: true, completion: nil)
    
  }
  
  func choosePhoto() {
    
    let croppingEnabled = true
    
    /// Provides an image picker wrapped inside a UINavigationController instance
    let imagePickerViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
      // Do something with your image here.
      // If cropping is enabled this image will be the cropped version
      
      self?.processImage(image: image)
      
      self?.dismiss(animated: true, completion: nil)
    }
    
    present(imagePickerViewController, animated: true, completion: nil)
    
  }
  
  func processImage(image: UIImage?) {
    
    guard let pixelBuffer = ImageProcessor.pixelBuffer(fromImage: image) else {
      return
    }
    
    guard let scene = try? model.prediction(image: pixelBuffer) else {
      print("Error in Processing Image")
      return
    }
    
    self.showImage()
    self.displayImageView.image = image
    let name = scene.classLabel
    let percentage = String(format: "%.1f", (scene.classLabelProbs[name])! * 100)
    self.label.text = "\(name) (\(percentage)%)"
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  @IBAction func cameraButtonPressed(_ sender: Any) {
    self.showCamera()
  }
  
  @IBAction func choosePhotoPressed(_ sender: Any) {
    self.choosePhoto()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

