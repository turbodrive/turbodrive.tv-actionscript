package tv.turbodrive.away3d.transitions.timeline.vo
{
	

	public class Gp3DVO extends RiggedCamVO implements ITweenable
	{
		//private var _localRz:Number
		private var _target:TweenableObject3D
		
		public function Gp3DVO(init:Object)
		{
			super(init);
			if(init.target){
				if(init.target is TweenableObject3D){
					target = init.target
				}else{
					target = new TweenableObject3D(init.target)
				}		
			}
		}
		
		public function set target(value:TweenableObject3D):void
		{
			_target = value
		}
		
		public function get target():TweenableObject3D {
			return _target
		}
		
		public function toString():String
		{
			return "x : " + x + " - y : " + y + " - z : " + z + " - rotationX : " + rotationX + " - rotationY : " + rotationY + " - rotation Z : " + rotationZ ; 
		}
		
		/*override public function clone():Gp3DVO
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
			if(target) cloneGp3D.target = this.target.clone();
				
			return cloneGp3D
			
		}*/
	}
}