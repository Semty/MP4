//
//  VPlayerItem.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import AVFoundation
import UIKit

open class VersaPlayerItem: AVPlayerItem {
    
    /// whether content passed through the asset is encrypted and should be decrypted
    public var isEncrypted: Bool = false
    
    public var audioTracks: [VersaPlayerMediaTrack] {
        return tracks(for: .audible)
    }
    
    public var videoTracks: [VersaPlayerMediaTrack] {
        return tracks(for: .visual)
    }
    
    public var captionTracks: [VersaPlayerMediaTrack] {
        return tracks(for: .legible)
    }

    deinit {
      #if DEBUG
          print("8 \(String(describing: self))")
      #endif
    }
    
    public func snapshot() throws -> UIImage? {
        return try screenshotCMTime(cmTime: currentTime())?.0
    }
    
    private func screenshotCMTime(cmTime: CMTime) throws -> (UIImage, photoTime: CMTime)? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        var timePicture = CMTime.zero
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        
        let ref = try imageGenerator.copyCGImage(at: cmTime, actualTime: &timePicture)
        let viewImage: UIImage = UIImage(cgImage: ref)
        return (viewImage, timePicture)
    }

    private func tracks(for characteristic: AVMediaCharacteristic) -> [VersaPlayerMediaTrack] {
        guard let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) else {
            return []
        }
        let options = group.options
        let tracks = options.map { (option) -> VersaPlayerMediaTrack in
            let title = option.displayName
            let language = option.extendedLanguageTag ?? "none"
            return VersaPlayerMediaTrack(option: option, group: group, name: title, language: language)
        }
        return tracks
    }
    
}
