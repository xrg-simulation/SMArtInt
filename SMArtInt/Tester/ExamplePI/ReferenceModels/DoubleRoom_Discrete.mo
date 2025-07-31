within SMArtInt.Tester.ExamplePI.ReferenceModels;
model DoubleRoom_Discrete
  extends Modelica.Icons.Example;
  extends DoubleRoom_ContinuousPI(redeclare ReferenceModels.DiscretePID controller(
      k=30,
      T=1600,
      period=10));
  annotation (Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.ExamplePI\">ExamplePI</a>.
  <br>
</html>
"));
end DoubleRoom_Discrete;
