package tv.turbodrive.away3d.transitions.timeline.vo
{
	import com.greensock.easing.Ease;
	
	import flash.geom.Vector3D;

	public interface ITweenable
	{
		function set x(value:Number):void
		function set y(value:Number):void
		function set z(value:Number):void
		function set rotationX(value:Number):void
		function set rotationY(value:Number):void
		function set rotationZ(value:Number):void
		function set rigDistance(value:Number):void		
		function set ease(value:Ease):void
		function set delay(value:Number):void
		function set frameDelay(value:int):void
		function set duration(value:Number):void
		function set frameDuration(value:int):void
		function set rollCamera(value:Boolean):void
		function set target(value:TweenableObject3D):void
		
		function get x():Number
		function get y():Number
		function get z():Number
		function get rotationX():Number
		function get rotationY():Number
		function get rotationZ():Number
		function get rigDistance():Number
		function get ease():Ease
		function get delay():Number
		function get frameDelay():int
		function get duration():Number
		function get frameDuration():int
		function get position():Vector3D
		function get rollCamera():Boolean
		function get target():TweenableObject3D
		
		function toString():String
	}
}