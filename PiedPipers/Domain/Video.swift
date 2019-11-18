//
//  Video.swift
//  PiedPipers
//
//  Created by david rogel pernas on 19/11/2019.
//  Copyright © 2019 david rogel pernas. All rights reserved.
//

import Foundation
/**
 id - Identificador del video, lo que viene después del ?v=
 video - URL original del video
 embedVideo - URL embebida del video
 thumbnail - URL de la imagen de portada del video
 */
struct Video
{
    typealias VideoURL = String
    typealias EmbedVideoURL = String
    typealias ThumbnailURL = String
    
    let id: String
    let video: VideoURL?
    let embedVideo: EmbedVideoURL?
    let thumbnail: ThumbnailURL?
    
    init(id: String, video: VideoURL? = nil,
         embedVideo: EmbedVideoURL? = nil, thumbnail: ThumbnailURL? = nil)
    {
        self.id = id
        self.video = video
        self.embedVideo = embedVideo
        self.thumbnail = thumbnail
    }
}

extension Video: Codable
{
    fileprivate enum CodingKeys: String, CodingKey
    {
        case id
        case video
        case embedVideo
        case thumbnail
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        
        video = try container.decodeIfPresent(VideoURL.self, forKey: .video)
        embedVideo = try container.decodeIfPresent(EmbedVideoURL.self, forKey: .embedVideo)
        thumbnail = try container.decodeIfPresent(ThumbnailURL.self, forKey: .thumbnail)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        
        try container.encodeIfPresent(video, forKey: .video)
        try container.encodeIfPresent(embedVideo, forKey: .embedVideo)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
    }
}
