within SMArtInt.Tester.ExamplePI.TFLite;
model StepTest_batched_Stateful_tflite
  extends Modelica.Icons.Example;

  Blocks.EvaluateStatefulRecurrentNeuralNet controller(
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt/Resources/ExampleNeuralNets/PIController/PI_stateful.tflite"),
    samplePeriod=10,
    batchSize=3,
    continuous=true) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Step step(height=1, startTime=100) annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Step step1(height=1, startTime=10000) annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation
  connect(step.y, controller.u[1, 1]) annotation (Line(points={{-19,40},{0,40},{0,-0.2},{20,-0.2}}, color={0,0,127}));
  connect(const.y, controller.u[2, 1]) annotation (Line(points={{-19,0},{20,0}}, color={0,0,127}));
  connect(step1.y, controller.u[3, 1]) annotation (Line(points={{-19,-40},{0,-40},{0,0.2},{20,0.2}}, color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=1,
      __Dymola_Algorithm="Dassl"));

end StepTest_batched_Stateful_tflite;
