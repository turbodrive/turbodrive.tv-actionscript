package tv.turbodrive.utils.geom
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.core.math.MathConsts;
	
	public class RectangleRotation extends Rectangle
	{
		
		private var _rotation:Number = 0
		public var id:int = -1
		
		public function RectangleRotation(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}
		
		public function createFromVector3D(v1:Vector3D,v2:Vector3D,v3:Vector3D):void
		{
			x = v1.x
			y = v1.y
			
			var abDist:Number = v1.subtract(v2).length
			var caDist:Number = v1.subtract(v3).length
			var bcDist:Number = Math.sqrt(Math.pow(caDist, 2) - Math.pow(abDist,2));
			var amDist:Number = v2.y - v1.y
			var sign:Number = v2.x >= v1.x ? -1 : 1
			var cosMab:Number = amDist/abDist
			var mab:Number = Math.acos(cosMab)
			_rotation = ((mab*MathConsts.RADIANS_TO_DEGREES)*sign)

			height = abDist
			width = bcDist			
		}
		
		
		public function get rotation():Number
		{
			return _rotation
		}
	}
}