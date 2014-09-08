package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;
	
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.mediator.view.Menu2DView;
	import tv.turbodrive.puremvc.proxy.data.PagesName;

	public class CategoryMenu extends TriMenuCategory
	{
		public static const WIDTH:int = 1136
		private var _buttonsTarget:Dictionary = new Dictionary();
		
		public function CategoryMenu()
		{
			alpha = 0
			
			_buttonsTarget[selectedCasesButton] = PagesName.SELECTED_CASES
			selectedCasesButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			selectedCasesButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)
			
			_buttonsTarget[moreProjectsButton] = PagesName.MORE_PROJECTS				
			moreProjectsButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			moreProjectsButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)
			
			_buttonsTarget[aboutButton] = PagesName.ABOUT
			aboutButton.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			aboutButton.addEventListener(MouseEvent.CLICK, mouseClickHandler)
			
			selectedCasesButton.buttonMode = moreProjectsButton.buttonMode = aboutButton.buttonMode = true
			selectedCasesButton.mouseEnabled = moreProjectsButton.mouseEnabled = aboutButton.mouseEnabled = true
				
			//filters = [new DropShadowFilter(35,45,0x17101d,0.5,20,20,1,2)]
		}
		
		protected function rollOverHandler(event:Event):void
		{
		}
		
		protected function mouseClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new StringEvent(Menu2DView.CLICK_MENU_BUTTON,event.target, String(_buttonsTarget[event.currentTarget])));
		}
		
		public function show(category:String):void			
		{
			var durationAnimation:Number = 0.8
			if(alpha < 1){
				selectedCasesDesc.alpha = moreProjectsDesc.alpha = 0
				durationAnimation = 0
				alpha = 1
				this.gotoAndStop(1)
				TweenMax.to(this, 1.2, {delay: 0.35, frame:this.totalFrames, ease:Linear.easeNone})
			}
			
			if(category == PagesName.SELECTED_CASES){
				TweenMax.to(moreProjectsButton, durationAnimation, {x:760, ease:Quad.easeInOut});
				TweenMax.to(selectedCasesButton, durationAnimation, {removeTint:true, overwrite:false});
				TweenMax.to(moreProjectsButton, durationAnimation, {tint:0x584850, overwrite:false});
				TweenMax.to(moreProjectsDesc, 0.2, {alpha:0});
				TweenMax.to(selectedCasesDesc, 0.4, {delay : 0.7, alpha:0.6});				
			}else{
				TweenMax.to(moreProjectsButton, durationAnimation, {removeTint:true, overwrite:false});
				TweenMax.to(selectedCasesButton, durationAnimation, {tint:0x584850, overwrite:false});
				TweenMax.to(moreProjectsButton, durationAnimation, {x:190, ease:Quad.easeInOut});				
				TweenMax.to(selectedCasesDesc, 0.2, {alpha:0});
				TweenMax.to(moreProjectsDesc, 0.4, {delay : 0.7, alpha:0.6});
			}
		}
	}
}