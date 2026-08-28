within SMArtInt.Blocks;
model EvaluateGenericNeuralNetwork
  extends BaseClasses.BaseGenericNeuralNet;

  Modelica.Blocks.Interfaces.RealInput u[nInputElements] annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nOutputElements] annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(runInference.u, u) annotation (Line(points={{-12,0},{-120,0}}, color={0,0,127}));
  connect(runInference.y, y) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is the most generic block to include neural networks within Modelica. It extends the BaseGenericNeuralNet and provides generic in- and outputs. It can be used for any neural network. For easier handling the specialized versions EvaluateFeedForwardNeuralNet, EvaluateRecurrentNeuralNet and EvaluateStatefulRecurrentNeuralNet are available.</p>
<p>This most likely use case of this model is with a multi-layer perceptron neural network. </p>
<p>In order to include a neural network in Model, place this block in your own model. You have to </p>
<ul>
<li>give the path of the TFLite/ONNX model</li>
<li>specify the number of dimensions for in and output</li>
<li>specify the vector sizes in each input and output dimension</li>
<li>create input and output connectors</li>
<li>connect input and output connectors to the single input and single output vector of the runInference submodel</li>
</ul>
<p>The runInference model uses a flattened vectors for input and output. The total number of elements equals the product of all input or output sizes, respectively. The user has to connect the defined input and output to the flattened vectors in the same order as they are used within created neural network. </p>

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
end EvaluateGenericNeuralNetwork;
