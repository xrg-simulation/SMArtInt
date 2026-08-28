within SMArtInt.Blocks;
model EvaluateStatefulRecurrentNeuralNet
  extends BaseClasses.BaseStatefulRecurrentNeuralNet;
  Modelica.Blocks.Interfaces.RealInput u[batchSize,numberOfInputs] annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[batchSize,numberOfOutputs] annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(array2DFlatteningModel.arrayIn, u) annotation (Line(points={{-42,0},{-120,0}}, color={0,0,127}));
  connect(array2DDeflatteningModel.arrayOut, y) annotation (Line(points={{41,0},{110,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Use this block if you want to include a recurrent neural network in Modelica which has been created with the flag stateful=True in TensorFlow. Please notice, that TFLite is not capable to handle the stateful states internally. Therefore, the neural network has to be created with access to all states as additional inputs and outputs. In this context the inputs and outputs have to be additional access points to the neural networks. SMArtInt will handle the updates of the states by storing the values of the state outputs and feed them back into the state inputs. Therefore, for all states matching in- and output have to exist. When creating the neural network the user has to take care of this. The stateful PI controller created in the script <a href=\"modelica://SMArtInt/Resources/ExampleNeuralNets/PIController/\">ExampleNeuralNets/PIController/PI.py</a> gives an example how to expose the states as in- an outputs.</p>
<p>Please place this block in your own model. After that</p>
<ul>
<li>give the path to the TFLite/ONNX model</li>
<li>specify the number of inputs</li>
<li>specify the sampling interval</li>
<li>Provide values for the input of the block in the same way as they are given in the training</li>
</ul>
<p>Most likely, the stateful RNN will be trained for time discret data and therefore it has to be called only at discrete time instances. The user has to provide the samplingInterval for the discrete time instances. If continuous = false, the model will create events at each of the time instances and will only call the model at these instances. The many events have an impact on simulation performance. To increase performance the user can set continuous = true. In that case the model can be called for any times as it is demanded by the solver. SMArtInt will internally call the neural network only at the time sampled time points. Hence, no events are created, but the inputs for the neural network have to be interpolated. Additionally, solution accuracy for the states of the neural network and the impact of the interpolation of the inputs cannot be controlled by the solver directly. Only the impact on the states in the model can be evaluated. Therefore, this approach might created inaccurate solutions especially if mult-step solver like DASSL and Cvode are used with a high tolerance value. The user should compare the simulation results to those with continuous = false or to results with continuous = true and lower tolerance and/or single step solver like (Radau).</p>
<p>For an example take a look at the model <a href=\"modelica://SMArtInt.Tester.ExamplePI.TFLite.TF_PI_Stateful_tflite\">TF_PI_Stateful_tflite</a>. This example does not use this block directly but the usage is similar as it extends the model which is extended by this block.</p>

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
end EvaluateStatefulRecurrentNeuralNet;
