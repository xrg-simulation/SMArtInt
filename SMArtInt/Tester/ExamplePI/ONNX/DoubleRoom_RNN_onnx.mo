within SMArtInt.Tester.ExamplePI.ONNX;
model DoubleRoom_RNN_onnx
  extends Modelica.Icons.Example;
  extends ReferenceModels.DoubleRoom_ContinuousPI(redeclare ONNX.TF_PI_RNN_onnx controller);
  annotation (Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.ExamplePI\">ExamplePI</a>.
  <br>
</html>
"));
end DoubleRoom_RNN_onnx;
