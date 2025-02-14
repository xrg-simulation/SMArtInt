within SMArtInt.BaseClasses;
partial model BaseRecurrentNeuralNet
  extends BaseNeuralNet(
    final stateful=false,
    final outputSizes=if returnSequences then {batchSize,nHistoricElements,numberOfOutputs} else {1,numberOfOutputs},
    final outputDimensions=if returnSequences then 3 else 2,
    final inputSizes={batchSize,nHistoricElements,numberOfInputs},
    final inputDimensions=3);

  parameter Integer numberOfInputs=1 "Number of input values" annotation (Dialog(group="Input/Output Sizing"));
  parameter Integer numberOfOutputs=1 "Number of output values" annotation (Dialog(group="Input/Output Sizing"));
  parameter Integer batchSize=1 "Number of parallel batched simulations" annotation (Dialog(group="Input/Output Sizing"));
  parameter Boolean returnSequences=false annotation (Dialog(group="Input/Output Sizing"));

  parameter Integer nHistoricElements=10 "Number of elements from sampling steps for each input fed to the neural net"
    annotation (Dialog(group="RNN Timing Settings"));
  parameter Boolean continuous=false "=true: model operates continuously; input values are delayed"
    annotation (Dialog(group="RNN Timing Settings"));

  parameter Boolean useClaRaDelay=true "Use the ClaRa delay instead of MSL delay"
    annotation (Dialog(group="RNN Timing Settings"));

  Internal.Utilities.RunInterferenceRNN runInterferenceHistory(
    final useClaRaDelay=useClaRaDelay,
    final nInputs=numberOfInputs,
    final nOutputs=numberOfOutputs,
    final samplePeriod=samplePeriod,
    final nHistoricElements=nHistoricElements,
    final returnSequences=returnSequences,
    final smartint=smartint,
    final continuous=continuous) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Use this base class if you want to include a recurrent neural network in Modelica.</p>
<p>Please extend this model in your own model. After extending you have to</p>
<ul>
<li>give the path to the TFLite/ONNX model</li>
<li>specify the number of inputs</li>
<li>specify the sampling interval and how many elements from previous times should be fed into the net</li>
<li>create input and output connectors</li>
<li>connect input and output connectors to the single input and single output vector of the runInference submodel</li>
</ul>
<p>In continuous mode the historic values are generated by a delay. You could choose between the computational improved Clara-Delay and the delay in the Modelica-Standard-Library. If continuous is deactivated the model will create an event when reaching the sampling time - this should be avoided for performance reasons.</p>
<p>As tensorflow lite uses a flattened input array, you have to specify the flattening method. In the standard tensorflow setting you have to use the predefined option OldFirstInputSequential.</p>
<p>For an exemplaric usage the user can take a look at the model <a href=\"modelica://SMArtInt.Tester.ExamplePI.TFLite.TF_PI_RNN_tflite\">TF_PI_RNN_tflite</a> which uses the block EvaluateRecurrentNeuralNet which extends from this base model.</p>
</html>"));
end BaseRecurrentNeuralNet;
