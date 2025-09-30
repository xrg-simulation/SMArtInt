within SMArtInt.Tester.PipeHeatTransferExample.ONNX;
model PipeLocalHeatTransfer_onnx

  parameter Integer batchSize=1 "number of simultaneous evaluations";

  Modelica.Blocks.Interfaces.RealInput Re[batchSize] annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealInput Pr[batchSize] annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealInput dByL[batchSize] annotation (Placement(transformation(extent={{-120,-80},{-80,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Nu[batchSize] annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Blocks.EvaluateSimpleFeedForwardNeuralNetwork evalNN(
    numberOfInputs=3,
    numberOfOutputs=1,
    batchSize=batchSize,
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt//Resources//ExampleNeuralNets//NNHeatTransfer//model.onnx"))         annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(Re, evalNN.arrayIn[:, 1]) annotation (Line(points={{-100,60},{-40,60},{-40,0},{-9.8,0}}, color={0,0,127}));
  connect(Pr, evalNN.arrayIn[:, 2]) annotation (Line(points={{-100,0},{-9.8,0}}, color={0,0,127}));
  connect(dByL, evalNN.arrayIn[:, 3]) annotation (Line(points={{-100,-60},{-40,-60},{-40,0},{-9.8,0}}, color={0,0,127}));
  connect(Nu, evalNN.arrayOut[:, 1]) annotation (Line(points={{100,0},{10,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>The model was created with the script createLocalHeatTransferNN.py located in <a href=\"modelica://SMArtInt/Resources/ExampleNeuralNets/NNHeatTransfer/\">ExampleNeuralNets\\NNHeatTransfer\\</a> with setting preset = \"large\" in line 76.</p>
</html>"), Icon(graphics={Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://SMArtInt/Resources/Images/Icon_Inference.png")}));
end PipeLocalHeatTransfer_onnx;
