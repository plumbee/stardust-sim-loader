package com.plumbee.stardustplayer.emitter
{

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import starling.display.DisplayObjectContainer;

import starling.textures.Texture;

use namespace sd;

public class StarlingEmitterValueObject extends BaseEmitterValueObject implements IStarlingEmitter
{
	public function StarlingEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);
	}

	public function prepareForStarling(textures : Vector.<Texture>) : void
	{
		addStarlingInitializers(textures);
	}

	public function addStarlingInitializers(textures : Vector.<Texture>) : void
	{
		_emitter.particleHandler = new StarlingHandler();
		addPooledStarlingDisplayObjectClass(textures);
	}

	protected function addPooledStarlingDisplayObjectClass(textures : Vector.<Texture>) : void
	{
		_emitter.addInitializer(new PooledStarlingDisplayObjectClass(StardustStarlingMovieClip, [textures]));
	}


	public function updateHandlerCanvas(canvas : DisplayObjectContainer) : void
	{
		(emitter.particleHandler as StarlingHandler).container = canvas;
	}
}
}