//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Akshay Nandane on 02/05/21.
//  Copyright © 2021 com.app.connectme. All rights reserved.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController{
    
    //create subject
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage>{
        return selectedPhotoSubject.asObservable()
    }
    
    private var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        
    }
    
    //Populate photo on collection view
    func populatePhotos(){
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            if status == .authorized{
                //Access photos from photo library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects({ (object,count,stop) in
                    self?.images.append(object)
                })
                //Set image collection as reverse. as we have to set latest image at top
                self?.images.reverse()
                //                print(self.images)
                //Reload Collection view
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else if status == .denied{
                //Denied the access photos permission
                
            }
        })
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: nil, resultHandler: { [weak self] image,info in
            guard let info = info else { return }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image{
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? photoCollectionViewCell else {
            fatalError("photoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image,error in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
            
        })
        return cell
    }
}
