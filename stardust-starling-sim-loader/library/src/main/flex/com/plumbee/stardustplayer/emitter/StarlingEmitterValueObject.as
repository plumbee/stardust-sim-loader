package com.plumbee.stardustplayer.emitter
{

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;
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

	public function addStarlingInitializers(textures : Vector.<Texture>) : void
	{
		_emitter.particleHandler = new StarlingHandler(Starling.context);
		addPooledStarlingDisplayObjectClass(textures);
	}

	protected function addPooledStarlingDisplayObjectClass(textures : Vector.<Texture>) : void
	{
		_emitter.addInitializer(new PooledStarlingDisplayObjectClass(StardustStarlingMovieClip, [textures]));
	}

	public function removeDisplayListInitializers() : void
	{
		const initializers : Array = _emitter.sd::initializers;

		for (var i : int = 0; i < initializers.length; i++)
		{
			if (initializers[i] is BitmapParticleInit || initializers[i] is PooledDisplayObjectClass)
			{
				_emitter.removeInitializer(initializers[i]);
				i = i - 1;
			}
		}
	}
}
}