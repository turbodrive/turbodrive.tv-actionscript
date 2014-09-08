package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.text.XmlStringReader;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.Styles;
	import tv.turbodrive.utils.geom.RectangleRotation;

	public class AwardsContentView extends SpriteDrivenBy3D
	{
		private var _cross:CrossHelper;

		private var title:TextField;

		private var _currentCard:AwardCard;
		private var _prevCard:AwardCard;

		private var pageId:String;

		private var _twShowCard:TweenMax;
		private var _rect:RectangleRotation;

		private var nbrAwards:int;
		
		public function AwardsContentView(overlay:Overlay2DView)
		{	
			rotation = -3
			_cross = new CrossHelper()
			//this.addChild(_cross);
			
			super(overlay)
		}
		
		override public function buildContent(page:Page):void
		{
			MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT
			
			title = Styles.createTextField("projects","common/extraAwardsTitle", {upperCase:false})
			this.addChild(title)
			
			pageId = page.id
			nbrAwards = 0
			for(var i:int = 0; i < 10; i++){
				var key:String = pageId+"/awards/award"+i;
				if(XmlStringReader.getStringContent("projects",key) && XmlStringReader.getStringContent("projects",key) != ""){
					nbrAwards ++
				}
			}
			
			if(nbrAwards > 0){
				showCard(1)
			}
				
			alpha = 0
			TweenMax.to(this, 0.3, {alpha:1})
		}
		
		private function showCard(id:int = 1):void
		{
			if(_twShowCard){
				_twShowCard.pause();
			}
		
			hidePrevCard()	
			
			_currentCard = new AwardCard("projects", pageId+"/awards/award"+id )
			_currentCard.alpha = 0
			placeCard();
			_twShowCard = TweenMax.to(_currentCard, 0.3, {delay:0.2, alpha:1})
			addChild(_currentCard)
			
			if(nbrAwards > 1){
				var next:int = id+1
				if(next > nbrAwards) next = 1
				setTimeout(showCard, 3000, next);
			}
		}
		
		private function hidePrevCard():void
		{
			if(_currentCard){
				_prevCard = _currentCard
				TweenMax.to(_prevCard, 0.3, {alpha:0, onComplete:removeCard, onCompleteParams:[_prevCard]})
			}
		}
		
		private function removeCard(card:Sprite):void
		{
			if(contains(card)) removeChild(card)
		}
		
		private function placeCard():void
		{
			if(!_rect || !_currentCard) return
			_currentCard.x = (_rect.width*0.75) - (_currentCard.width >> 1) - 40;
			_currentCard.y = (_rect.width*0.25) - (_currentCard.height >> 1) - 15;
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number=0):void
		{	
			if(_destroyed) return
			_rect = rect
			this.x = rect.x
			this.y = rect.y
			_cross.height = rect.height
			_cross.width = rect.width
			
			title.x = 15+rect.width/2
			title.y = 65	
				
			placeCard()
		}
		
		override public function hideAndRemove():Boolean
		{
			if(_twShowCard){
				_twShowCard.pause();
			}
			hidePrevCard()
			return super.hideAndRemove()
		}
	}
}