package tv.turbodrive.utils
{
	import away3d.core.math.MathConsts;

	public class MathUtils
	{
		public static var ANGLE_SKEW_DEGREES:Number = 0
		
		public static function getSkewXPos(y:Number, angleDeg:Number = 1327850):Number
		{
			var angle:Number = angleDeg != 1327850 ? angleDeg : ANGLE_SKEW_DEGREES
			angle *= MathConsts.DEGREES_TO_RADIANS
			
			return Math.sin(angle)*y
		}
		
		static public function degToRad(angle:Number):Number
		{
			return  angle*(Math.PI / 180)
		}
	}
}