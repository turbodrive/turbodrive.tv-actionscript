package tv.turbodrive.utils
{
	public class Layout
	{
		static public const WIDTH:uint 	= 1280;
		static public const HEIGHT:uint = 720;
		
		static public const MIN_WIDTH:uint 	= 1024;
		static public const MIN_HEIGHT:uint = 620;
		
		
		public function Layout()
		{
		}
		
		static public function getRatioW(width:Number):Number
		{
			return (Math.max(width, MIN_WIDTH) - MIN_WIDTH) / (WIDTH - MIN_WIDTH);
		}
		
		static public function getRatioH(height:Number):Number
		{
			return (Math.max(height, MIN_HEIGHT) - MIN_HEIGHT) / (HEIGHT - MIN_HEIGHT);
		}
		
		static public function getSimpleRatio(value:Number, min:Number, max:Number):Number
		{
			var ratio:Number = (Math.max(value, min) - min) / (max - min);
			if (ratio > 1) ratio = 1
			if (ratio < 0) ratio = 0
			return ratio
		}
	}
}