package tv.turbodrive.puremvc.mediator
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.proxy.data.Page;
	
	public class ShowReelMediator extends Mediator implements IMediator
	{
		static public const NAME:String = "ShowReelMediator"
			
		private var _parent:Sprite
		//private var _container:Sprite = new Sprite();
		private var _firstTimeBuildFooter:Boolean = true
			
		private var _tmpPage:Page;
		private var _reelReadyToPlay:Boolean = false;
		public function ShowReelMediator(parent:Sprite)
		{
			_parent = parent		
			super(NAME, null);
		}
				
		override public function onRegister():void
		{			
			facade.registerMediator(new DisplayAreaReelMediator(_parent));			
			//_parent.addChild(_container);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.BUILD_PLAYER]
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.BUILD_PLAYER:
					buildFooter();
					break;
			}
		}	
		
		private function buildFooter():void
		{
			// ControlReel ne doit être dispo qu'une fois le XML de structure chargé.
			facade.registerMediator(new ControlReelPlayerMediator(_parent));	
		}
	}
}