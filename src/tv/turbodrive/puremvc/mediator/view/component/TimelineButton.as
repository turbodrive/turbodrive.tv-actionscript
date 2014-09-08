package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.puremvc.mediator.view.FooterCtrlVideoView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.Styles;
	
	public class TimelineButton extends Sprite
	{
		static private var _LIST_BTN:Vector.<TimelineButton> = new Vector.<TimelineButton>();
		static private var _timeoutRollOut:Number
		
		private var _tfl:TextField
		
		private var _color:int;
		private var _hitArea:Sprite = new Sprite()
		
		private var _page:Page;
		private var _isProject:Boolean;
		
		private var _wLine:int = 0;	
		private var _over:Boolean = false;
		private var _active:Boolean = false
		
		static public const CLICK_BUTTON:String = "clickButton";

		private var _footer:FooterCtrlVideoView;
				
		public function TimelineButton(page:Page, footer:FooterCtrlVideoView)
		{
			_footer = footer
			_page = page
			_isProject = _page.isProject()
			_LIST_BTN.push(this)
			_color = _isProject ? 0xFEF7A0 : 0xD5EFC8
			_tfl = Styles.createButtonField("<menuTimeline>"+page.name.toUpperCase()+"</menuTimeline>",true);
			addChild(_tfl)		
			
			_tfl.textColor = _color	
				
			addChild(_hitArea);
			hitArea = _hitArea;
		
			mouseChildren = false;
			mouseEnabled = true;
			buttonMode = true;
			if(page.enabled) this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			if(!_isProject) highlightProjects();
		}
		
		public function get page():Page
		{
			return _page
		}
		
		public function set active(value:Boolean):void
		{
			_active = value
			highlight(true)
		}
		
		public function get active():Boolean
		{
			return _active
		}
		
		public function highlight(enable:Boolean = true):void
		{
			if(!_footer._openPlayer){
				// on évite de faire des tweens si le player est fermé
				if(enable){
					if(_active){
						alpha = 1
					}else{
						if(_over){
							alpha = 0.8
						}else{
							alpha = 0.5
						}
					}
				}else{
					if(_active){
						alpha = 0.35
					}else{
						alpha = 0.20
					}
				}	
			}else{
				
				if(enable){
					if(_active){
						TweenMax.to(this,0.3,{alpha:1})
					}else{
						if(_over){
							TweenMax.to(this,0.3,{alpha:0.8})
						}else{
							TweenMax.to(this,0.5,{alpha:0.5})
						}
					}
				}else{
					if(_active){
						TweenMax.to(this,0.3,{alpha:0.35})
					}else{
						TweenMax.to(this,0.5,{alpha:0.20})
					}
				}			
			}	
			
		}
		
		private function highlightProjects():void
		{
			for(var i:int = 0; i<_LIST_BTN.length; i++){
				var btn:TimelineButton = _LIST_BTN[i]
				if(btn.page.isProject()){
					btn.highlight(true)
				}else{
					btn.highlight(false)
				}
			}
		}
		
		private function highlightOthers():void
		{
			for(var i:int = 0; i<_LIST_BTN.length; i++){
				var btn:TimelineButton = _LIST_BTN[i]
				if(btn.page.isProject()){
					btn.highlight(false)
				}else{
					btn.highlight(true)
				}
			}
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			_over = false
			_timeoutRollOut = setTimeout(highlightProjects,150)		
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			_over = true
			if(_isProject){
				highlightProjects()	
			}else{
				clearTimeout(_timeoutRollOut)
				highlightOthers()
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{			
			dispatchEvent(new PageEvent(PageEvent.CHANGE_PAGE, page))
		}
		
		public function get wLine():int
		{
			return _wLine
		}
		
		public function setWidthLine(spaceLeft:int, useTflWidth:Boolean = true):void
		{
			_wLine = useTflWidth ? spaceLeft + _tfl.width : spaceLeft
			graphics.clear();
			graphics.beginFill(_color,1);
			graphics.drawRect(2,13,_wLine,3);
			graphics.endFill();
				
			_hitArea.graphics.clear();
			_hitArea.graphics.beginFill(0xFFFFFF,0.5);
			_hitArea.graphics.drawRect(0,-5,_wLine+3,23);
			_hitArea.graphics.endFill();
			_hitArea.visible = false;
		}
	}
}