//
//  Extension.swift
//  MDTableExample
//
//  Created by Leo on 2017/7/6.
//  Copyright © 2017年 Leo Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Int{
    func asLocalizedPlayCount()->String{
        if self < 100000 {
            return "\(self)"
        }else if self < 100000000{
            return "\(self/10000)万"
        }else{
            return "\(self/100000000)亿"
        }
    }
}

extension UIColor{
    static var theme:UIColor{
        get{
            return UIColor(red: 210.0 / 255.0, green: 62.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
        }
    }
}
struct ImageConst{
    static let bytesPerPixel = 4
    static let bitsPerComponent = 8
}
//解压缩来提高效率
extension UIImage{
    func decodedImage()->UIImage?{
        guard let cgImage = self.cgImage else{
            return nil
        }
        guard let colorspace = cgImage.colorSpace else {
            return nil
        }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = ImageConst.bytesPerPixel * width
        let ctx = CGContext(data: nil,
                                     width: width,
                                     height: height,
                                     bitsPerComponent: ImageConst.bitsPerComponent,
                                     bytesPerRow: bytesPerRow,
                                     space: colorspace,
                                     bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let context = ctx else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        guard let drawedImage = context.makeImage() else{
            return nil
        }
        let result = UIImage(cgImage: drawedImage, scale:self.scale , orientation: self.imageOrientation)
        return result
    }
}

extension UIImageView{
    func asyncSetImage(_ image:UIImage){
        DispatchQueue.global(qos: .userInteractive).async {
            let decodeImage = image.decodedImage()
            DispatchQueue.main.async {
                self.image = decodeImage
            }
        }
    }
}