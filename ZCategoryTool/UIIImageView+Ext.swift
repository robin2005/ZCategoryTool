//
//  UIIImageView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import Photos

extension UIImageView {
    
    /// 设置内容模式
    ///
    /// - Parameters:
    ///   - model: 模式
    ///   - clips: 是否裁剪
    public func k_contenModel(model: UIView.ContentMode = .scaleAspectFill, clips: Bool = true) {
        
        self.contentMode = model
        self.clipsToBounds = clips
    }
    
    /// 加载PHAsset资源
    ///
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - isOriginal: 是否是原图
    public func k_setImage(with asset: PHAsset, isOriginal: Bool = false) {
        
        DispatchQueue.global().async {
            
            let options = PHImageRequestOptions()
            options.resizeMode = .fast
            //options.isNetworkAccessAllowed = true
            
            var loadSize: CGSize!
            if isOriginal {
                
                loadSize = PHImageManagerMaximumSize
                
            } else {
                
                loadSize = CGSize(width: kWidth / 2.0, height: kWidth / 2.0)
            }
            PHImageManager.default().requestImage(for: asset, targetSize: loadSize, contentMode: PHImageContentMode.default, options: options) { (img, dic) in
                
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }
    }
}

// MARK: -旋转动画
extension UIImageView {
    
    /// 开始旋转动画
    ///
    /// - Parameter duration: 一圈的时间
    public func k_startRotationAni(duration: Double = 0.6) {
        
        DispatchQueue.main.async {
        
            if self.isHidden {
                
                // 先移除
                self.layer.removeAnimation(forKey: "rotationAnimation")
                // 开始加载
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
                rotationAnimation.duration = duration
                // 旋转累加角度
                rotationAnimation.isCumulative = true
                rotationAnimation.repeatCount = Float(Int.max)
                self.layer.add(rotationAnimation, forKey: "rotationAnimation")
                
                self.isHidden = false
            }
        }
    }
    
    /// 结束旋转动画
    public func k_stopRotationAni() {
        
        DispatchQueue.main.async {
            
            if !self.isHidden {
                
                self.layer.removeAnimation(forKey: "rotationAnimation")
                self.isHidden = true
            }
        }
    }
}
