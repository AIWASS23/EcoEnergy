//
//  FileThumbnailView.swift
//  EcoEnergy
//
//  Created by Marcelo de Araújo on 10/2/202024.
//

import SwiftUI

struct FileThumbnailView: View {
	
	let url: URL
	var thumbnailWidth: CGFloat = 10
	@State private var thumbnail: CGImage?
	
	var body: some View {
		Group {
			if thumbnail != nil {
				Image(thumbnail!, scale: 1.0, label: Text(""))
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: thumbnailWidth)
			} else {
				Image(systemName: "questionmark.square")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: thumbnailWidth)
			}
		}
		.onAppear {
			Task {
				await url.thumbnail(size: CGSize(width: 100, height: 100), scale: 1) { cgImage in
					thumbnail = cgImage
				}
			}
		}
	}
	
}
