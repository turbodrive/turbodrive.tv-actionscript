package tv.turbodrive.away3d.transitions.timeline.vo
{
	
	public class RiggedCamVO extends TweenableObject3D
	{
	
		private var _rotationX:Number;
		private var _rotationY:Number;
		private var _rotationZ:Number;
		private var _rigDistance:Number;
		private var _rollCamera:Boolean = false;
		
		public function RiggedCamVO(init:Object)
		{
			super(init);
			if(!isNaN(init.rotationX)) rotationX = init.rotationX
			if(!isNaN(init.rotationY)) rotationY = init.rotationY
			if(!isNaN(init.rotationZ)) rotationZ = init.rotationZ
			if(!isNaN(init.rigDistance)) rigDistance = init.rigDistance as Number
		}
		
		public function get rollCamera():Boolean
		{
			return _rollCamera;
		}

		public function set rollCamera(value:Boolean):void
		{
			_rollCamera = value;
		}

		public function set rotationX(value:Number):void
		{
			_rotationX = value
		}
		
		public function get rotationX():Number
		{
			return _rotationX
		}
		
		public function set rotationY(value:Number):void
		{
			_rotationY = value
		}
		
		public function get rotationY():Number
		{
			return _rotationY
		}
		
		public function set rotationZ(value:Number):void
		{
			_rotationZ = value
		}
		
		public function get rotationZ():Number
		{
			return _rotationZ
		}
		
		public function set rigDistance(value:Number):void
		{
			_rigDistance = value
		}
		
		public function get rigDistance():Number
		{
			return _rigDistance
		}
		
		override public function clone():Gp3DVO
		{
			var cloneGp3D:Gp3DVO = new Gp3DVO({
				position:		this.position,
				rotationX:		this.rotationX,
				rotationY:		this.rotationY,
				rotationZ:		this.rotationZ,
				rigDistance:	this.rigDistance,
				tweenFromStart:	this.twFromStart,
				ease:			this.ease,
				duration:		this.duration,
				delay:			this.delay
			})
			
			return cloneGp3D
			
		}
	}
}