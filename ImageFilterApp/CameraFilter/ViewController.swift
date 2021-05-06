//
//  ViewController.swift
//  CameraFilter
//
//  Created by Akshay Nandane on 02/05/21.
//  Copyright © 2021 com.app.connectme. All rights reserved.
//

import UIKit
import RxSwift
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet var imageForFilter: UIImageView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let navVC = segue.destination as? UINavigationController, let photoCVC = navVC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("seque destination not found")
        }
        photoCVC.selectedPhoto.subscribe(onNext: { photo in
            self.updateUI(withImage: photo)
            }).disposed(by: disposeBag)
    
    }
    
    @IBAction func applyFilterImageButtonTapped(_ sender: Any) {
        
        guard  let sourceImage = self.imageForFilter.image else {
            return
        }
        
        FilterService().applyFilter1(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                self.imageForFilter.image = filteredImage
            }).disposed(by: disposeBag)
        
        
//        FilterService().applyFilter(to: sourceImage) { (filteredImage) in
//            DispatchQueue.main.async {
//                self.imageForFilter.image = filteredImage
//            }
//        }
        
        
    }
    
    func updateUI(withImage: UIImage) {
        self.imageForFilter.image = withImage
        self.applyFilterButton.isHidden = false
    }

}

