//
//  ImageLoader.swift
//  PiedPipers
//
//  Created by david rogel pernas on 14/12/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Kingfisher

enum Loader
{
    static func loadImg(onImageView imgView: UIImageView, from url: URL?, placeholder: UIImage)
    {
        imgView.kf.setImage(with: url, placeholder: placeholder)
    }
}

let placeholder = UIImage(named: "placeholder")
