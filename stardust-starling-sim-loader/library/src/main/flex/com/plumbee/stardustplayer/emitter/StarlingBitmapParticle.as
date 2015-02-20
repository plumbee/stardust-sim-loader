package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IAnimatedParticle;
import idv.cjcat.stardustextended.twoD.starling.IStardustStarlingParticle;

import starling.display.Image;
import starling.textures.Texture;

public class StarlingBitmapParticle extends Image implements IAnimatedParticle, IStardustStarlingParticle
{
	private var _animationSpeed : uint = 1;
	private var _playingFrameIndex : uint = 0;
	private var _animationLength : uint = 1;

	public function StarlingBitmapParticle(textures : Vector.<Texture>, randomStartPosition : Boolean = false)
	{
		super(textures[0]);
		_textures = textures;
		_animationLength = _textures.length;
		updatePivot();

		if(randomStartPosition)
		{
			_playingFrameIndex = Math.random() * _animationLength;
		}
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
		_playingFrameIndex = (_playingFrameIndex + stepTime) % _animationLength;
		texture = _textures[uint(_playingFrameIndex / _animationSpeed)];
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

	public function set animationSpeed(value : uint) : void
	{
		_animationSpeed = (value > 0) ? value : 1;
		_animationLength = _textures.length * _animationSpeed;
	}
}
}
