package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;
import idv.cjcat.stardustextended.twoD.starling.IStardustStarlingParticle;

import starling.display.Image;
import starling.textures.Texture;

public class StarlingBitmapParticle extends Image implements IAnimatedParticle, IStardustStarlingParticle
{
	public function StarlingBitmapParticle(textures : Vector.<Texture>)
	{
		super(textures[0]);
		_textures = textures;
	}

	private var _textures : Vector.<Texture>;

	public function updateFromModel(x : Number, y : Number, rotation : Number, scale : Number, alpha : Number) : void
	{
		this.x = x;
		this.y = y;
		//Receives rotation in degrees. Starling uses radians.
		this.rotation = degreeToRadians(rotation);
		this.scaleX = this.scaleY = scale;
		if (this.alpha != alpha)
		{
			this.alpha = alpha;
		}
	}

	public function stepSpriteSheet(stepTime : uint) : void
	{
	}

	public function isAnimatedSpriteSheet() : Boolean
	{
		return _textures.length > 1;
	}

//	private function initializeFromTexture() : void
//	{
//		this.width = texture.width;
//		this.height = texture.height;
//		this.pivotX = texture.width / 2;
//		this.pivotY = texture.height / 2;
//	}

	private function degreeToRadians(rotation : Number) : Number
	{
		return rotation * Math.PI / 180;
	}
}
}
