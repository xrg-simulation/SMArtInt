within SMArtInt.Blocks;
model EvaluateSimpleFeedForwardNeuralNetwork
  extends BaseClasses.BaseFeedForwardNeuralNet;

  Modelica.Blocks.Interfaces.RealInput arrayIn[batchSize,numberOfInputs]  annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput arrayOut[batchSize, numberOfOutputs] annotation (Placement(transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(array2DFlatteningModel.arrayIn, arrayIn) annotation (Line(points={{-42,0},{-120,0}},color={0,0,127}));
  connect(array2DDeflatteningModel.arrayOut, arrayOut) annotation (Line(points={{41,0},{110,0}},   color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a specialized version of the EvaluateGenericNeuralNetwork. It can be used for neural networks which use several scalar inputs and outputs. The user has to create the wanted inputs and has to connect them to the input of the block. This input has the same shape [batchSize, numberOfInputs] of the input used in the tensorflow model. The individual input have to be fed into the last dimension. A batch size can be used simultaniously calculation.</p>
<p>The example <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample.TFLite.PipeLocalHeatTransfer_tflite\">PipeLocalHeatTransfer_tflite</a> uses this block.</p>
</html>"));
end EvaluateSimpleFeedForwardNeuralNetwork;
