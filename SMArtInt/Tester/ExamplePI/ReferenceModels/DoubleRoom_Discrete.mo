within SMArtInt.Tester.ExamplePI.ReferenceModels;
model DoubleRoom_Discrete
  extends Modelica.Icons.Example;
  extends DoubleRoom_ContinuousPI(redeclare ReferenceModels.DiscretePID controller(
      k=30,
      T=1600,
      period=10));
end DoubleRoom_Discrete;
