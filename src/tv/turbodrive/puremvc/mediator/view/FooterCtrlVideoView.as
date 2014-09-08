package tv.turbodrive.puremvc.mediator.view
{
	
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.mediator.view.component.RedTimeline;
	import tv.turbodrive.puremvc.mediator.view.component.TimelineButton;
	import tv.turbodrive.puremvc.mediator.view.component.VcrDisplay;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.ReelNetStream;
	
	public class FooterCtrlVideoView extends Sprite
	{
		static public const BASE_WIDTH:uint = 1280;
		static public const BASE_HEIGHT:uint = 720;		
		static public const MIN_WIDTH:uint 	= 995;
		
		static public const ON_OPEN:String = "FooterOpen";
		static public const ON_CLOSE:String = "FooterClose";
		static public const ON_START_CLOSING:String = "FooterStartClosing";
		
		public static var sH:int;
		public static var sW:int;		
		private var ratioW:Number;		
		
		private var hit:Sprite;		
		private var _tmlneMask:RedTimeline
		private var _display:VcrDisplay
		private var _menu:Sprite = new Sprite()
		
		private var _buttonList:Vector.<TimelineButton>;

		private var xLineAngle:int;
		private var wTotalButtons:Number = 0;
		private var mainLayer:Sprite = new Sprite();
		private var blurLayer:Sprite = new Sprite();
		private var _glowBitmap:Bitmap
		private var yOffset:int = 5
		private var _grid:Bitmap = new Bitmap(new FooterHexaGrid(1280,194));
		private var _gradientBg:Sprite = new BlackGradientFooter();
		private var _firstTime:Boolean;
		private var _glowAnimated:Boolean = false;
		public var _openPlayer:Boolean = false;

		private var _twDisplay:TweenMax;
		private var _twMenu:TweenMax;
		private var _twMain:TweenMax;
		private var _twGrid:TweenMax;
		private var _twGradient:TweenMax;
		private var _glowTimeout:uint = 0;
		private var _twGlow:TweenMax;
		private var _forceRollOut:Boolean = false;
		private var _reelRollOver:Boolean = false;
		private var count2:uint = 0
			
		private var _twHit:TweenMax;
		
		public function FooterCtrlVideoView(firstTime:Boolean = true)
		{
			this.firstTime = firstTime
			addChild(_gradientBg)
			_gradientBg.mouseEnabled = _gradientBg.mouseChildren = false
			addChild(_grid)
			_grid.alpha = _gradientBg.alpha = 0
			addChild(mainLayer)
			mainLayer.mouseEnabled = false
			mainLayer.blendMode = BlendMode.ADD
			mainLayer.alpha = 0.7
			
			_tmlneMask = new RedTimeline();
			_tmlneMask.addEventListener(RedTimeline.MAINLINE_YMOVE, mainRedLineMoveHandler)
			mainLayer.addChild(_tmlneMask)
			_display = new VcrDisplay();
			mainLayer.addChild(_display);
			_display.alpha = 0			
			mainLayer.addChild(_menu)
			
			_tmlneMask.y = 35 + yOffset
			_display.y = 0 + yOffset
			_menu.y = 20 + yOffset
			_grid.y = -120 + yOffset
			_gradientBg.y = -55 + yOffset - 100
			_gradientBg.height = 230
			
			hit = new Sprite();
			hit.visible = false
			hit.y = 20
			this.hitArea = hit
			addChild(hit);		
				
			this.mouseEnabled = true
			this.mouseChildren = true
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			
			ReelVideoPlayer.instance.addEventListener(ReelVideoPlayer.TICK_STREAM, tickNetStream);
				
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		
		public function set firstTime(value:Boolean):void
		{
			_firstTime = value
		}
				
		protected function mainRedLineMoveHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private function updateGlow(e:Event = null):void
		{	
			count2 ++
			if(count2/2 != count2 >>1) return
			
			mainLayer.alpha = 1
			var bData:BitmapData = new BitmapData(mainLayer.width,mainLayer.height+15,true,0x00000000);
			bData.draw(mainLayer)
			bData.applyFilter(bData,new Rectangle(0,0,mainLayer.width, mainLayer.height), new Point(0,0), new BlurFilter(10,10,2));
			mainLayer.alpha = (Math.random()*0.1) + 0.65
			
			if(!_glowBitmap){
				_glowBitmap = new Bitmap();
				//_glowBitmap.blendMode = BlendMode.ADD;
				//_glowBitmap.y = -250
				addChildAt(_glowBitmap,1)
				
			}else{
				_glowBitmap.bitmapData = bData;
			}			
		}	
		
		protected function addedToStageHandler(event:Event):void
		{			
									
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler)
			resize()
			y = sH
			
			if(_firstTime){
				openAndClose()				
				//_firstTime = false
			}else{
				rollOutHandler(null);
			}
		}
		
		public function openAndClose(invisibleButtons:Boolean = false):void
		{
			/*if(_buttonList){
				for(var i:int = 0; i<_buttonList.length; i++){
					var btn:TimelineButton = TimelineButton(_buttonList[i]);
					btn.visible = !invisibleButtons
				}
			}*/
			
			trace("openAndClose >>> openAndClose >>> invisibleButtons " + invisibleButtons)
			
			if(invisibleButtons){
				firstOver()
			}else{
				rollOverHandler(null)
			}			
			
			setTimeout(rollOutHandler,2800);
		}
		
		protected function removeFromStageHandler(event:Event):void
		{
			stopGlow();
			stage.removeEventListener(Event.RESIZE, resizeHandler)
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		private function startGlow():void
		{
			if(_glowAnimated) return
			count2 = 0
			//addEventListener(Event.ENTER_FRAME, updateGlow);
			_glowAnimated = true
		}
		
		private function stopGlow():void
		{
			if(!_glowAnimated) return
			//removeEventListener(Event.ENTER_FRAME, updateGlow);
			_glowAnimated = false
		}
		
		public function createMenu(reelPages:Vector.<Page>):void
		{
			if(_buttonList){
				// déjà créé
				return
			}
			
			_buttonList = new Vector.<TimelineButton>();
			
			//var xBtn:int = 0
			for(var i:int = 0; i< reelPages.length ;i++){
				var page:Page = reelPages[i]
				var btn:TimelineButton = new TimelineButton(page, this)
				if(!page.isProject()) btn.y = 23
				_buttonList.push(btn)
				_menu.addChild(btn)
				if(page.id != PagesName.RANDD) wTotalButtons += btn.width
			}
			
			updateButtonsPosition()
		}
		
		public function updateMenuState(p:Page):void
		{
			for(var i:int= 0; i<_buttonList.length;i++){
				var b:TimelineButton = TimelineButton(_buttonList[i])
				if(b.page.id == p.id){
					b.active = true
					_tmlneMask.setTimelineButton(b)
				}else{
					b.active = false
				}
			}
		}
		
		private function stopCurrentTweens():void
		{
			if(_twMain) _twMain.pause()
			if(_twDisplay) _twDisplay.pause()
			if(_twMenu) _twMenu.pause()
			if(_twGrid) _twGrid.pause()
			if(_twGradient) _twGradient.pause()
			if(_twGlow) _twGlow.pause()
			if(_twHit) _twHit.pause();
		}
		
		private function firstOver():void
		{	
			_reelRollOver = true
			_openPlayer = true
			_tmlneMask.open(0);	
			stopCurrentTweens()
			y = (sH-73- yOffset)
			//_twMain = TweenMax.to(this,0.5,{delay:0.2, y:(sH-73- yOffset), onStart:dispatchOpen})
			_display.alpha = 0
			_twDisplay = TweenMax.to(_display,1,{alpha:1, delay:1.2})
			_menu.visible = false
			_menu.alpha = 0
			//_twMenu = TweenMax.to(_menu,0.8,{alpha:1})
			_twGrid = TweenMax.to(_grid,0.3,{autoAlpha:0.25})
			_twGradient = TweenMax.to(_gradientBg,0.8,{autoAlpha:0.5});
			mainLayer.alpha = 1
			if(_glowBitmap) _twGlow = TweenMax.to(_glowBitmap,0.2,{autoAlpha:1})
			
			//clearInterval(_glowTimeout)
			//_glowTimeout = setTimeout(startGlow,300);x
			/*if(_forceRollOut){
				_forceRollOut = false
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
			}*/
		}
		
		public function rollOverHandler(event:MouseEvent = null):void
		{	
			if(event){
				_reelRollOver = true
			}else{
				_reelRollOver = false
			}
			_openPlayer = true
			_tmlneMask.open();
			stopCurrentTweens()
			_twMain = TweenMax.to(this,0.25,{delay:0.1, y:(sH-73 - yOffset), onStart:dispatchOpen})
			_twDisplay = TweenMax.to(_display,0.25,{delay:0.25,alpha:1})
			_twMenu = TweenMax.to(_menu,0.4,{delay:0.2,autoAlpha:1})
			_twGrid = TweenMax.to(_grid,0.15,{delay:0.1, autoAlpha:0.25})		
			_twGradient = TweenMax.to(_gradientBg,0.4,{delay:0.1, autoAlpha:1})
			if(_glowBitmap) _twGlow = TweenMax.to(_glowBitmap,0.1,{delay:0.1, autoAlpha:1})
			_twHit = TweenMax.to(hit, 0.25, {y:-20})
			
			clearInterval(_glowTimeout)
			_glowTimeout = setTimeout(startGlow,300);
			if(_forceRollOut){
				_forceRollOut = false
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
			}
		}
		
		public function rollOutHandler(event:MouseEvent = null):void
		{
			if(!event){
				if(_reelRollOver){
					_reelRollOver = false
					//return
				}				
				_forceRollOut = true
				addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
			}
			
			_reelRollOver = false
			clearInterval(_glowTimeout)
			stopCurrentTweens()
			_tmlneMask.close();
			
			_twMain = TweenMax.to(this,0.5,{delay:0.1,y:sH-39-yOffset, onComplete:onCloseComplete, onStart:onStartClose})
			_twDisplay = TweenMax.to(_display,0.2,{alpha:0})
			_twMenu = TweenMax.to(_menu,0.3,{alpha:0})
			_twGrid = TweenMax.to(_grid,0.5,{autoAlpha:0})
			_twGradient = TweenMax.to(_gradientBg,0.3,{autoAlpha:0})
			_twHit = TweenMax.to(hit, 0.5, {delay:0.1, y:20})
				
			TweenMax.to(mainLayer,0.3, {alpha:0.7})
			if(_glowBitmap) _twGlow = TweenMax.to(_glowBitmap,0.3,{autoAlpha:0})
			
			if(_forceRollOut){
				_forceRollOut = false
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler)
			}
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			if(_forceRollOut) rollOverHandler();
		}
		
		public function onCloseComplete():void
		{
			stopGlow()
			_openPlayer = false
			dispatchEvent(new Event(ON_CLOSE))
		}
		
		public function onStartClose():void
		{
			dispatchEvent(new Event(ON_START_CLOSING))
		}
		
		public function dispatchOpen():void
		{
			dispatchEvent(new Event(ON_OPEN))
		}
		
		protected function resizeHandler(event:Event):void
		{
			resize()
		}	
		
		static public function getRatioW(width:Number):Number
		{
			return (Math.max(width, MIN_WIDTH) - MIN_WIDTH) / (BASE_WIDTH - MIN_WIDTH);
		}
		
		private function resize():void
		{
			sW = stage.stageWidth
			sH = stage.stageHeight
			ratioW = getRatioW(sW)
			if(ratioW > 1) ratioW = 1
			
			xLineAngle = 90 + (ratioW*35);
			_tmlneMask.setxlineAngle(xLineAngle)
			_display.x = xLineAngle - 87 - (ratioW*1)	
			_grid.x = (sW - _grid.width)>>1
			if(_gradientBg) _gradientBg.width = sW
				
			hit.graphics.beginFill(0xFFFFFF,1);
			hit.graphics.drawRect(0,0,sW,160);
			hit.graphics.endFill();
			
			if(_menu.numChildren > 0){
				updateButtonsPosition()				
			}	
		}
		
		private function updateButtonsPosition():void
		{
			var menuLeftMargin:int = 10+(25*ratioW)
			_menu.x = xLineAngle+menuLeftMargin
			_tmlneMask.setMenuX(_menu.x)
			var menuRightMargin:int = 10+(35*ratioW)
			var menuFillSpace:Number = sW-(menuLeftMargin+menuRightMargin+xLineAngle)
			var buttonSpaceLeft:int = (menuFillSpace-wTotalButtons) / (_buttonList.length-1)
			
			var _xBtn:int = 0
			var _prevBtn:TimelineButton
			for(var i:int = 0; i< _buttonList.length ;i++)
			{	
				var btn:TimelineButton = TimelineButton(_buttonList[i]);
				if(btn.page.id != PagesName.RANDD){
					btn.setWidthLine(buttonSpaceLeft)
					btn.x = _xBtn
					_xBtn += btn.width
				}else{
					btn.setWidthLine(_prevBtn.wLine,false)
					btn.x = _prevBtn.x
				}
				_prevBtn = btn
			}				
		}
		
		public function tickNetStream(event:ObjectEvent):void
		{
			var ns:ReelNetStream = event.getObject() as ReelNetStream 			
			if(_openPlayer) _display.setTime(ns.timeWithOffset)
			_tmlneMask.setProgress(ns.timeWithOffset)
		}
		
		public function hide():void
		{
			
		}
	}
}