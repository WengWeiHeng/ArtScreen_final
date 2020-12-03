//
//  ArtworkItem.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/12/3.
//

import Foundation

struct ArtworkItem: Decodable {
    var artworkID: String
    var userID: String
    var path: URL
    var width: Float
    var height: Float
    var x: Float
    var y: Float
    var scaleTo: Float
    var scaleFrom: Float
    var scaleSpeed: Float
    var rotateTo: Float
    var rotateFrom: Float
    var rotateSpeed: Float
    var opacityTo: Float
    var opacityFrom: Float
    var opacitySpeed: Float
    var emitterBlue: Float
    var emitterRed: Float
    var emitterGreen: Float
    var emitterSize: Float
    var emitterSpeed: Float
}
