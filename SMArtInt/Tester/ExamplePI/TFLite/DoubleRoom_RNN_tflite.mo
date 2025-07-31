within SMArtInt.Tester.ExamplePI.TFLite;
model DoubleRoom_RNN_tflite
  extends Modelica.Icons.Example;
  extends ReferenceModels.DoubleRoom_ContinuousPI(redeclare TFLite.TF_PI_RNN_tflite controller);
  annotation (Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.ExamplePI\">ExamplePI</a>.
  <br>
</html>
"));
end DoubleRoom_RNN_tflite;
