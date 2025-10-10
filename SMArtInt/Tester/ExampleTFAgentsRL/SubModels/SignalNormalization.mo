within SMArtInt.Tester.ExampleTFAgentsRL.SubModels;
model SignalNormalization "Normalize scalar input to [0,1] using (u - x_min)/(x_max - x_min) with optional clipping"
  parameter Real y_min=0 "Input lower bound";
  parameter Real y_max=1 "Input upper bound";
  parameter Boolean clip=true "Clip to [0,1]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(origin={-301.4,-37}, extent={{182.4,19},{220.4,57}}), iconTransformation(origin={-313,-40}, extent={{192,20},{232,60}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(origin={-81.4,-37},  extent={{182.4,19},{220.4,57}}), iconTransformation(origin={-93,-40},  extent={{192,20},{232,60}})));
protected
  Real y_raw;
equation
  y_raw = (u - y_min)/(y_max - y_min);
  y = if clip then min(1, max(0, y_raw)) else y_raw;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-102}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                Rectangle(
        extent={{-102,-98},{98,102}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Line(points={{-82,-68},{-52,-68},{48,72},{78,72}}),
    Polygon(
      points={{-2,92},{-10,70},{6,70},{-2,92}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{88,2},{66,-6},{66,10},{88,2}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-92,2},{66,2}}, color={192,192,192}),
    Line(points={{-2,-88},{-2,70}},
                                  color={192,192,192}),
        Text(
          extent={{60,-10},{78,-44}},
          textColor={0,0,0},
          textString="u"),
        Text(
          extent={{-30,92},{-12,58}},
          textColor={0,0,0},
          textString="y"),
        Text(
          extent={{38,6},{56,-28}},
          textColor={175,175,175},
          textString="1"),
        Text(
          extent={{-60,34},{-42,0}},
          textColor={175,175,175},
          textString="0"),
        Line(
          points={{-52,0},{-52,-68}},
          color={175,175,175},
          pattern=LinePattern.Dot),
        Line(
          points={{48,72},{48,2}},
          color={175,175,175},
          pattern=LinePattern.Dot)}));
end SignalNormalization;
