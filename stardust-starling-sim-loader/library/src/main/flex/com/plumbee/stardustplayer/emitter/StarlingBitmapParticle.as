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
		updatePivot();
	}

	private function updatePivot() : void
	{
		pivotX = texture.width / 2;
		pivotY = texture.height / 2;
	}

	protected var _textures : Vector.<Texture>;

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
		var index:int = _textures.indexOf(texture);
		texture = _textures[(stepTime+index)%_textures.length];
	}

	override public function set texture(value : Texture) : void
	{
		super.texture = value;
		width = texture.width;
		height = texture.height;
		updatePivot();
	}

	public function isAnimatedSpriteSheet() : Boolean
	{
		return _textures.length > 1;
	}

	private function degreeToRadians(rotation : Number) : Number
	{
		return rotation * Math.PI / 180;
	}
}
}
