package com.plumbee.stardustplayer.emitter
{

import idv.cjcat.stardustextended.common.initializers.Initializer;
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.starling.ParticleConfig;
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
		emitter.particleHandler = new StarlingHandler();
		emitter.addInitializer(
				createStarlingInitializerWithTextures(textures)
		);
	}

	public function addStarlingInitializers() : void
	{
		emitter.particleHandler = new StarlingHandler();
		var bitmapInits : Vector.<Initializer> = emitter.getInitializersByClass(BitmapParticleInit);
		if (bitmapInits.length > 1)
		{
			throw(new Error("can't have multiple BitmapParticleInit"));
		}
		var bitmapInit:BitmapParticleInit = bitmapInits[0] as BitmapParticleInit;
		emitter.addInitializer(
				createStarlingInitializerFromBitmapInitializer(bitmapInit)
		);
	}

	public function updateHandlerCanvas(canvas : DisplayObjectContainer) : void
	{
		(emitter.particleHandler as StarlingHandler).container = canvas;
	}

	protected function createStarlingInitializerWithTextures(textures : Vector.<Texture>) : Initializer
	{
		return new PooledStarlingDisplayObjectClass(StarlingBitmapParticle, [textures]);
	}

	protected function createStarlingInitializerFromBitmapInitializer(initializer : BitmapParticleInit) : Initializer
	{
		var config : ParticleConfig = new ParticleConfig(initializer.spriteSheetAnimationSpeed, initializer.spriteSheetStartAtRandomFrame);

		return new PooledStarlingDisplayObjectClass(StarlingBitmapParticle, [getBitmapToTextureHelper().getTexturesFromBitmapParticleInit(initializer)], config);
	}

	protected function getBitmapToTextureHelper() : BitmapToTextureHelper
	{
		return new BitmapToTextureHelper();
	}
}
}