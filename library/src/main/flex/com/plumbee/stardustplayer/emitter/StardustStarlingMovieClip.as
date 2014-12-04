package com.plumbee.stardustplayer.emitter
{

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IBitmapParticle;
import idv.cjcat.stardustextended.twoD.starling.IStardustStarlingParticle;

import starling.display.MovieClip;
import starling.textures.Texture;

public class StardustStarlingMovieClip extends MovieClip implements IStardustStarlingParticle, IBitmapParticle
{

//	public function StardustMovieClip(emitterId : uint/*, textureName : String*/)
	public function StardustStarlingMovieClip(textures : Vector.<Texture>)
	{
//		var texture : Texture = getTexture(emitterId);
//		var xml:XML;
//		if(emitterId == 0) {
//			xml = new XML(new AtlasTexture0());
//		} else if (emitterId == 1) {
//			xml = new XML(new AtlasTexture1());
//		} else if (emitterId == 2) {
//			xml = new XML(new AtlasTexture2());
//		}

//		var atlas:TextureAtlas = new TextureAtlas(texture, xml);
//		super(atlas.getTextures(textureName), 1);
//		super(atlas.getTextures("coin"), 30);
		//TODO: Handle the framerate
		super(textures, 30);

//		width = getFrameTexture(0).width;
//		height = getFrameTexture(0).height;
//		x = -width / 2;
//		y = -height / 2;
//		pivotX = width * 0.5;
//		pivotY = height * 0.5;
//		rotation = 0;
//		loop = true;
//		Starling.juggler.add(this);
//		play();
	}

	public function updateFromModel(x : Number, y : Number, rotation : Number, scale : Number, alpha : Number) : void
	{
		this.x = x;
		this.y = y;
		this.rotation = rotation;
		this.scaleX = this.scaleY = scale;
		if (this.alpha != alpha)
		{
			this.alpha = alpha;
		}
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
