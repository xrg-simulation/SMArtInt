within SMArtInt.Blocks;
model EvaluateSimpleFeedForwardNeuralNetwork
  extends BaseClasses.BaseFeedForwardNeuralNet;

  Modelica.Blocks.Interfaces.RealInput u[batchSize,numberOfInputs] annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[batchSize,numberOfOutputs] annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(array2DFlatteningModel.arrayIn, u) annotation (Line(points={{-42,0},{-120,0}}, color={0,0,127}));
  connect(array2DDeflatteningModel.arrayOut, y) annotation (Line(points={{41,0},{110,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a specialized version of the EvaluateGenericNeuralNetwork. It can be used for neural networks which use several scalar inputs and outputs. The user has to create the wanted inputs and has to connect them to the input of the block. This input has the same shape [batchSize, numberOfInputs] of the input used in the tensorflow model. The individual input have to be fed into the last dimension. A batch size can be used simultaniously calculation.</p>
<p>The example <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample.TFLite.PipeLocalHeatTransfer_tflite\">PipeLocalHeatTransfer_tflite</a> uses this block.</p>

<h4>TensorFlow Lite FlexOps</h4>

<p>
To use FlexOps with the TensorFlow Lite runtime, additional dynamic libraries must be provided in the SMArtInt library resources. Follow the steps below:
</p>

<ol>
  <li>
    Copy the appropriate FlexOps library into the corresponding platform folder
    (<code>win64</code> or <code>linux64</code>) inside the
    <a href=\"modelica://SMArtInt/Resources/Library/\">Resources Library folder</a>:
    <ul>
      <li><b>Windows:</b> <code>tensorflowlite_flex.dll</code></li>
      <li><b>Linux:</b> <code>libtensorflowlite_flex.so</code></li>
    </ul>
  </li>
  <li>
    Activate TensorFlow Lite FlexOps usage in the model parameter dialog.
  </li>
</ol>

<h4>CUDA GPU Support for ONNX Runtime</h4>

<p>
To use ONNX Runtime with GPU acceleration, CUDA must be installed on the operating system
(tested with CUDA version 13.0), and a CUDA-compatible GPU must be available.
In addition, the required ONNX Runtime GPU provider libraries must be provided in the SMArtInt library resources.
Follow the steps below:
</p>

<ol>
  <li>
    Download the ONNX Runtime build with GPU support from:
    <br>
    <a href=\"https://github.com/microsoft/onnxruntime/releases/tag/v1.23.2\">
      ONNX Runtime v1.23.2 Release
    </a>
  </li>

  <li>
    Select and extract the appropriate package for your operating system:
    <ul>
      <li><b>Windows:</b> <code>onnxruntime-win-x64-gpu-1.23.2.zip</code></li>
      <li><b>Linux:</b> <code>onnxruntime-linux-x64-gpu-1.23.2.tgz</code></li>
    </ul>
  </li>

  <li>
    Copy the required provider libraries into the corresponding platform folder
    (<code>win64</code> or <code>linux64</code>) inside the
    <a href=\"modelica://SMArtInt/Resources/Library/\">Resources Library folder</a>:
    <ul>
      <li><code>onnxruntime_providers_cuda.dll</code> / <code>.so</code></li>
      <li><code>onnxruntime_providers_shared.dll</code> / <code>.so</code></li>
    </ul>
  </li>

  <li>
    Activate GPU usage in the model parameter dialog.
  </li>
</ol>

</html>"));
end EvaluateSimpleFeedForwardNeuralNetwork;
