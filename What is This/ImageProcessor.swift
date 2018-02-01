//
//  ImageProcessor.swift
//  CoreML Image Recognition
//
//  Created by Sami Sharaf on 7/19/17.
//  Copyright © 2017 Sami Sharaf. All rights reserved.
//

import CoreVideo
import UIKit

class ImageProcessor {
  
  static func pixelBuffer(fromImage: UIImage?) -> CVPixelBuffer? {
    
    guard let defImage = fromImage else {
      return nil
    }
    
    let image = self.resizeImage(image: defImage)
    
    let cgImage = image.cgImage
    let frameSize = CGSize(width: (cgImage?.width)!, height: (cgImage?.height)!)
    
    var pixelBuffer: CVPixelBuffer? = nil
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
    
    if status != kCVReturnSuccess{
      return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
    let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
    let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
    
    context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: (cgImage?.width)!, height: (cgImage?.height)!))
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    return pixelBuffer
    
  }
  
  static func resizeImage(image:UIImage) -> UIImage
  {
    var actualHeight:Float = Float(image.size.height)
    var actualWidth:Float = Float(image.size.width)
    
    let maxHeight:Float = 224.0 //your choose height
    let maxWidth:Float = 224.0 //your choose width
    
    var imgRatio:Float = actualWidth/actualHeight
    let maxRatio:Float = maxWidth/maxHeight
    
    if (actualHeight > maxHeight) || (actualWidth > maxWidth)
    {
      if(imgRatio < maxRatio)
      {
        imgRatio = maxHeight / actualHeight;
        actualWidth = imgRatio * actualWidth;
        actualHeight = maxHeight;
      }
      else if(imgRatio > maxRatio)
      {
        imgRatio = maxWidth / actualWidth;
        actualHeight = imgRatio * actualHeight;
        actualWidth = maxWidth;
      }
      else
      {
        actualHeight = maxHeight;
        actualWidth = maxWidth;
      }
    }
    
    let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height:  CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    
    let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
    UIGraphicsEndImageContext()
    
    return UIImage(data: imageData as Data)!
  }
  
  static func resizeImagee(image: UIImage, newSize: CGSize) -> UIImage? {
    // Guard newSize is different
    guard image.size != newSize else { return nil }
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
    
  }

}
