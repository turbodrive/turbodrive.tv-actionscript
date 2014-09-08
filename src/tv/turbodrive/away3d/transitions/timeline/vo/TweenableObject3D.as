package tv.turbodrive.away3d.transitions.timeline.vo
{
	import com.greensock.easing.Ease;
	
	import flash.geom.Vector3D;
	
	import tv.turbodrive.away3d.transitions.timeline.TimelineParams;
	
	public class TweenableObject3D
	{
		private var _x:Number
		private var _y:Number
		private var _z:Number
		private var _ease:Ease
		private var _duration:Number
		private var _delay:Number
		public var twFromStart:Boolean = true
		
		public function TweenableObject3D(init:Object) 
		{			
			if(!isNaN(init.x)) x = init.x as Number
			if(!isNaN(init.y)) y = init.y as Number
			if(!isNaN(init.z)) z = init.z as Number
			if(init.ease) ease = init.ease as Ease
			if(!isNaN(init.duration)) duration = init.duration as Number
			if(!isNaN(init.delay)) delay = init.delay as Number
			if(!isNaN(init.frameDuration)) frameDuration = init.durationFrame as Number
			if(!isNaN(init.frameDelay)) frameDuration = init.durationFrame as Number
			if(String(init.tweenFromStart) != "") twFromStart = init.tweenFromStart as Boolean
			if(init.position){
				x = init.position.x as Number
				y = init.position.y as Number
				z = init.position.z as Number
			}
		}
		
		public function set x(value:Number):void
		{
			_x = value
		}
		
		public function get x():Number
		{
			return _x
		}
		
		public function set y(value:Number):void
		{
			_y = value
		}
		
		public function get y():Number
		{
			return _y
		}
		
		public function set z(value:Number):void
		{
			_z = value
		}
		
		public function get z():Number
		{
			return _z
		}		
		
		public function set ease(value:Ease):void
		{
			_ease = value
		}
		
		public function get ease():Ease
		{
			return _ease
		}
		
		public function get position():Vector3D
		{
			return new Vector3D(x,y,z);
		}
		
		
		public function set duration(value:Number):void
		{
			_duration = value
		}
		
		public function set frameDuration(value:int):void
		{
			_duration = value/TimelineParams.FRAMERATE
		}
		
		public function set delay(value:Number):void
		{
			_delay = value
		}
		
		public function set frameDelay(value:int):void
		{
			_delay = value/TimelineParams.FRAMERATE
		}
		
		public function get duration():Number
		{
			return _duration
		}
		
		public function get frameDuration():int
		{
			return _duration*TimelineParams.FRAMERATE
		}
		
		public function get delay():Number
		{
			return _delay
		}
		
		public function get frameDelay():int
		{
			return _delay*TimelineParams.FRAMERATE
		}
		
		public function clone():Gp3DVO
		{
			var cloneGp3D:Gp3DVO = new Gp3DVO({
				position:		this.position,
				tweenFromStart:	this.twFromStart,
				ease:			this.ease,
				duration:		this.duration,
				delay:			this.delay
			})
			
			return cloneGp3D
			
		}
	}
}