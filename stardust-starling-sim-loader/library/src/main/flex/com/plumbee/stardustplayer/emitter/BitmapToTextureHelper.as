package com.plumbee.stardustplayer.emitter
{
import flash.geom.Rectangle;

import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

import starling.textures.Texture;

public class BitmapToTextureHelper
{
	public function getTexturesFromBitmapParticleInit(initializer : BitmapParticleInit, overrideTexture: Texture = null) : Vector.<Texture>
	{
		var textures : Vector.<Texture> = new Vector.<Texture>();
		var mainTexture : Texture;

		if (initializer.bitmapType == BitmapParticleInit.SINGLE_IMAGE)
		{
			mainTexture = selectTextureSource(initializer, overrideTexture);
			textures.push(mainTexture);
		}
		else if (initializer.bitmapType == BitmapParticleInit.SPRITE_SHEET)
		{
			mainTexture = selectTextureSource(initializer, overrideTexture);
			textures = getTexturesFromSpriteSheetAndBitmapParticleInit(initializer, mainTexture);
		}
		else
		{
			throw(new Error("invalid bitmapType"));
		}
		return textures;
	}

	public function getTexturesFromSpriteSheetAndBitmapParticleInit(initializer: BitmapParticleInit, overrideTexture: Texture): Vector.<Texture>
	{
		var result: Vector.<Texture> = Vector.<Texture>([]);
		var rowCount : uint = overrideTexture.height / initializer.spriteSheetSliceHeight;
		var colCount : uint = overrideTexture.width / initializer.spriteSheetSliceWidth;

		for(var row : uint = 0; row < rowCount; row++)
		{
			for(var col : uint = 0; col < colCount; col++)
			{
				var frame : Rectangle = new Rectangle(col * initializer.spriteSheetSliceWidth, row * initializer.spriteSheetSliceHeight, initializer.spriteSheetSliceWidth, initializer.spriteSheetSliceHeight);
				result.push(Texture.fromTexture(overrideTexture, frame));
			}
		}
		return result;
	}

	private function selectTextureSource(initializer: BitmapParticleInit, overrideTexture: Texture = null): Texture
	{
		if(overrideTexture!=null)
		{
			return overrideTexture;
		}
		else if(initializer.bitmapData != null)
		{
			return Texture.fromBitmapData(initializer.bitmapData);
		}
		else
		{
			throw new Error("No Texture provided by BitmapParticleInit or via overrideTexture");
		}
	}
}
}
