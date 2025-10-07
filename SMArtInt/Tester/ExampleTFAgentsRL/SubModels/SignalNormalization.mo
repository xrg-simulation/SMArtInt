within SMArtInt.Tester.ExampleTFAgentsRL.SubModels;
model SignalNormalization "Normalize scalar input to [0,1] using (u - x_min)/(x_max - x_min) with optional clipping"
  parameter Real x_min=0 "Input lower bound";
  parameter Real x_max=1 "Input upper bound";
  parameter Boolean clip=true "Clip to [0,1]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(origin={-301.4,-37}, extent={{182.4,19},{220.4,57}}), iconTransformation(origin={-313,-40}, extent={{192,20},{232,60}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(origin={-101.4,-37}, extent={{182.4,19},{220.4,57}}), iconTransformation(origin={-113,-40}, extent={{192,20},{232,60}})));
protected
  Real y_raw;
equation
  y_raw = (u - x_min)/(x_max - x_min);
  y = if clip then min(1, max(0, y_raw)) else y_raw;

end SignalNormalization;
