package com.plumbee.stardustplayer.emitter
{
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.BitmapParticle;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.handlers.DisplayObjectHandler;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;

use namespace sd;

public class DisplayListEmitterValueObject extends BaseEmitterValueObject implements IDisplayListEmitter
{
	public function DisplayListEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);
	}

	private var _image : BitmapData;

	public function get image() : BitmapData
	{
		return _image;
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

	override public function destroy() : void
	{
		_image = null;
		super.destroy();
	}

	public function updateHandlerCanvas(canvas : DisplayObjectContainer) : void
	{
		(emitter.particleHandler as DisplayObjectHandler).container = canvas;
	}

	public function removeRendererSpecificInitializers() : void
	{
		for each(var initializerClass : Class in RendererSpecificInitializers.getList())
		{
			emitter.removeInitializersByClass(initializerClass);
		}
	}

	public function prepareForDisplayList() : void
	{
		addDisplayListInitializers();
	}

	public function addDisplayListInitializers() : void
	{
		_emitter.particleHandler = new DisplayObjectHandler();
		addPooledDisplayObjectClass();
	}

	protected function addPooledDisplayObjectClass() : void
	{
		_emitter.addInitializer(new PooledDisplayObjectClass(BitmapParticle));
	}
}
}
