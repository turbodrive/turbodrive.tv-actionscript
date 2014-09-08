package tv.turbodrive.utils
{

	public class PersonalEase 
	{
		
		public function PersonalEase() 
		{
			
		}
		
		public static function easeFromArray (t:Number, b:Number, c:Number, d:Number, _tweenArr:Array):Number {
			var BASE_WIDTH:Number = 500;
			var i:Number;
			var j:Object;
			var r:Number;
			
			r = BASE_WIDTH * t/d;
			for(i = 0;r>_tweenArr[i+1].Mx;i++){
			}
			j = _tweenArr[i];
			if(j.Px != 0){
				r=(-j.Nx+Math.sqrt(j.Nx*j.Nx-4*j.Px*(j.Mx-r)))/(2*j.Px);
			}else{
				r=-(j.Mx-r)/j.Nx;
			}
			return b-c*((j.My+j.Ny*r+j.Py*r*r)/BASE_WIDTH);
		}	
		
	}
	
}