//
//  MovieCollectionViewCell.swift
//  MovieSearch-MVVM
//
//  Created by Kiran Sonne on 19/10/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(img: UIImage) {
        DispatchQueue.main.async {
            self.movieImageView.image = img
        }
    }

}
