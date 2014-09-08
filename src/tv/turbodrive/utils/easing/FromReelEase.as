package tv.turbodrive.utils.easing
{
	public class FromReelEase
	{
		private static var BASE_WIDTH:int = 500;
		
		public static const PX:Array = [{Px:-93.60000,My:0,Nx:340.60000,Ny:-26.70000,Py:-103,Mx:0},{Px:-18.70000,My:-129.70000,Nx:116,Ny:-192.60000,Py:-10.05000,Mx:247},{Px:31.00000,My:-332.35000,Nx:124.70000,Ny:-332.70000,Py:165.05000,Mx:344.30000},{Mx:500,My:-500}]
		public static const PY1:Array = [{Px:7.05000,My:0,Nx:180.60000,Ny:-24.70000,Py:-129,Mx:0},{Px:-5.05000,My:-153.70000,Nx:128.70000,Ny:-190.60000,Py:4.95000,Mx:187.65000},{Px:-30.00000,My:-339.35000,Nx:218.70000,Ny:-320.70000,Py:160.05000,Mx:311.30000},{Mx:500,My:-500}]
		public static const PY2:Array = [{Px:-20,My:0,Nx:104,Ny:-10.70000,Py:-107,Mx:0},{Px:16,My:-117.70000,Nx:116,Ny:-376.60000,Py:108.95000,Mx:84},{Px:98.70000,My:-385.35000,Nx:185.30000,Ny:-226.70000,Py:112.05000,Mx:216},{Mx:500,My:-500}]
		public static const PZ:Array = [{Px:-34.60000,My:0,Nx:294.60000,Ny:-16.70000,Py:-58,Mx:0},{Px:-67,My:-74.70000,Nx:252,Ny:-174.60000,Py:-64.05000,Mx:260},{Px:-8.30000,My:-313.35000,Nx:63.30000,Ny:-162.70000,Py:-23.95000,Mx:445},{Mx:500,My:-500}]
		
		public static const RIG:Array = [{Px:-4.95000,My:0,Nx:190.60000,Ny:-8.70000,Py:-124,Mx:0},{Px:-3.05000,My:-132.70000,Nx:168.70000,Ny:-236.60000,Py:-0.05000,Mx:185.65000},{Px:-34.00000,My:-369.35000,Nx:182.70000,Ny:-260.70000,Py:130.05000,Mx:351.30000},{Mx:500,My:-500}]
		public static const RIG2:Array = [{Px:21.05000,My:0,Nx:150.60000,Ny:5.30000,Py:-155,Mx:0},{Px:-11.05000,My:-149.70000,Nx:144.70000,Ny:-216.60000,Py:10.95000,Mx:171.65000},{Px:-6.00000,My:-355.35000,Nx:200.70000,Ny:-288.70000,Py:144.05000,Mx:305.30000},{Mx:500,My:-500}]
			
		public static const RX1:Array = [{Px:-0.95000,My:0,Nx:180.60000,Ny:-36.70000,Py:-100,Mx:0},{Px:7.95000,My:-136.70000,Nx:170.70000,Ny:-242.60000,Py:-21.05000,Mx:179.65000},{Px:-11.00000,My:-400.35000,Nx:152.70000,Ny:-204.70000,Py:105.05000,Mx:358.30000},{Mx:500,My:-500}]
		public static const RX2:Array = [{Px:-5.95000,My:0,Nx:184.60000,Ny:-32.70000,Py:-118,Mx:0},{Px:6.95000,My:-150.70000,Nx:154.70000,Ny:-226.60000,Py:-7.05000,Mx:178.65000},{Px:-17.00000,My:-384.35000,Nx:176.70000,Ny:-234.70000,Py:119.05000,Mx:340.30000},{Mx:500,My:-500}]	
		public static const RY:Array = [{Px:30.05000,My:0,Nx:130.60000,Ny:-10.70000,Py:-130,Mx:0},{Px:-7.05000,My:-140.70000,Nx:156.70000,Ny:-220.60000,Py:9.95000,Mx:160.65000},{Px:-27.00000,My:-351.35000,Nx:216.70000,Ny:-294.70000,Py:146.05000,Mx:310.30000},{Mx:500,My:-500}]
		public static const RZ:Array =[{Px:12.05000,My:0,Nx:166.60000,Ny:-4.70000,Py:-147,Mx:0},{Px:-11.05000,My:-151.70000,Nx:128.70000,Ny:-194.60000,Py:10.95000,Mx:178.65000},{Px:-17.00000,My:-335.35000,Nx:220.70000,Ny:-332.70000,Py:168.05000,Mx:296.30000},{Mx:500,My:-500}]
		
		public function FromReelEase()
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
		
		public static function px(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PX)}
		public static function py1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PY1)}
		public static function py2(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,PY2)}
		public static function pz(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PZ)}		
		public static function rig(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RIG)}
		public static function rig2(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RIG2)}
		public static function rx1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RX1)}
		public static function rx2(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RX2)}
		public static function ry(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RY)}		
		public static function rz(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,RZ)}
	}
}