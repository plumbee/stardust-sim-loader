package com.plumbee.stardustplayer.emitter
{
import starling.display.DisplayObjectContainer;
import starling.textures.Texture;

public interface IStarlingEmitter extends IBaseEmitter
{

	function updateHandlerCanvas(target : DisplayObjectContainer) : void;

	function prepareForStarlingWithAtlas(textureAtlas : Texture) : void;

	function prepareForStarlingWithTextureList(textureList : Vector.<Texture>) : void;

	function prepareForStarlingWithSingleTexture(texture : Texture) : void;
}
}
