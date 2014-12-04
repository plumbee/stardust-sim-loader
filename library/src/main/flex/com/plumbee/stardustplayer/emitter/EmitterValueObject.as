package com.plumbee.stardustplayer.emitter
{

import examples.coinBurst.StarlingRootClass;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.sd;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

use namespace sd;

public class EmitterValueObject
{
    private var _emitter : Emitter2D;
    private var _id : uint;
    private var _image : BitmapData;

    public function EmitterValueObject( emitterId : uint, emitter : Emitter2D )
    {
        _emitter = emitter;
        _id = emitterId;

	    const initializers : Array = _emitter.sd::initializers;
	    _emitter.particleHandler = new StarlingHandler(StarlingRootClass.canvas);
	    //Remove the two initializers we don't need
	    //Replace with starling one
	    //feed it the texture
	    for (var k:int = 0; k < initializers.length; k++) {
		    if(initializers[k] is BitmapParticleInit) {
			    _emitter.removeInitializer(initializers[k] as BitmapParticleInit);
			    k = k-1;
		    } else if(initializers[k] is PooledDisplayObjectClass) {
			    _emitter.removeInitializer(initializers[k] as PooledDisplayObjectClass);
			    k = k -1;
		    }
	    }

//	    _emitter.addInitializer(new PooledStarlingDisplayObjectClass(StardustMovieClipWrapper, [(_id)]));
	    _emitter.addInitializer(new StarlingDisplayObjectClass(StardustMovieClipWrapper, [(_id)]));
    }

    public function get id() : uint
    {
        return _id;
    }

    public function get emitter():Emitter2D
    {
        return _emitter;
    }

    public function get image() : BitmapData
    {
        return _image;
    }

    public function get smoothing() : Boolean
    {
        const inits : Array = _emitter.sd::initializers;
        const numInits : uint = inits.length;
        for (var i:uint=0; i < numInits; i++)
        {
            var bitmapInit : BitmapParticleInit = inits[i] as BitmapParticleInit;
            if ( bitmapInit )
            {
                return bitmapInit.smoothing;
            }
        }

        return false;
    }

    public function set image(imageBD : BitmapData) : void
    {
	    return;
        _image = imageBD;
        const initializers : Array = _emitter.sd::initializers;
        for (var k:int = 0; k < initializers.length; k++)
        {
            var bitmapParticleInit : BitmapParticleInit = initializers[k] as BitmapParticleInit;
            if ( bitmapParticleInit )
            {
                bitmapParticleInit.bitmapData = _image;
                return;
            }
        }
    }
}
}


import flash.display.Bitmap;
import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.display.bitmapParticle.IBitmapParticle;

import idv.cjcat.stardustextended.twoD.starling.IStardustStarlingParticle;


import starling.display.MovieClip;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

class StardustMovieClipWrapper extends MovieClip implements IStardustStarlingParticle, IBitmapParticle {

	[Embed(source="../../../../examples/coinBurst/emitterImage_0.png")]
	public static const Texture0 : Class;

	[Embed(source="../../../../examples/coinBurst/emitterImage_1.png")]
	public static const Texture1 : Class;

	[Embed(source="../../../../examples/coinBurst/emitterImage_2.png")]
	public static const Texture2 : Class;

	[Embed(source="../../../../examples/coinBurst/emitterImage_0.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture0:Class;

	[Embed(source="../../../../examples/coinBurst/emitterImage_1.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture1:Class;

	[Embed(source="../../../../examples/coinBurst/emitterImage_2.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture2:Class;

	public function StardustMovieClipWrapper(emitterId : uint/*, textureName : String*/)
	{
		var texture : Texture = getTexture(emitterId);
		var xml:XML;
		if(emitterId == 0) {
			xml = new XML(new AtlasTexture0());
		} else if (emitterId == 1) {
			xml = new XML(new AtlasTexture1());
		} else if (emitterId == 2) {
			xml = new XML(new AtlasTexture2());
		}

		var atlas:TextureAtlas = new TextureAtlas(texture, xml);
//		super(atlas.getTextures(textureName), 1);
		super(atlas.getTextures("coin"), 1);


//		width = getFrameTexture(0).width;
//		height = getFrameTexture(0).height;
//		x = -width / 2;
//		y = -height / 2;
//		pivotX = width * 0.5;
//		pivotY = height * 0.5;
//		rotation = 0;
//		loop = true;
		// important: add movie to juggler
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

	public static function getTexture(emitterId : uint) : Texture
	{
		var c : Class;
		c = Texture0;

		if(emitterId == 1) {
			c = Texture1;
		} else if (emitterId == 2) {
			c = Texture2;
		}
		var bitmap : Bitmap = new c();
		return Texture.fromBitmap(bitmap);
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