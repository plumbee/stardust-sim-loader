package com.plumbee.stardustplayer.emitter
{
import flash.geom.Rectangle;

import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

import starling.textures.Texture;

public class BitmapToTextureHelper
{
	public function getTexturesFromBitmapParticleInit(initializer : BitmapParticleInit, textureAtlas: Texture = null) : Vector.<Texture>
	{
		var textures : Vector.<Texture> = new Vector.<Texture>();
		var mainTexture : Texture;

		if (initializer.bitmapType == BitmapParticleInit.SINGLE_IMAGE)
		{
			mainTexture = Texture.fromBitmapData(initializer.bitmapData);
			textures.push(mainTexture);
		}
		else if (initializer.bitmapType == BitmapParticleInit.SPRITE_SHEET)
		{
			if(textureAtlas == null)
			{
				throw new Error("no atlas passed to spritesheet-based particle")
			}
			mainTexture = textureAtlas;
			textures = getTexturesFromSpriteSheetAndBitmapParticleInit(initializer, mainTexture);
		}
		else
		{
			throw(new Error("invalid bitmapType"));
		}
		return textures;
	}

	public function getTexturesFromSpriteSheetAndBitmapParticleInit(initializer: BitmapParticleInit, atlasTexture: Texture): Vector.<Texture>
	{
		var result: Vector.<Texture> = Vector.<Texture>([]);
		var rowCount : uint = atlasTexture.height / initializer.spriteSheetSliceHeight;
		var colCount : uint = atlasTexture.width / initializer.spriteSheetSliceWidth;

		for(var row : uint = 0; row < rowCount; row++)
		{
			for(var col : uint = 0; col < colCount; col++)
			{
				var frame : Rectangle = new Rectangle(col * initializer.spriteSheetSliceWidth, row * initializer.spriteSheetSliceHeight, initializer.spriteSheetSliceWidth, initializer.spriteSheetSliceHeight);
				result.push(Texture.fromTexture(atlasTexture, frame));
			}
		}
		return result;
	}
}
}
