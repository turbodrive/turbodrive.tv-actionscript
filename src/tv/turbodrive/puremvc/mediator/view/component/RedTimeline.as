package tv.turbodrive.puremvc.mediator.view.component
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.puremvc.mediator.view.FooterCtrlVideoView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.MathUtils;
	
	public class RedTimeline extends RedlineIK
	{
		public static var MAINLINE_YMOVE:String = "mainLine_yMove"
		
		private var _wP2:Number
		private var _msk:Sprite = new Sprite()
		private var _lineContainer:Sprite = new Sprite();
		private var baseLine:Shape = new Shape();
		private var activeLine:Shape = new Shape();
		private var _progress:Number = 0
		
		private var rangeTimeButton:Array;
		private var buttonWRatio:Number;
		private var _currentButton:TimelineButton;
		private var menuX:Number = 0;
		private var _progressEnabled:Boolean = true;

		private var _tw:TweenMax;
		
		public function RedTimeline()
		{
			addChild(_msk)
			addChild(_lineContainer)
			_msk.addChild(p1)
			_msk.addChild(p2)
			_msk.addChild(p3)
			p3.width = 1280
				
			_lineContainer.mask = _msk
			baseLine.graphics.beginFill(0xDA4F4A,0.25);
			baseLine.graphics.drawRect(0,-36,1280,40);
			baseLine.graphics.endFill()
				
			activeLine.graphics.beginFill(0xDA4F4A,1);
			activeLine.graphics.drawRect(0,-36,1280,40);
			activeLine.graphics.endFill();			
				
			_lineContainer.addChild(baseLine);
			_lineContainer.addChild(activeLine)
			
			_wP2 = p2.width-2 // 2 est la marge interne à droite et à gauche
				
			this.filters = [new GlowFilter(0xDA4F4A,1,10,10,1,2)]
		}		
		
		public function open(time:Number = 0.15):void
		{
			if(_tw) _tw.pause()
			_tw = TweenMax.to(p2,time,{delay:0.15,rotation:-52, onUpdate:updateP3Pos, easing:Linear.easeNone});
			if(time == 0){
				baseLine.x = -baseLine.width-50
				TweenMax.to(baseLine,0.8,{x:0, ease:Linear.easeNone})
			}
		}		
		
		public function updateP3Pos():void
		{
			p3.x = p2.x + (Math.cos(MathUtils.degToRad(p2.rotation))*_wP2)-1
			p3.y = p2.y + (Math.sin(MathUtils.degToRad(p2.rotation))*_wP2)
			p3.width = FooterCtrlVideoView.sW-p3.x
			dispatchEvent(new NumberEvent(MAINLINE_YMOVE,this,p3.y,true))
		}		
		
		public function close():void
		{
			if(_tw) _tw.pause()
			_tw = TweenMax.to(p2,0.3,{rotation:0, onUpdate:updateP3Pos, easing:Linear.easeNone});			
		}
		
		public function setxlineAngle(xLineAngle:int):void
		{
			p1.width = xLineAngle
			p2.x = xLineAngle-1.5
			updateP3Pos()
			baseLine.width = FooterCtrlVideoView.sW
			if(buttonWRatio > 0) setTimelineButton()
						
		}
		
		public function setProgress(time:Number):void
		{
			if(!_progressEnabled) return
				
			//trace("buttonWRatio > " + buttonWRatio)
				
			if(buttonWRatio > 0){
				var targetW:Number = menuX + _currentButton.x  + ((time - rangeTimeButton[0])*buttonWRatio)
				activeLine.width += (targetW-activeLine.width)*0.35
			}else {
				activeLine.width = menuX
			}
			
			
		}
		
		public function setTimelineButton(b:TimelineButton = null):void
		{			
			_progressEnabled = false
			if(b){				
				_currentButton = b
			}
			var p:Page = _currentButton.page
			rangeTimeButton = p.rangeTime
			buttonWRatio = _currentButton.width/(rangeTimeButton[1]-rangeTimeButton[0]) ;
			setTimeout(reactivProgress,150)
		}		
		
		
		private function reactivProgress():void
		{
			_progressEnabled = true
		}
		
		public function setMenuX(x:Number):void
		{
			menuX = x;			
		}
	}
}