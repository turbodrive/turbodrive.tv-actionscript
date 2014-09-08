package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.events.PageEvent;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.Colors;
	
	public class NextPrevNavigationView extends Sprite
	{
		public static const NAME:String = "NextPrevNavigationView"
		
		private var _prevButton:PrevButtonView = new PrevButtonView();
		private var _nextButton:NextButtonView = new NextButtonView();
		private var _hitAreaLeft:Sprite = new Sprite();
		private var _hitAreaRight:Sprite = new Sprite();
		private var dictionnaryLinks:Dictionary = new Dictionary();
		private var dictionnaryTw:Dictionary = new Dictionary();
		
		private var _headerHeight:int = 50
		private var _widthHitArea:int = 45
			
		private var xTargetNext:int = 0
		private var xTargetPrev:int = 0
		private var closeSpace:int = 720
		private var _overButton:Sprite
			
		static public const ON_BUTTON_CLICK:String = "onButtonClick"
		
		private var _currentPage:Page;

		private var _twSlide:TweenMax;
		private var _twArrowNext:TweenMax;
		private var _twArrowPrev:TweenMax;
		
		private var _left:Sprite = new Sprite();
		private var _right:Sprite = new Sprite();
		
		
		public function NextPrevNavigationView()
		{
			super();
			this.name = NAME			
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
				
			_hitAreaLeft.graphics.beginFill(0xFFFFFF,0);
			_hitAreaLeft.graphics.drawRect(0,0,_widthHitArea,50);
			_hitAreaLeft.graphics.endFill()
			_hitAreaRight.graphics.copyFrom(_hitAreaLeft.graphics)
			_hitAreaRight.x = -_widthHitArea
			
			_left.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, true)
			_right.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, true)
			_left.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			_right.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			_right.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
			_left.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
			_right.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler)
			_left.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler)
			_left.addEventListener(MouseEvent.CLICK, clickHandler)
			_right.addEventListener(MouseEvent.CLICK, clickHandler)
				
		
			_prevButton.arrow_mc.endPosition = new Point(_prevButton.arrow_mc.x, _prevButton.arrow_mc.y);
			_prevButton.arrow_mc.startPosition = new Point(260+525,-204);
			//_prevButton.arrow_mc.alpha = 1
			
			_nextButton.arrow_mc.endPosition = new Point(_nextButton.arrow_mc.x, _nextButton.arrow_mc.y);
			_nextButton.arrow_mc.startPosition = new Point(-205-555,-7);
			//_nextButton.arrow_mc.alpha = 1
			//_nextButton.hit_mc.visible = _prevButton.hit_mc.visible = false
			//_nextButton.hitArea = _hitAreaRight
			//_prevButton.hitArea = _hitAreaLeft
			
			
			
			_prevButton.mouseEnabled = _prevButton.mouseChildren = false
			_nextButton.mouseEnabled = _nextButton.mouseChildren = false
			_nextButton.arrow_mc.mouseEnabled = false
			_prevButton.arrow_mc.mouseEnabled = false
			
			this.mouseEnabled = false
			this.mouseChildren = true
				
			_right.mouseEnabled = _left.mouseEnabled = true
			_right.mouseChildren = _left.mouseChildren = true
			_right.buttonMode = _left.buttonMode = true
			_hitAreaLeft.mouseEnabled = _hitAreaRight.mouseEnabled = true
			
			_left.addChild(_hitAreaLeft)
			_left.addChild(_prevButton)
				
			_right.addChild(_hitAreaRight)
			_right.addChild(_nextButton)
				
			rollOutComplete()
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			var targetButton:Sprite = getTargetButton(event.currentTarget)
			TweenMax.to(targetButton,0.1, {removeTint:true, ease:Quart.easeOut});
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			var targetButton:Sprite = getTargetButton(event.currentTarget)
			TweenMax.to(targetButton,0, {tint:Colors.VINTAGE_WHITE, ease:Quart.easeOut});
			
		}
		
		public function updateState(currentPage:Page):void
		{			
			_currentPage = currentPage
				
			if(!_currentPage.nextPage || _currentPage.nextPage.category != _currentPage.category || _currentPage.nextPage.env != _currentPage.env){				
				if(contains(_right)) removeChild(_right)
			}else{
				dictionnaryLinks[_right] = _currentPage.nextPage
				dictionnaryLinks[_hitAreaRight] = _currentPage.nextPage
				dictionnaryLinks[_nextButton] = _currentPage.nextPage
				addChild(_right)
				_nextButton.updatePageInfo(_currentPage.nextPage)
			}
			
			if(!_currentPage.previousPage || _currentPage.previousPage.category != _currentPage.category || _currentPage.previousPage.env != _currentPage.env){		
				if(contains(_left)) removeChild(_left)
			}else{
				dictionnaryLinks[_left] = _currentPage.previousPage
				dictionnaryLinks[_hitAreaLeft] = _currentPage.previousPage
				dictionnaryLinks[_prevButton] = _currentPage.previousPage
				addChild(_left)
				_prevButton.updatePageInfo(_currentPage.previousPage)
			}
			
			_hitAreaLeft.visible = _hitAreaRight.visible = true
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			var targetButton:Sprite = getTargetButton(event.currentTarget)
			var targetX:int = targetButton == _nextButton ? xTargetNext+closeSpace : xTargetPrev-closeSpace
			if(dictionnaryTw[targetButton]) dictionnaryTw[targetButton].pause()
			dictionnaryTw[targetButton] =  TweenMax.to(targetButton,0.3, {delay:0, x:targetX, ease:Quart.easeInOut})
			_overButton = null
			var startPosition:Point
				
			if(targetButton == _nextButton){
				if(_twArrowNext) _twArrowNext.pause();
				startPosition = Point(_nextButton.arrow_mc.startPosition)
				_twArrowNext = TweenMax.to(_nextButton.arrow_mc, 0.3,{alpha:0.10, x : startPosition.x, y:startPosition.y, onComplete:rollOutComplete, ease:Quart.easeInOut})
			}else{
				if(_twArrowPrev) _twArrowPrev.pause();
				startPosition = Point(_prevButton.arrow_mc.startPosition)
				_twArrowPrev = TweenMax.to(_prevButton.arrow_mc, 0.3,{alpha:0.10, x : startPosition.x, y:startPosition.y, onComplete:rollOutComplete, ease:Quart.easeInOut})
			}
		}
		
		private function  rollOutComplete():void
		{
			_nextButton.arrow_mc.x = Point(_nextButton.arrow_mc.startPosition).x
			_nextButton.arrow_mc.y = Point(_nextButton.arrow_mc.startPosition).y
			_nextButton.arrow_mc.alpha = 0.10
				
			_prevButton.arrow_mc.alpha = 0.10
			_prevButton.arrow_mc.x = Point(_prevButton.arrow_mc.startPosition).x
			_prevButton.arrow_mc.y = Point(_prevButton.arrow_mc.startPosition).y
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{	
		
			var targetButton:Sprite = getTargetButton(event.currentTarget)
			var targetX:int = targetButton == _nextButton ? xTargetNext : xTargetPrev
			if(dictionnaryTw[targetButton]) dictionnaryTw[targetButton].pause()
			dictionnaryTw[targetButton] = TweenMax.to(targetButton,0.3, {x:targetX, ease:Quart.easeOut})
			_overButton = targetButton

			
			if(targetButton == _nextButton){
				if(_nextButton.arrow_mc.alpha == 1) return 
				_nextButton.arrow_mc.alpha = 0.10
				_nextButton.arrow_mc.x = Point(_nextButton.arrow_mc.startPosition).x
				_nextButton.arrow_mc.y = Point(_nextButton.arrow_mc.startPosition).y
				var endPosition:Point = Point(_nextButton.arrow_mc.endPosition)
				if(_twArrowNext) _twArrowNext.pause();
				_twArrowNext = TweenMax.to(_nextButton.arrow_mc, 0.3, {alpha:1, x : endPosition.x, y:endPosition.y, ease:Quart.easeOut})
			}else{
				if(_prevButton.arrow_mc.alpha == 1) return 
				_prevButton.arrow_mc.alpha = 0.10
				_prevButton.arrow_mc.x = Point(_prevButton.arrow_mc.startPosition).x
				_prevButton.arrow_mc.y = Point(_prevButton.arrow_mc.startPosition).y
				var endPosition2:Point = Point(_prevButton.arrow_mc.endPosition)				
				if(_twArrowPrev) _twArrowPrev.pause();
				_twArrowPrev = TweenMax.to(_prevButton.arrow_mc, 0.3, {alpha:1, x : endPosition2.x, y:endPosition2.y, ease:Quart.easeOut})
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{			
			var targetButton:Sprite = getTargetButton(event.currentTarget)
			targetButton.mouseEnabled = false
			_hitAreaLeft.visible = _hitAreaRight.visible = false
			//if(contains(_hitAreaLeft))removeChild(_hitAreaLeft);
			//if(contains(_hitAreaRight))removeChild(_hitAreaRight);
			rollOutHandler(event);
			
			dispatchEvent(new PageEvent(ON_BUTTON_CLICK, dictionnaryLinks[targetButton]));			
		}
		
		private function getTargetButton(currentTarget:Object):Sprite
		{
			var targetButton:Sprite
			
			if(currentTarget == _left || currentTarget == _prevButton || currentTarget == _hitAreaLeft){
				targetButton = _prevButton
			}else if(currentTarget == _right || currentTarget == _nextButton || currentTarget == _hitAreaRight){
				targetButton = _nextButton
			}
			
			return targetButton
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			stage.addEventListener(Event.RESIZE, resizeStageHandler)
			resizeStageHandler()
			parent.mouseEnabled = false
			parent.parent.mouseEnabled = false
			this.mouseEnabled = false
		}
		
		protected function removedFromStageHandler(event:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		protected function resizeStageHandler(event:Event = null):void
		{
			if(!stage) return
				
			_prevButton.y = _nextButton.y = _headerHeight + ((stage.stageHeight-_headerHeight)/2)
			xTargetNext = -20//50 //stage.stageWidth-50
			_prevButton.x = xTargetPrev-closeSpace
			_nextButton.x = xTargetNext+closeSpace
				
			if(_overButton){
				_overButton.x = (_overButton == _nextButton) ? xTargetNext : xTargetPrev
			}
				
			_left.y = _right.y = _headerHeight
			_left.x = 0
			_right.x = stage.stageWidth
			//_hitAreaRight.x = -_hitAreaRight.width
			_hitAreaLeft.height = _hitAreaRight.height = stage.stageHeight - _headerHeight
		}
		
		public function disable():void
		{
			//_prevButton.mouseEnabled = _nextButton.mouseEnabled = false
			_hitAreaLeft.mouseEnabled = _hitAreaRight.mouseEnabled = false
		}
		
		public function enable():void
		{
			//_prevButton.mouseEnabled = _nextButton.mouseEnabled = true
			_hitAreaLeft.mouseEnabled = _hitAreaRight.mouseEnabled = true
			rollOutComplete()
		}
	}
}