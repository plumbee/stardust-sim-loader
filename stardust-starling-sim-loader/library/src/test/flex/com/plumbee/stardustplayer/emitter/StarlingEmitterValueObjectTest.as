package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;

import org.flexunit.asserts.assertEquals;

use namespace sd;

public class StarlingEmitterValueObjectTest
{
	private var _starlingEmitterValueObject : StarlingEmitterValueObject;

	[Before]
	public function setUp() : void
	{
		_starlingEmitterValueObject = new StarlingEmitterValueObject(0, new Emitter2D());

	}
	[Test]
	public function prepareForStarling_removesDisplayListInitializers() : void
	{
		_starlingEmitterValueObject.emitter.addInitializer(new BitmapParticleInit());
		_starlingEmitterValueObject.emitter.addInitializer(new PooledDisplayObjectClass());
		_starlingEmitterValueObject.prepareForStarling(null);
		var found : uint = 0;
		for (var i : int = 0; i < _starlingEmitterValueObject.emitter.initializers.length; i++)
		{
			if (_starlingEmitterValueObject.emitter.initializers[i] is BitmapParticleInit || _starlingEmitterValueObject.emitter.initializers[i] is PooledDisplayObjectClass)
			{
				found++;
			}
		}
		assertEquals(0, found);
	}

	[Test]
	public function prepareForStarling_addsStarlingDisplayObjectClassInitializer() : void
	{
		_starlingEmitterValueObject.prepareForStarling(null);
		var found : uint = 0;
		for (var i : int = 0; i < _starlingEmitterValueObject.emitter.initializers.length; i++)
		{
			if (_starlingEmitterValueObject.emitter.initializers[i] is StarlingDisplayObjectClass)
			{
				found++;
			}
		}
		assertEquals(1, found);
	}
}
}
