within SMArtInt.Tester.ExamplePI.ONNX;
model StepTest_Stateful_onnx
  extends Modelica.Icons.Example;
  extends TFLite.StepTest_RNN_tflite(redeclare ONNX.TF_PI_Stateful_onnx controller);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=1,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.ExamplePI\">ExamplePI</a>.
  <br>
</html>
"));
end StepTest_Stateful_onnx;
