package com.plumbee.stardustplayer.emitter
{
import flash.geom.Rectangle;

import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

import starling.textures.Texture;

public class BitmapToTextureHelper
{
	public function getTexturesFromBitmapParticleInit(initializer : BitmapParticleInit) : Vector.<Texture>
	{
		var textures : Vector.<Texture> = new Vector.<Texture>();
		var mainTexture : Texture = Texture.fromBitmapData(initializer.bitmapData);

		if (initializer.bitmapType == BitmapParticleInit.SINGLE_IMAGE)
		{
			textures.push(mainTexture);
		}
		else if (initializer.bitmapType == BitmapParticleInit.SPRITE_SHEET)
		{
			var numTextures : uint = mainTexture.width / initializer.spriteSheetSliceWidth;

			for (var j : uint = 0; j < numTextures; j++)
			{
				var frame : Rectangle = new Rectangle(j * initializer.spriteSheetSliceWidth, 0, initializer.spriteSheetSliceWidth, initializer.spriteSheetSliceHeight);
				textures.push(Texture.fromTexture(mainTexture, frame));
			}
		}
		else
		{
			throw(new Error("invalid bitmapType"));
		}
		return textures;
	}
}
}
