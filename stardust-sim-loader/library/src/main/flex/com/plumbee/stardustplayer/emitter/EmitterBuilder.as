package com.plumbee.stardustplayer.emitter
{


import flash.net.registerClassAlias;

import idv.cjcat.stardustextended.common.CommonClassPackage;
import idv.cjcat.stardustextended.common.StardustElement;
import idv.cjcat.stardustextended.common.xml.XMLBuilder;
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.TwoDClassPackage;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.BitmapParticle;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

use namespace sd;

public class EmitterBuilder
{

	private static var builder : XMLBuilder;

	public static function buildEmitter(sourceXML : XML) : Emitter2D
	{
		registerClassAlias("BitmapParticle", BitmapParticle);
		if (builder == null)
		{
			builder = new XMLBuilder();
			builder.registerClassesFromClassPackage(CommonClassPackage.getInstance());
			builder.registerClassesFromClassPackage(TwoDClassPackage.getInstance());
			builder.registerClass(StarlingDisplayObjectClass);
			builder.registerClass(StarlingHandler);
		}
		builder.buildFromXML(sourceXML);

		var emitter2D : Emitter2D = (builder.getElementsByClass(Emitter2D) as Vector.<StardustElement>)[0] as Emitter2D;
		removeDependencies(emitter2D);

		return emitter2D;
	}

	private static function removeDependencies(emitter2D : Emitter2D) : void
	{
		const initializers : Array = emitter2D.sd::initializers;

		for (var i : int = 0; i < initializers.length; i++)
		{

			if (initializers[i] is PooledDisplayObjectClass)
			{
				emitter2D.removeInitializer(initializers[i] as PooledDisplayObjectClass);
				i = i - 1;
			}
		}
	}
}
}
