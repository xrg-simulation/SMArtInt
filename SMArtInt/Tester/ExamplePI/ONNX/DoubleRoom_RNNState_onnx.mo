within SMArtInt.Tester.ExamplePI.ONNX;
model DoubleRoom_RNNState_onnx
  extends Modelica.Icons.Example;
  extends ReferenceModels.DoubleRoom_ContinuousPI(redeclare ONNX.TF_PI_Stateful_onnx controller);
  annotation (experiment(
      StopTime=300000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Dassl"));
end DoubleRoom_RNNState_onnx;
