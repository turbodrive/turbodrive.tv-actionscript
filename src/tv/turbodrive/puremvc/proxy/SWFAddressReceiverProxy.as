package tv.turbodrive.puremvc.proxy 
{
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.puremvc.ApplicationFacade;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	
	/**
	 * ...
	 * @author Silvère Maréchal
	 */
	public class SWFAddressReceiverProxy extends Proxy implements IProxy 
	{
		public var onReady:Function;
	
		public static const NAME:String = "SWFAddressReceiverProxy";
		private var _initialized:Boolean = false
		private static var _currentAddress:String = ""
		private var _newAddress:String = ""
			
		//public var _tracker:AnalyticsTracker
		
				
		/**
		 * Default constructor
		 * @param data Initial data to store in the proxy
		 */
		public function SWFAddressReceiverProxy( data:Object = null ) 
		{			
			//_tracker = new GATracker(data as DisplayObject,"UA-36681977-3", "AS3", false);
			super ( NAME, data );			
		}
		
		override public function onRegister():void 
		{
			init()
			
		}
		
		public function init():void
		{
			if (_initialized) return ;	
			
			// récupération de l'url courante une fois que le site a été complètement chargé et initialisé.
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, changeAddressHandler)
		}
		
		public static function get current():String
		{
			return _currentAddress;
		}
		
		private function changeAddressHandler(e:SWFAddressEvent = null):void
		{			
			_newAddress = SWFAddress.getValue()
			//_newAddress = "/reel/theyrelanding"

				
			if (_newAddress == "/") {
				//pas de page, on appelle la homepage
				sendNotification(ApplicationFacade.CHANGE_PAGE, PagesName.DEFAULT)
			}else{			
				// on vire le dernier slash de l'addresse
				if (_newAddress.slice( -1) == "/") {
					_newAddress = _newAddress.slice(0,-1)
				}
				
				if (_currentAddress == _newAddress) return	
					
				_currentAddress = _newAddress
				var newPage:Page = StructureProxy(facade.retrieveProxy(StructureProxy.NAME)).getPageFromWholeAddress(_currentAddress);
				
				Preloader.track(_newAddress);
				
				//SWFAddress.setTitle(newPage.title)
				SwitchPageProxy(facade.retrieveProxy(SwitchPageProxy.NAME)).process(newPage, _newAddress == "/reel")
				
				
				if (!_initialized) {
					_initialized = true
					//sendNotification(StageMediator.INIT_UI)
				}
			}
		}		
	}	
}