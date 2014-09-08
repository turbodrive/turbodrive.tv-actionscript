package tv.turbodrive.utils.easing
{
	public class AboutTimelineEase
	{
		public static const PX1:Array = [{Px:51.05000,My:0,Nx:100.60000,Ny:-0.70000,Py:-147,Mx:0},{Px:15.95000,My:-147.70000,Nx:138.70000,Ny:-198.60000,Py:-21.05000,Mx:151.65000},{Px:-11.00000,My:-367.35000,Nx:204.70000,Ny:-266.70000,Py:134.05000,Mx:306.30000},{Mx:500,My:-500}]
		public static const PX2:Array = [{Px:51.05000,My:0,Nx:100.60000,Ny:-0.70000,Py:-147,Mx:0},{Px:11.95000,My:-147.70000,Nx:138.70000,Ny:-198.60000,Py:-12.05000,Mx:151.65000},{Px:-15.00000,My:-358.35000,Nx:212.70000,Ny:-284.70000,Py:143.05000,Mx:302.30000},{Mx:500,My:-500}]
		public static const PX3:Array = [{Px:21.05000,My:0,Nx:150.60000,Ny:1.30000,Py:-154,Mx:0},{Px:2.95000,My:-152.70000,Nx:128.70000,Ny:-192.60000,Py:-7.05000,Mx:171.65000},{Px:8.00000,My:-352.35000,Nx:188.70000,Ny:-298.70000,Py:151.05000,Mx:303.30000},{Mx:500,My:-500}]
		public static const PY1:Array = [{Px:-16.95000,My:0,Nx:168.60000,Ny:-58.70000,Py:-127,Mx:0},{Px:-26.05000,My:-185.70000,Nx:146.70000,Ny:-308.60000,Py:75.95000,Mx:151.65000},{Px:71.00000,My:-418.35000,Nx:156.70000,Ny:-164.70000,Py:83.05000,Mx:272.30000},{Mx:500,My:-500}]
		public static const PY2:Array = [{Px:57.05000,My:0,Nx:172.60000,Ny:1.30000,Py:-182,Mx:0},{Px:12.95000,My:-180.70000,Nx:110.70000,Ny:-190.60000,Py:-12.05000,Mx:229.65000},{Px:-18.00000,My:-383.35000,Nx:164.70000,Ny:-234.70000,Py:118.05000,Mx:353.30000},{Mx:500,My:-500}]
		public static const PZ1:Array = [{Px:25.05000,My:0,Nx:142.60000,Ny:3.30000,Py:-165,Mx:0},{Px:-1.05000,My:-161.70000,Nx:142.70000,Ny:-210.60000,Py:17.95000,Mx:167.65000},{Px:-50.00000,My:-354.35000,Nx:240.70000,Ny:-290.70000,Py:145.05000,Mx:309.30000},{Mx:500,My:-500}] 
		public static const PZ2:Array = [{Px:42.05000,My:0,Nx:94.6,Ny:5.30000,Py:-129,Mx:0},{Px:-12.05000,My:-123.70000,Nx:148.70000,Ny:-230.60000,Py:8.95000,Mx:136.65000},{Px:18.00000,My:-345.35000,Nx:208.70000,Ny:-308.70000,Py:154.05000,Mx:273.30000},{Mx:500,My:-500}]
		
		public static const RX1:Array = [{Px:45.05000,My:0,Nx:74.6,Ny:5.30000,Py:-138,Mx:0},{Px:7.95000,My:-132.70000,Nx:144.70000,Ny:-224.60000,Py:-3.05000,Mx:119.65000},{Px:11.00000,My:-360.35000,Nx:216.70000,Ny:-284.70000,Py:145.05000,Mx:272.30000},{Mx:500,My:-500}]
		public static const RX2:Array = [{Px:45.05000,My:0,Nx:74.6,Ny:5.30000,Py:-138,Mx:0},{Px:7.95000,My:-132.70000,Nx:144.70000,Ny:-224.60000,Py:-3.05000,Mx:119.65000},{Px:11.00000,My:-360.35000,Nx:216.70000,Ny:-284.70000,Py:145.05000,Mx:272.30000},{Mx:500,My:-500}]
		public static const RY:Array = [{Px:36.05000,My:0,Nx:74.6,Ny:5.30000,Py:-135,Mx:0},{Px:0.95000,My:-129.70000,Nx:138.70000,Ny:-302.60000,Py:62.95000,Mx:110.65000},{Px:21.00000,My:-369.35000,Nx:228.70000,Ny:-264.70000,Py:134.05000,Mx:250.30000},{Mx:500,My:-500}]
		public static const RZ:Array = [{Px:17.05000,My:0,Nx:150.60000,Ny:-4.70000,Py:-131,Mx:0},{Px:0.95000,My:-135.70000,Nx:146.70000,Ny:-212.60000,Py:-5.05000,Mx:167.65000},{Px:-16.00000,My:-353.35000,Nx:200.70000,Ny:-288.70000,Py:142.05000,Mx:315.30000},{Mx:500,My:-500}]
		
		private static var BASE_WIDTH:Number = 500;
			
		public static function px1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PX1)}
		public static function px2(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PX2)}
		public static function px3(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PX3)}
		public static function py1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PY1)}
		public static function py2(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PY2)}
		public static function pz1(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PZ1)}		
		public static function pz2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PZ2)}		

		public static function rx1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RX1)}
		public static function rx2(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RX2)}
		public static function ry(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RY)}		
		public static function rz(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RZ)}	
			
		
		public function AboutTimelineEase()
		{
		}
		
		
		public static function ease(t:Number, b:Number, c:Number, d:Number, _tweenArr:Array):Number
		{			
			var r:Number = BASE_WIDTH * t / d;
			
			for(var i:int = 0;r>_tweenArr[i+1].Mx;i++){}
			var o:Object = _tweenArr[i];
			
			if(o.Px != 0){
				r=(-o.Nx+Math.sqrt(o.Nx*o.Nx-4*o.Px*(o.Mx-r)))/(2*o.Px);
			}else{
				r=-(o.Mx-r)/o.Nx;
			}
			
			return b-c*((o.My+o.Ny*r+o.Py*r*r)/BASE_WIDTH);
		}
		
		
	}
}