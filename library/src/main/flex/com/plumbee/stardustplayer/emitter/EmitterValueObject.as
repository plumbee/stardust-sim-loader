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

import starling.textures.Texture;

use namespace sd;

public class EmitterValueObject
{
	private var _emitter : Emitter2D;
	private var _id : uint;
	private var _image : BitmapData;

	public function EmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		_emitter = emitter;
		_id = emitterId;
	}

	public function prepareForStarling(textures: Vector.<Texture>) : void
	{
		removeDisplayListInitializers();
		addStarlingInitializers(textures);
	}

	private function addStarlingInitializers(textures : Vector.<Texture>) : void
	{
		_emitter.addInitializer(new StarlingDisplayObjectClass(StardustStarlingMovieClip, [textures]));
	}

	private function removeDisplayListInitializers() : void
	{
		const initializers : Array = _emitter.sd::initializers;
		_emitter.particleHandler = new StarlingHandler(StarlingRootClass.canvas);

		for (var i : int = 0; i < initializers.length; i++)
		{
			if (initializers[i] is BitmapParticleInit)
			{
				_emitter.removeInitializer(initializers[i] as BitmapParticleInit);
				i = i - 1;
			}
			else if (initializers[i] is PooledDisplayObjectClass)
			{
				_emitter.removeInitializer(initializers[i] as PooledDisplayObjectClass);
				i = i - 1;
			}
		}
	}

	public function get id() : uint
	{
		return _id;
	}

	public function get emitter() : Emitter2D
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
		for (var i : uint = 0; i < numInits; i++)
		{
			var bitmapInit : BitmapParticleInit = inits[i] as BitmapParticleInit;
			if (bitmapInit)
			{
				return bitmapInit.smoothing;
			}
		}

		return false;
	}

	public function set image(imageBD : BitmapData) : void
	{
		_image = imageBD;
		const initializers : Array = _emitter.sd::initializers;
		for (var k : int = 0; k < initializers.length; k++)
		{
			var bitmapParticleInit : BitmapParticleInit = initializers[k] as BitmapParticleInit;
			if (bitmapParticleInit)
			{
				bitmapParticleInit.bitmapData = _image;
				return;
			}
		}
	}
}
}