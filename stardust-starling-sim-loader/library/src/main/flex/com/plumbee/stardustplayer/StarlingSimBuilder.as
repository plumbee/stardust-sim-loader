package com.plumbee.stardustplayer
{
import com.plumbee.stardustplayer.emitter.EmitterBuilder;
import com.plumbee.stardustplayer.emitter.StarlingEmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.utils.ByteArray;
import flash.utils.Dictionary;

import starling.textures.TextureAtlas;

public class StarlingSimBuilder
{
	private var _project : ProjectValueObject;
	private var texturesCount : int;

	public function StarlingSimBuilder()
	{
		_project = new ProjectValueObject();
	}

	public function withSDE(sde : ByteArray) : StarlingSimBuilder
	{

		var emitters : Vector.<ByteArray> = new StarlingSimZipLoader().extractEmittersFromZip(sde);

		for (var i : int = 0; i < emitters.length; i++)
		{
			var emitter : ByteArray = emitters[i];

			addEmitter(emitter, i);
		}

		return this;
	}

	public function withEmitter(emitterID : uint, emitterBA : ByteArray) : StarlingSimBuilder
	{
		addEmitter(emitterBA, emitterID);
		return this;
	}

	private function addEmitter(emitterBA : ByteArray, emitterID : uint) : void
	{
		var emitterXml : XML = new XML(emitterBA.readUTFBytes(emitterBA.length));
		var emitterVO : StarlingEmitterValueObject = new StarlingEmitterValueObject(emitterID, EmitterBuilder.buildEmitter(emitterXml));

		_project.emitters[emitterID] = emitterVO;
	}

	public function withTextures(prefix : String, textureAtlas : TextureAtlas) : StarlingSimBuilder
	{

		if (_project.emitters[texturesCount])
		{
			var emitterValueObject : StarlingEmitterValueObject = _project.emitters[texturesCount] as StarlingEmitterValueObject;
			emitterValueObject.prepareForStarling(textureAtlas.getTextures(prefix));

			texturesCount++;
		}
		else
		{
			throw new Error("There is no emitter with emitterID: " + texturesCount);
		}

		return this;
	}

	public function build() : ProjectValueObject
	{
		if (_project.numberOfEmitters != texturesCount)
		{
			throw new Error("You need a texture per emitter.");
		}

		return _project;
	}

}
}
