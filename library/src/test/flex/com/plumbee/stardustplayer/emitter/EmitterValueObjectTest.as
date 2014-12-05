package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;

import org.flexunit.asserts.assertEquals;

use namespace sd;

public class EmitterValueObjectTest
{
	[Test]
	public function prepareForStarling_removesDisplayListInitializers() : void
	{
		var evo : EmitterValueObject = new EmitterValueObject(0, new Emitter2D());
		evo.emitter.addInitializer(new BitmapParticleInit());
		evo.emitter.addInitializer(new PooledDisplayObjectClass());
		evo.prepareForStarling(null);
		var found : uint = 0;
		for (var i : int = 0; i < evo.emitter.initializers.length; i++)
		{
			if (evo.emitter.initializers[i] is BitmapParticleInit || evo.emitter.initializers[i] is PooledDisplayObjectClass)
			{
				found++;
			}
		}
		assertEquals(0, found);
	}

	[Test]
	public function prepareForStarling_addsStarlingDisplayObjectClassInitializer() : void
	{
		var evo : EmitterValueObject = new EmitterValueObject(0, new Emitter2D());
		evo.prepareForStarling(null);
		var found : uint = 0;
		for (var i : int = 0; i < evo.emitter.initializers.length; i++)
		{
			if (evo.emitter.initializers[i] is StarlingDisplayObjectClass)
			{
				found++;
			}
		}
		assertEquals(1, found);
	}
}
}
