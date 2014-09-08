package tv.turbodrive.puremvc.controller
{	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	
	import tv.turbodrive.puremvc.mediator.StageMediator;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	import tv.turbodrive.puremvc.proxy.TextContentProxy;
	
	public class StartupCommand extends AsyncCommand implements ICommand
	{
		public function StartupCommand(){
			
		}
		
		private var body:Object		

		private var structureProxy:StructureProxy;

		override public function execute(notification:INotification):void
		{
			body = notification.getBody()				
			structureProxy = new StructureProxy()
			structureProxy.onComplete = this.onStructureComplete
			facade.registerProxy(structureProxy);
		}
		
		public function onStructureComplete():void	
		{
			var textContentProxy:TextContentProxy = new TextContentProxy();
			textContentProxy.parseXmlContent(structureProxy.getXmlContent())
			facade.registerProxy(textContentProxy)
			
			facade.registerMediator(new StageMediator(body));
			facade.registerProxy(new SwitchPageProxy());
			
			
		}
	}
}