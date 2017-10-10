//
//  ContentsSnippetType.swift
//  Rx_TubeApp
//
//  Created by 細田　大志 on 2017/09/21.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

protocol ContentsSnippetType {
    var title: String { get }
    var description: String { get }
    var publishedAt: String { get }
    var thumbnails: Thumbnails { get }
}
