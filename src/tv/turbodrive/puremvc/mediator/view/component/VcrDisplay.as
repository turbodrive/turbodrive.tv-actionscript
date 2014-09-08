package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;

	public class VcrDisplay extends ControlDisplay
	{
		public function VcrDisplay()
		{
			super();
		}
		
		public function setTime(time:Number = 0):void			
		{
			var min:Number = int(time/60)
			var sec:Number = int(time%60)
			var mil:Number = int((time-int(time))*100)
			
			var minutes:String = String(min)
			var secondes:String = String(sec)
			var millisecondes:String = String(mil)
								
			if(minutes.length == 1) minutes = "0" + minutes
			if(secondes.length == 1) secondes = "0" + secondes
			if(millisecondes.length == 1) millisecondes = "0" + millisecondes
			
				
			this.m1_mc.gotoAndStop(int(minutes.substr(0,1))+1)
			this.m2_mc.gotoAndStop(int(minutes.substr(1,1))+1)
				
			this.s1_mc.gotoAndStop(int(secondes.substr(0,1))+1)
			this.s2_mc.gotoAndStop(int(secondes.substr(1,1))+1)
				
			this.ml1_mc.gotoAndStop(int(millisecondes.substr(0,1))+1)
			this.ml2_mc.gotoAndStop(int(millisecondes.substr(1,1))+1)
							
			
			/*this.timeDigital_txt.text = secondes+":"+millisecondes*/
				
			status_mc.gotoAndStop("play")
		}				
	}
}