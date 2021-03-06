package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.utils.ShaderRegisterCache;
	import away3d.materials.utils.ShaderRegisterElement;

	import flash.display3D.Context3DProgramType;
	import flash.geom.ColorTransform;

	use namespace arcane;

	/**
	 * ColorTransformMethod provides a shading method that changes the colour of a material according to a ColorTransform
	 * object.
	 */
	public class ColorTransformMethod extends ShadingMethodBase
	{
		private var _colorTransformIndex : int;
		private var _colorTransform : ColorTransform;
		private var _colorTransformData : Vector.<Number>;

		/**
		 * Creates a new ColorTransformMethod.
		 */
		public function ColorTransformMethod()
		{
			super(false, false, false);
			_colorTransformData = new Vector.<Number>(8, true);
		}

		/**
		 * The ColorTransform object to transform the colour of the material with.
		 */
		public function get colorTransform() : ColorTransform
		{
			return _colorTransform;
		}

		public function set colorTransform(value : ColorTransform) : void
		{
			_colorTransform = value;
		}

		/**
		 * @inheritDoc
		 */
		arcane override function reset() : void
		{
			super.reset();
			_colorTransformIndex = -1;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function getFragmentPostLightingCode(regCache : ShaderRegisterCache, targetReg : ShaderRegisterElement) : String
		{
			var code : String = "";
			var colorMultReg : ShaderRegisterElement = regCache.getFreeFragmentConstant();
			var colorOffsReg : ShaderRegisterElement = regCache.getFreeFragmentConstant();
			_colorTransformIndex = colorMultReg.index;
			code += "mul " + targetReg + ", " + targetReg.toString() + ", " + colorMultReg + "\n" +
					"add " + targetReg + ", " + targetReg.toString() + ", " + colorOffsReg + "\n";
			return code;
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(stage3DProxy : Stage3DProxy) : void
		{
			var inv : Number = 1/0xff;
			_colorTransformData[0] = _colorTransform.redMultiplier;
			_colorTransformData[1] = _colorTransform.greenMultiplier;
			_colorTransformData[2] = _colorTransform.blueMultiplier;
			_colorTransformData[3] = _colorTransform.alphaMultiplier;
			_colorTransformData[4] = _colorTransform.redOffset*inv;
			_colorTransformData[5] = _colorTransform.greenOffset*inv;
			_colorTransformData[6] = _colorTransform.blueOffset*inv;
			_colorTransformData[7] = _colorTransform.alphaOffset*inv;
			stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _colorTransformIndex, _colorTransformData, 2);
		}
	}
}
