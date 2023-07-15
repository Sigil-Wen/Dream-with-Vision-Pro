//
//  ImmersiveView.swift
//  Dream
//
//  Created by Sigil Wen on 2023-07-15.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Add an ImageBasedLight for the immersive content
                if let imageBasedLightURL = Bundle.main.url(forResource: "ImageBasedLight", withExtension: "exr"),
                   let imageBasedLightImageSource = CGImageSourceCreateWithURL(imageBasedLightURL as CFURL, nil),
                   let imageBasedLightImage = CGImageSourceCreateImageAtIndex(imageBasedLightImageSource, 0, nil),
                   let imageBasedLightResource = try? await EnvironmentResource.generate(fromEquirectangular: imageBasedLightImage) {
                    let imageBasedLightSource = ImageBasedLightComponent.Source.single(imageBasedLightResource)

                    let imageBasedLight = Entity()
                    imageBasedLight.components.set(ImageBasedLightComponent(source: imageBasedLightSource))
                    content.add(imageBasedLight)

                    immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: imageBasedLight))
                }

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
