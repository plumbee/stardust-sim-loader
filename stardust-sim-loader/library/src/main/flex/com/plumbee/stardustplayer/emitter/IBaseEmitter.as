package com.plumbee.stardustplayer.emitter
{
public interface IBaseEmitter
{
	function destroy() : void;
	function resetEmitter() : void;
	function get id() : uint;
	function removeRendererSpecificInitializers() : void;
}
}
