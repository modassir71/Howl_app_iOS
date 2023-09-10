//
//  UICollectionView+Extension.swift
//  Howl
//
//  Created by apple on 17/08/23.
//

import Foundation
import UIKit

extension UICollectionView {
    func getCell<T:UICollectionViewCell>(indexPath:IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func registerCell<T:UICollectionViewCell>(of: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.className)
    }
    
    func registerNib<T:UICollectionViewCell>(of: T.Type) {
        self.register(UINib(nibName: T.className, bundle: nil), forCellWithReuseIdentifier: T.className)
    }
}
