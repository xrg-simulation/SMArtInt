within SMArtInt.Tester.ExamplePI.TFLite;
model DoubleRoom_RNNState_tflite
  extends Modelica.Icons.Example;
  extends ReferenceModels.DoubleRoom_ContinuousPI(redeclare TFLite.TF_PI_Stateful_tflite controller);
  annotation (experiment(
      StopTime=300000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"));
end DoubleRoom_RNNState_tflite;
