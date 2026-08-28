within SMArtInt.Tester.PipeHeatTransferExample.TFLite;
model PipeLocalHeatTransfer_smallNN
  extends BaseClasses.BaseFeedForwardNeuralNet(
    final numberOfOutputs=1,
    final numberOfInputs=3,
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt//Resources//ExampleNeuralNets//model_small.tflite"));

  Modelica.Blocks.Interfaces.RealInput Re[batchSize] annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput Pr[batchSize] annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput dByL[batchSize] annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Nu[batchSize] annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(Re, array2DFlatteningModel.arrayIn[:, 1]) annotation (Line(points={{-120,60},{-60,60},{-60,0},{-42,0}}, color={0,0,0}));
  connect(Pr, array2DFlatteningModel.arrayIn[:, 2]) annotation (Line(points={{-120,0},{-42,0}}, color={0,0,0}));
  connect(dByL, array2DFlatteningModel.arrayIn[:, 3]) annotation (Line(points={{-120,-60},{-60,-60},{-60,0},{-42,0}}, color={0,0,0}));
  connect(array2DDeflatteningModel.arrayOut[:, 1], Nu) annotation (Line(points={{41,0},{110,0}}, color={0,0,0}));
  annotation (Documentation(info="<html>
<p>The model was created with the script createLocalHeatTransferNN.py located in <a href=\"modelica://SMArtInt/Resources/ExampleNeuralNets/NNHeatTransfer/\">ExampleNeuralNets\\NNHeatTransfer\\</a> with setting preset = \"small\" in line 76.</p>
</html>"));
end PipeLocalHeatTransfer_smallNN;
