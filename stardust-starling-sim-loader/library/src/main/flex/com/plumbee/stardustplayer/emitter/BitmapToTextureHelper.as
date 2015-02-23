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
			var rowCount : uint = mainTexture.height / initializer.spriteSheetSliceHeight;
			var colCount : uint = mainTexture.width / initializer.spriteSheetSliceWidth;

			for(var row : uint = 0; row < rowCount; row++)
			{
				for(var col : uint = 0; col < colCount; col++)
				{
					var frame : Rectangle = new Rectangle(col * initializer.spriteSheetSliceWidth, row * initializer.spriteSheetSliceHeight, initializer.spriteSheetSliceWidth, initializer.spriteSheetSliceHeight);
					textures.push(Texture.fromTexture(mainTexture, frame));
				}
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
