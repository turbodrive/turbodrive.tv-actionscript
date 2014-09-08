package tv.turbodrive.text
{
	import flash.events.EventDispatcher;
	
	import tv.turbodrive.puremvc.proxy.TextContentProxy;

	/**
	 * ...
	 * @author Silvère Maréchal	 */
	public class XmlStringReaderSingleton extends EventDispatcher
	{
		static public const CHANGE_LNG:String = "changeLng";
		private var _textContentProxy:TextContentProxy
		
		public function XmlStringReaderSingleton(){}		
		
		public function init(txProxy:TextContentProxy):void
		{	
			_textContentProxy = txProxy
		}
		
		public function getXMLContent(page:String, key:String):XML
		{
			return _textContentProxy.getXMLContent(page, key);
		}
		public function getStringContent(page:String, path:String,attribut:String=null):String
		{
			return _textContentProxy.getStringContent(page, path, attribut);
		}		
	
	}
}