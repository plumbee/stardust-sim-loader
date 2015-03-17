package com.plumbee.stardustplayer
{
import com.plumbee.stardustplayer.emitter.EmitterBuilder;
import com.plumbee.stardustplayer.emitter.StarlingEmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.utils.ByteArray;

import starling.textures.Texture;

public class StarlingSimBuilder
{
	private var _project : ProjectValueObject;
	private var texturesCount : int;

	/* CURRENT USAGE:
	 var projectVO : ProjectValueObject = simBuilder.withSDE(assetInstance)
	 .withTextureAtlas(myTexture)
	 .withSingleTexture(myTexture)
	 .withTextureList(myVectorOfTextures)
	 .build();

	 The textures must be in the order they were introduced in the XML.

	 */
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

	public function withSingleTexture(texture: Texture): StarlingSimBuilder
	{
		if(_project.emitters[texturesCount])
		{
			var emitterValueObject : StarlingEmitterValueObject = _project.emitters[texturesCount] as StarlingEmitterValueObject;
			emitterValueObject.prepareForStarlingWithSingleTexture(texture);

			texturesCount++;
		}
		else
		{
			throw new Error("There is no emitter with emitterID: " + texturesCount);
		}

		return this;
	}

	public function withTextureAtlas(textureAtlas : Texture) : StarlingSimBuilder
	{

		if (_project.emitters[texturesCount])
		{
			var emitterValueObject : StarlingEmitterValueObject = _project.emitters[texturesCount] as StarlingEmitterValueObject;
			emitterValueObject.prepareForStarlingWithAtlas(textureAtlas);

			texturesCount++;
		}
		else
		{
			throw new Error("There is no emitter with emitterID: " + texturesCount);
		}

		return this;
	}

	public function withTextureList(textures: Vector.<Texture>): StarlingSimBuilder
	{
		if (_project.emitters[texturesCount])
		{
			var emitterValueObject : StarlingEmitterValueObject = _project.emitters[texturesCount] as StarlingEmitterValueObject;

			emitterValueObject.prepareForStarlingWithTextureList(textures);

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
		if(_project.numberOfEmitters==0) {
			throw new Error("You cannot build without emitters!");
		}

		if (_project.numberOfEmitters != texturesCount)
		{
			throw new Error("You need a texture per emitter.");
		}



		return _project;
	}

}
}
