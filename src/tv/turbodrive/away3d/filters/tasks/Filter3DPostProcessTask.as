package tv.turbodrive.away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.filters.tasks.Filter3DTaskBase;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	
	/**
	 * Filtre postprocess adapté de celui en GLSL que l'on peut trouver ici : http://www.iquilezles.org/apps/shadertoy/
	 * - Décallage des couches RVB
	 * - Vignettage 
	 * Les autres effets ont été supprimés. 
	 */
	
	public class Filter3DPostProcessTask extends Filter3DTaskBase
	{		
		private var _channelXOffset:Number = 1
		private var _brightness:Number = 1
		private var _exposure:Number = 0.7
		
		
		public function Filter3DPostProcessTask(requireDepthRender:Boolean=false)
		{
			super(requireDepthRender);
		}
		
		override protected function getFragmentCode() : String
		{
			var code:String ='div ft2.xy, v0.xyyy, fc1.xyyy\n'+
				'add ft1.x, ft2.x, fc0.x\n'+
				'mov ft1.y, ft2.y\n'+
				'tex ft3, ft1.xyyy, fs0 <linear mipdisable repeat 2d>\n'+
				'mov ft1.x, ft3.x\n'+
				'tex ft3, ft2.xyyy, fs0 <linear mipdisable repeat 2d>\n'+
				'mov ft1.y, ft3.y\n'+
				'sub ft3.x, ft2.x, fc0.x\n'+
				'mov ft3.y, ft2.y\n'+
				'tex ft0, ft3.xyyy, fs0 <linear mipdisable repeat 2d>\n'+
				'mov ft1.z, ft0.z\n'+
				'sub ft3.z, fc0.y, ft2.y\n'+
				'sub ft3.y, fc0.y, ft2.x\n'+
				'mul ft3.x, fc0.z, ft2.x\n'+
				'mul ft0.w, ft3.x, ft2.y\n'+
				'mul ft0.z, ft0.w, ft3.y\n'+
				'mul ft0.y, ft0.z, ft3.z\n'+
				'add ft0.x, fc0.w, ft0.y\n'+
				'mul ft2.xyz, ft1.xyzz, ft0.x\n'+
				'mov ft0.w, fc0.y\n'+
				'mov ft0.xyz, ft2.xyzz\n'+
				'mov oc, ft0'	
			
			return code;
		}
		
		override public function activate(stage3DProxy : Stage3DProxy, camera3D : Camera3D, depthTexture : Texture) : void
		{

			camera3D = camera3D; 
			depthTexture = depthTexture;				
			var fc0:Vector.<Number>=Vector.<Number>([0.001*_channelXOffset,_brightness,4.8,_exposure])
			var fc1:Vector.<Number>=Vector.<Number>([1,1,0,0])
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc0)
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, fc1)			
			
		}
	}
}