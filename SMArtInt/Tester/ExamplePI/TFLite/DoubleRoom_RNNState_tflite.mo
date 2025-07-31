within SMArtInt.Tester.ExamplePI.TFLite;
model DoubleRoom_RNNState_tflite
  extends Modelica.Icons.Example;
  extends ReferenceModels.DoubleRoom_ContinuousPI(redeclare TFLite.TF_PI_Stateful_tflite controller);
  annotation (experiment(
      StopTime=300000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.ExamplePI\">ExamplePI</a>.
  <br>
</html>
"));
end DoubleRoom_RNNState_tflite;
