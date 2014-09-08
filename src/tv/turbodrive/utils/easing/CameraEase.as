package tv.turbodrive.utils.easing
{
	public class CameraEase
	{
		private static const BASE_WIDTH:Number = 500
		
		public static const BACK_IN_SMOOTH_OUT_1:Array = [{Py:9,Px:-17.95000,My:0,Nx:104.60000,Ny:3.30000,Mx:0},{Py:-420.05000,Px:-120.05000,My:12.30000,Nx:376.70000,Ny:119.40000,Mx:86.65000},{Py:213.15000,Px:70.00000,My:-288.35000,Nx:86.70000,Ny:-424.80000,Mx:343.30000},{My:-500,Mx:500}];
		public static const BACK_IN_SMOOTH_OUT_2:Array = [{Py:19,Px:-11,My:0,Nx:47,Ny:-5,Mx:0},{Py:-558,Px:-74,My:14,Nx:161,Ny:261,Mx:36},{Py:182,Px:72,My:-283,Nx:0,Ny:-387,Mx:123},{Py:1,Px:-68,My:-488,Nx:373,Ny:-13,Mx:195},{My:-500,Mx:500}]
		public static const BACK_IN_SMOOTH_OUT_2b:Array = [{Py:17,Px:-1.95000,My:0,Nx:48.6,Ny:7.30000,Mx:0},{Py:-444.05000,Px:-10.35000,My:24.30000,Nx:122.70000,Ny:19.40000,Mx:46.65000},{Py:131.15000,Px:293,My:-400.35000,Nx:48,Ny:-230.80000,Mx:159},{My:-500,Mx:500}]
		
		/*-- TRANSITION 1------*/
		/* Rotations */
		public static const RX_1:Array = [{Py:-26,Px:-23,My:0,Nx:159,Ny:-31,Mx:0},{Py:-49,Px:-23,My:-57,Nx:141,Ny:-113,Mx:136},{Py:24,Px:-6,My:-219,Nx:117,Ny:-217,Mx:254},{Py:73,Px:20,My:-412,Nx:115,Ny:-161,Mx:365},{My:-500,Mx:500}];
		public static const RYA_1:Array = [{Py:-24,Px:48,My:0,Nx:77,Ny:5,Mx:0},{Py:-44,Px:-39,My:-19,Nx:199,Ny:-71,Mx:125},{Py:-21,Px:-24,My:-134,Nx:143,Ny:-189,Mx:285},{Py:157,Px:-27,My:-344,Nx:123,Ny:-313,Mx:404},{My:-500,Mx:500}];
		public static const RYB_1:Array = [{Py:-116,Px:16,My:0,Nx:107,Ny:5,Mx:0},{Py:0,Px:2,My:-111,Nx:115,Ny:-157,Mx:123},{Py:8,Px:8,My:-268,Nx:105,Ny:-153,Mx:240},{Py:88,Px:2,My:-413,Nx:145,Ny:-175,Mx:353},{My:-500,Mx:500}];
		public static const RZ_1:Array = [{Py:-19,Px:4,My:0,Nx:127,Ny:3,Mx:0},{Py:-54,Px:-61,My:-16,Nx:239,Ny:-63,Mx:131},{Py:-92,Px:20,My:-133,Nx:87,Ny:-155,Mx:309},{Py:133,Px:-21,My:-380,Nx:105,Ny:-253,Mx:416},{My:-500,Mx:500}];
		
		/* Positions */
		public static const PX_1:Array = [{Py:-74,Px:-1,My:0,Nx:165,Ny:-1,Mx:0},{Py:-78,Px:25,My:-75,Nx:81,Ny:-97,Mx:164},{Py:-25,Px:39,My:-250,Nx:57,Ny:-123,Mx:270},{Py:101,Px:-27,My:-398,Nx:161,Ny:-203,Mx:366},{My:-500,Mx:500}]
		public static const PY_1:Array = [{Py:-48,Px:23,My:0,Nx:107,Ny:3,Mx:0},{Py:-62,Px:0,My:-45,Nx:127,Ny:-109,Mx:130},{Py:1,Px:10,My:-216,Nx:99,Ny:-175,Mx:257},{Py:109,Px:-37,My:-390,Nx:171,Ny:-219,Mx:366},{My:-500,Mx:500}]
		public static const PZA_1:Array = [{Py:-82,Px:11,My:0,Nx:125,Ny:1,Mx:0},{Py:-16,Px:-3,My:-81,Nx:119,Ny:-155,Mx:136},{Py:10,Px:-1,My:-252,Nx:107,Ny:-169,Mx:252},{Py:102,Px:13,My:-411,Nx:129,Ny:-191,Mx:358},{My:-500,Mx:500}];
		public static const PZB_1:Array = [{Py:-109,Px:31,My:0,Nx:69,Ny:-17,Mx:0},{Py:31,Px:-14,My:-126,Nx:127,Ny:-219,Mx:100},{Py:51,Px:25,My:-314,Nx:131,Ny:-211,Mx:213},{Py:29,Px:38,My:-474,Nx:93,Ny:-55,Mx:369},{My:-500,Mx:500}]
		
		/*-- TRANSITION VERS PAGE MORE PROJECTS --*/
		public static const PX_mp:Array =[{Py:-130,Px:0.05000,My:0,Nx:166.60000,Ny:3.30000,Mx:0},{Py:2.95000,Px:-3.05000,My:-126.70000,Nx:170.70000,Ny:-248.60000,Mx:166.65000},{Py:127.05000,Px:-27.00000,My:-372.35000,Nx:192.70000,Ny:-254.70000,Mx:334.30000},{My:-500,Mx:500}]
		public static const PY_mp:Array =[{Py:-91,Px:16,My:0,Nx:93,Ny:5,Mx:0},{Py:-14,Px:-2,My:-86,Nx:105,Ny:-163,Mx:109},{Py:21,Px:15,My:-263,Nx:99,Ny:-185,Mx:212},{Py:76,Px:-5,My:-427,Nx:179,Ny:-149,Mx:326},{My:-500,Mx:500}]
		public static const PZ_mp:Array =[{Py:-74,Px:-4,My:0,Nx:133,Ny:5,Mx:0},{Py:-3,Px:-12,My:-69,Nx:143,Ny:-169,Mx:129},{Py:-2,Px:0,My:-241,Nx:115,Ny:-151,Mx:260},{Py:107,Px:-46,My:-394,Nx:171,Ny:-213,Mx:375},{My:-500,Mx:500}]
		public static const RX_mp:Array =[{Py:-74,Px:40,My:0,Nx:93,Ny:1,Mx:0},{Py:-30,Px:-1,My:-73,Nx:137,Ny:-127,Mx:133},{Py:-43,Px:29,My:-230,Nx:107,Ny:-143,Mx:269},{Py:83,Px:-24,My:-416,Nx:119,Ny:-167,Mx:405},{My:-500,Mx:500}]
		public static const RY_mp:Array =[{Py:-80,Px:10,My:0,Nx:115,Ny:1,Mx:0},{Py:17,Px:-20,My:-79,Nx:131,Ny:-169,Mx:125},{Py:7,Px:0,My:-231,Nx:91,Ny:-143,Mx:236},{Py:136,Px:-22,My:-367,Nx:195,Ny:-269,Mx:327},{My:-500,Mx:500}]
		public static const RZ_mp:Array =[{Py:-97,Px:31,My:0,Nx:63,Ny:3,Mx:0},{Py:29,Px:-14,My:-94,Nx:131,Ny:-197,Mx:94},{Py:21,Px:-3,My:-262,Nx:127,Ny:-173,Mx:211},{Py:85,Px:-16,My:-414,Nx:181,Ny:-171,Mx:335},{My:-500,Mx:500}]

		/*-- TRANSITION VERS PAGE PROJECT Focus --*/
		public static const PX_mp2:Array =[{Py:-63,Px:-8,My:0,Nx:125,Ny:1,Mx:0},{Py:8,Px:-24,My:-62,Nx:159,Ny:-197,Mx:117},{Py:10,Px:-2,My:-251,Nx:121,Ny:-173,Mx:252},{Py:85,Px:-4,My:-414,Nx:133,Ny:-171,Mx:371},{My:-500,Mx:500}]
		public static const PY_mp2:Array =[{Py:-57,Px:-12,My:0,Nx:131,Ny:9,Mx:0},{Py:-30,Px:-29,My:-48,Nx:149,Ny:-153,Mx:119},{Py:9,Px:-2,My:-231,Nx:83,Ny:-169,Mx:239},{Py:108,Px:49,My:-391,Nx:131,Ny:-217,Mx:320},{My:-500,Mx:500}]
		public static const PZ_mp2:Array =[{Py:-140,Px:20,My:0,Nx:101,Ny:5,Mx:0},{Py:7,Px:-5,My:-135,Nx:89,Ny:-167,Mx:121},{Py:41,Px:13,My:-295,Nx:103,Ny:-191,Mx:205},{Py:48,Px:46,My:-445,Nx:133,Ny:-103,Mx:321},{My:-500,Mx:500}]
		
		public static const RX_mp2:Array =[{Py:-81,Px:4,My:0,Nx:91,Ny:3,Mx:0},{Py:-10,Px:-2,My:-78,Nx:81,Ny:-123,Mx:95},{Py:-5,Px:3,My:-211,Nx:84,Ny:-137,Mx:174},{Py:148,Px:36,My:-353,Nx:203,Ny:-295,Mx:261},{My:-500,Mx:500}]
		public static const RY_mp2:Array =[{Py:-89,Px:12,My:0,Nx:119,Ny:3,Mx:0},{Py:5,Px:-8,My:-86,Nx:123,Ny:-159,Mx:131},{Py:3,Px:-2,My:-240,Nx:111,Ny:-157,Mx:246},{Py:107,Px:-2,My:-394,Nx:147,Ny:-213,Mx:355},{My:-500,Mx:500}]
		public static const RZ_mp2:Array =[{Py:-75,Px:1,My:0,Nx:121,Ny:1,Mx:0},{Py:14,Px:-15,My:-74,Nx:149,Ny:-197,Mx:122},{Py:-5,Px:6,My:-257,Nx:111,Ny:-157,Mx:256},{Py:82,Px:-16,My:-419,Nx:143,Ny:-163,Mx:373},{My:-500,Mx:500}]
			
			
		public static function pxmp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PX_mp)}
		public static function pymp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PY_mp)}
		public static function pzmp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PZ_mp)}
		public static function rxmp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RX_mp)}
		public static function rymp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RY_mp)}
		public static function rzmp(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RZ_mp)}
		
		public static function pxmp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PX_mp2)}
		public static function pymp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PY_mp2)}
		public static function pzmp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,PZ_mp2)}
		public static function rxmp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RX_mp2)}
		public static function rymp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RY_mp2)}
		public static function rzmp2(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RZ_mp2)}
		
		
		
		public static function rx1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,RX_1)}
		public static function rya1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,RYA_1)}
		public static function ryb1(t:Number, b:Number, c:Number, d:Number):Number{return ease(t,b,c,d,RYB_1)}
		public static function rz1(t:Number, b:Number, c:Number, d:Number):Number {return ease(t,b,c,d,RZ_1)}		
		public static function px1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,PX_1)}
		public static function py1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,PY_1)}
		public static function pza1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,PZA_1)}
		public static function pzb1(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,PZB_1)}
		
		public static function backInSmoothOut(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,BACK_IN_SMOOTH_OUT_1)}		
		public static function backInSmoothOut2(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,BACK_IN_SMOOTH_OUT_1)}
		
		public static const INTRO_ABOUT_PX:Array = [{Py:-128,Px:48,My:0,Nx:110,Ny:-282,Mx:0},{Py:42,Px:-5,My:-410,Nx:64,Ny:-140,Mx:158},{Py:37,Px:15,My:-508,Nx:66,Ny:-82,Mx:217},{Py:32,Px:10,My:-553,Nx:62,Ny:-4,Mx:298},{Py:-31,Px:48,My:-525,Nx:82,Ny:56,Mx:370},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_PY:Array = [{Py:-74,Px:24,My:0,Nx:56,Ny:-190,Mx:0},{Py:83,Px:-20,My:-264,Nx:100,Ny:-320,Mx:80},{Py:94,Px:39,My:-501,Nx:100,Ny:-186,Mx:160},{Py:56,Px:15,My:-593,Nx:66,Ny:-8,Mx:299},{Py:-45,Px:30,My:-545,Nx:90,Ny:90,Mx:380},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_PZ:Array = [{Py:2,Px:9,My:0,Nx:113,Ny:29,Mx:0},{Py:-74,Px:-62,My:31,Nx:239,Ny:65,Mx:122},{Py:-227,Px:-15,My:22,Nx:129,Ny:-85,Mx:299},{Py:209,Px:10,My:-290,Nx:77,Ny:-419,Mx:413},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_RX:Array = [{Py:9,Px:4,My:0,Nx:87,Ny:-1,Mx:0},{Py:-198,Px:-6,My:8,Nx:156,Ny:69,Mx:91},{Py:8,Px:1,My:-121,Nx:119,Ny:-249,Mx:241},{Py:137,Px:-8,My:-362,Nx:147,Ny:-275,Mx:361},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_RY:Array = [{Py:-94,Px:-20,My:0,Nx:175,Ny:3,Mx:0},{Py:-6,Px:-5,My:-91,Nx:103,Ny:-139,Mx:155},{Py:7,Px:0,My:-236,Nx:87,Ny:-151,Mx:253},{Py:119,Px:5,My:-380,Nx:155,Ny:-239,Mx:340},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_RZ:Array = [{Py:32,Px:36,My:0,Nx:73,Ny:-7,Mx:0},{Py:-255,Px:-67,My:25,Nx:237,Ny:113,Mx:109},{Py:60,Px:7,My:-117,Nx:73,Ny:-357,Mx:279},{Py:83,Px:54,My:-414,Nx:87,Ny:-169,Mx:359},{My:-500,Mx:500}]
		public static const INTRO_ABOUT_DIST:Array = [{Py:-94,Px:31,My:0,Nx:99,Ny:-25,Mx:0},{Py:-6,Px:1,My:-119,Nx:105,Ny:-143,Mx:130},{Py:-6,Px:11,My:-268,Nx:89,Ny:-127,Mx:236},{Py:98,Px:-37,My:-401,Nx:201,Ny:-197,Mx:336},{My:-500,Mx:500}]
		
		public static function aboutIntroPx(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_PX)}
		public static function aboutIntroPy(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_PY)}
		public static function aboutIntroPz(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_PZ)}
		public static function aboutIntroRx(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_RX)}
		public static function aboutIntroRy(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_RY)}
		public static function aboutIntroRz(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_RZ)}
		public static function aboutIntroDist(t:Number, b:Number, c:Number, d:Number):Number	{return ease(t,b,c,d,INTRO_ABOUT_DIST)}
		
		
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