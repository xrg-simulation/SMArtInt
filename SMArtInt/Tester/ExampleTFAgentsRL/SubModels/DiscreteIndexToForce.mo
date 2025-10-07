within SMArtInt.Tester.ExampleTFAgentsRL.SubModels;
model DiscreteIndexToForce "Linear map: {0..n-1} -> [Fmin, Fmax] (purely algebraic, no events)"

  // Parameters
  parameter Integer n(min=2) = 6 "Number of discrete actions (0..n-1)";
  parameter Real Fmin = -100 "Minimum force [N]";
  parameter Real Fmax =  100 "Maximum force [N]";

  // Interface
  Modelica.Blocks.Interfaces.RealInput  disc_action
    "Discrete action id as Real (expected ~0..n-1)"
    annotation (Placement(transformation(origin={-110,0}, extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Interfaces.RealOutput cont_action
    "Mapped continuous force [N]"
    annotation (Placement(transformation(origin={110,0}, extent={{-20,-20},{20,20}})));

protected
  parameter Real gain = (Fmax - Fmin)/max(1, n-1);
equation
  // Pure algebraic linear mapping
  cont_action = Fmin + gain*disc_action;

  annotation (
    Icon(graphics = {
      Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}, fillColor={255,255,255}, fillPattern=FillPattern.Solid),
      Text(extent={{-84,88},{96,48}}, textString="Linear idx→Force", lineColor={0,0,0}),
        Line(points={{-90,-14},{-66,-14},{-66,4},{-48,4},{-48,24},{-30,24},{-30,2},{-10,2}}, color={28,108,200}),
        Rectangle(extent={{-90,38},{-10,-42}}, lineColor={0,0,0}),
        Line(points={{18,-14},{42,4},{60,24},{78,2}}, color={28,108,200}),
        Rectangle(extent={{8,38},{88,-42}}, lineColor={0,0,0})}),
    Documentation(info="
<html>
  <h3>DiscreteIndexToForceLinear</h3>
  <p>Maps a (nominally) discrete action id <code>disc_action ∈ {0..n−1}</code> to a continuous force in <code>[Fmin, Fmax]</code> using a <b>purely linear</b> relation (no events, no rounding):</p>
  <pre>cont_action = Fmin + (Fmax - Fmin)/(n - 1) * disc_action</pre>
  <h4>Example</h4>
  <p>With <code>n=6</code>, <code>Fmin=-100</code>, <code>Fmax=100</code>  →  <code>cont_action = 40*disc_action - 100</code>, so 0→−100, 1→−60, 2→−20, 3→20, 4→60, 5→100.</p>
  <h4>Notes</h4>
  <ul>
    <li>This block is event-free and fast. If <code>disc_action</code> is not an exact integer, the output will be an interpolated value.</li>
    <li>If you need strictly quantized levels (exact −100, −60, …, 100), use a sampled/quantized mapper instead.</li>
  </ul>
</html>
"));
end DiscreteIndexToForce;
