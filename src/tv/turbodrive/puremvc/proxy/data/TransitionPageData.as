package tv.turbodrive.puremvc.proxy.data
{
	import tv.turbodrive.away3d.transitions.TransitionsName;
	import tv.turbodrive.away3d.transitions.TransitionsSelector;

	public class TransitionPageData
	{
		private var _previous:Page;
		private var _next:Page;	
		private var _transitionName:String;
		private var _loop:String
		private var _waitLoading:Boolean
		private var _internalSubTransition:String
		private var _isSimple:Boolean
		//private var _waitLoadedAssetBeforeStart:Boolean = false
		
		public function TransitionPageData(previousPage:Page, nextPage:Page, isSimple:Boolean = false)
		{
			_previous = previousPage
			_next = nextPage
			_isSimple = isSimple
			
			_transitionName = TransitionsSelector.getTransition(_previous, _next, isSimple, false)
			_loop = TransitionsSelector.getLoop(_transitionName)
			//_waitLoadedAssetBeforeStart = TransitionsSelector.getWaitLoading(_transitionName);
		}
		
		public function setInternalTransition(internalSubPage:String, transitionName:String = null):void
		{
			_internalSubTransition = internalSubPage
			if(transitionName) _transitionName = transitionName
		}
		
		public function get internalSubTransition():String
		{
			return _internalSubTransition
		}
		
		public function set waitLoading(value:Boolean):void
		{
			_waitLoading = value
			if(_waitLoading){
				// update the name
				_transitionName = TransitionsSelector.getTransition(_previous, _next, _isSimple, _waitLoading)
				_loop = TransitionsSelector.getLoop(_transitionName)
			}
		}
		
		/*public function get waitLoadedAssetBeforeStart():Boolean
		{
			return _waitLoadedAssetBeforeStart
		}*/
		
		public function get waitLoading():Boolean
		{
			return _waitLoading
		}
		
		public function get previousPage():Page
		{
			return _previous	
		}
		
		public function get nextPage():Page
		{
			return _next
		}
		
		public function get transitionName():String
		{
			return _transitionName
		}
		
		/*public function get loopName():String
		{
			return _transitionName
		}*/
		
		
	}
}