//
//  FilterService.swift
//  CameraFilter
//
//  Created by Akshay Nandane on 04/05/21.
//  Copyright © 2021 com.app.connectme. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService{
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    //Used observables to communicate between two classes
    func applyFilter1(to inputImage: UIImage) -> Observable<UIImage>{
        
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            
            return Disposables.create()
        }
    }
    
    //Used closure to communicate between two classes
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())){
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
                
            }
        }
    }
    
}
