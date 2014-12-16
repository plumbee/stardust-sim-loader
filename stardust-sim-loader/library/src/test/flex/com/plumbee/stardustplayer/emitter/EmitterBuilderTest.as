package com.plumbee.stardustplayer.emitter
{
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;

import org.flexunit.asserts.assertFalse;

use namespace sd;

public class EmitterBuilderTest
{
	[Embed(source="../../../../../../test/resources/emitter.xml", mimeType="application/octet-stream")]
	private static var XmlSource : Class;
	private static var xmlInstance : ByteArray = new XmlSource();
	private var emitterXml : XML;

	[Before]
	public function setUp() : void
	{
		emitterXml = new XML(xmlInstance.readUTFBytes(xmlInstance.length));
	}

	[Test]
	public function buildsWithwNoDisplayObjectInitializer() : void
	{

		var emitter : Emitter2D = EmitterBuilder.buildEmitter(emitterXml);

		var containsDiplayObjectClassInitializer : Boolean = false;
		for each (var initializer : Object in emitter.sd::initializers)
		{
			if (initializer is PooledDisplayObjectClass)
			{
				containsDiplayObjectClassInitializer = true;
			}
		}

		assertFalse(containsDiplayObjectClassInitializer);
	}
}
}
