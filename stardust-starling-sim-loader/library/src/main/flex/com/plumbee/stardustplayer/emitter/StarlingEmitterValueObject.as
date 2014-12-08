package com.plumbee.stardustplayer.emitter
{

import flash.display.BitmapData;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import starling.core.Starling;
import starling.textures.Texture;

use namespace sd;

public class StarlingEmitterValueObject extends EmitterValueObject
{
	public function StarlingEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);
	}

	public function prepareForStarling(textures : Vector.<Texture>) : void
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
		_emitter.particleHandler = new StarlingHandler(Starling.context);

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
}
}