package com.plumbee.stardustplayer.emitter
{

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IBitmapParticle;
import idv.cjcat.stardustextended.twoD.starling.IStardustStarlingParticle;

import starling.display.MovieClip;
import starling.textures.Texture;

public class StardustStarlingMovieClip extends MovieClip implements IStardustStarlingParticle, IBitmapParticle
{

	public function StardustStarlingMovieClip(textures : Vector.<Texture>)
	{
		//TODO: Handle the framerate
		super(textures, 30);
	}

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

	private function degreeToRadians(rotation : Number) : Number
	{
		return rotation * Math.PI / 180;
	}

	public function initWithSingleBitmap(bitmapData : BitmapData, _smoothing : Boolean) : void
	{
	}

	public function initWithSpriteSheet(imgWidth : int, imgHeight : int, _animSpeed : uint, startAtRandomFrame : Boolean, bitmapData : BitmapData, _smoothing : Boolean) : void
	{
	}

	public function stepSpriteSheet(stepTime : uint) : void
	{
		advanceTime(stepTime);
	}
}
}
