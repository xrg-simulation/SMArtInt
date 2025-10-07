within SMArtInt.Tester.ExampleTFAgentsRL.SubModels;
model CartPole "Simple Cart Pole Model"
  parameter Boolean animation=true "= true, if animation shall be enabled";
  inner Modelica.Mechanics.MultiBody.World world(nominalLength=10)
                                                 annotation (Placement(
        transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Mechanics.MultiBody.Joints.Prismatic prismatic(useAxisFlange=true,
    s(fixed=true, start=0),
    v(fixed=true))
    annotation (Placement(transformation(extent={{-40,30},{-20,10}})));
  Modelica.Mechanics.MultiBody.Parts.Fixed fixed annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Mechanics.MultiBody.Parts.PointMass pointMass_cart(m=m_cart)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute(
    n(each displayUnit="1") = {0,0,1},
    phi(fixed=false, start=phi_start),
    w(fixed=false, start=w_pole_start))
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation fixedTranslation(r={l_pole,0,0})
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,58})));
  Modelica.Mechanics.MultiBody.Parts.PointMass pointMass_pole(m=m_pole)
    annotation (Placement(transformation(extent={{50,72},{70,92}})));
  Modelica.Mechanics.Translational.Sources.Force force(useSupport=true)
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
  parameter Modelica.Units.SI.Mass m_cart=10 "Mass of cart";
  parameter Modelica.Units.SI.Mass m_pole = 1 "Mass of pole (assumed at top)";
  parameter Modelica.Units.SI.Length l_pole = 1 "Length of the pole";
  Modelica.Blocks.Interfaces.RealInput F "Driving force as input signal"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),     iconTransformation(origin={18,-60},    extent = {{-126, 40}, {-86, 80}})));
  Modelica.Mechanics.MultiBody.Sensors.RelativePosition relativePosition
    annotation (Placement(transformation(extent={{-34,-58},{-14,-38}})));
  Modelica.Blocks.Interfaces.RealOutput pos_cart
    "Relative position vector resolved in frame defined by resolveInFrame"
    annotation (Placement(transformation(extent={{96,-30},{116,-10}})));
  Modelica.Mechanics.MultiBody.Sensors.RelativeVelocity relativeVelocity
    annotation (Placement(transformation(extent={{-34,-92},{-14,-72}})));
  Modelica.Blocks.Interfaces.RealOutput v "Velocity of the cart"
    annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  Modelica.Mechanics.MultiBody.Sensors.RelativeAngles relativeAngles
    annotation (Placement(transformation(extent={{20,14},{40,34}})));
  Modelica.Blocks.Interfaces.RealOutput phi_pole "Angle of the pole"
    annotation (Placement(transformation(extent={{96,12},{116,32}})));
  Modelica.Mechanics.MultiBody.Sensors.RelativeAngularVelocity
    relativeAngularVelocity
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Modelica.Blocks.Interfaces.RealOutput w_pole "Angular velocity of the pole"
    annotation (Placement(transformation(extent={{98,50},{118,70}})));
  parameter Modelica.Units.SI.Angle phi_start(fixed=true) = 85*Modelica.Constants.pi/180
    "Initial angle of the pole";
  parameter Modelica.Units.SI.AngularVelocity w_pole_start(fixed=true) = 0
    "Initial angular velocity of the pole";

initial equation
  phi_pole = phi_start;
  w_pole = w_pole_start;

equation

  connect(fixed.frame_b, prismatic.frame_a)
    annotation (Line(
      points={{-60,80},{-46,80},{-46,20},{-40,20}},
      color={95,95,95},
      thickness=0.5));
  connect(prismatic.frame_b, pointMass_cart.frame_a)
    annotation (Line(
      points={{-20,20},{0,20},{0,0}},
      color={95,95,95},
      thickness=0.5));
  connect(force.support, prismatic.support) annotation (Line(points={{-68,-10},{-68,-14},{-34,-14},{-34,14}},
                                                                                          color={0,127,0}));
  connect(force.flange, prismatic.axis) annotation (Line(points={{-58,0},{-22,0},{-22,14}},    color={0,127,0}));
  connect(force.f,F)  annotation (Line(points={{-80,0},{-106,0}},   color={0,0,127}));
  connect(relativePosition.frame_b, pointMass_cart.frame_a)
    annotation (Line(
      points={{-14,-48},{0,-48},{0,0}},
      color={95,95,95},
      thickness=0.5));
  connect(relativePosition.frame_a, prismatic.frame_a)
    annotation (Line(
      points={{-34,-48},{-46,-48},{-46,20},{-40,20}},
      color={95,95,95},
      thickness=0.5));
  connect(relativePosition.r_rel[1], pos_cart)
    annotation (Line(points={{-24,-59.3333},{-24,-60},{64,-60},{64,-20},{106,-20}}, color={0,0,127}));
  connect(relativeVelocity.frame_a, prismatic.frame_a) annotation (Line(
      points={{-34,-82},{-46,-82},{-46,20},{-40,20}},
      color={95,95,95},
      thickness=0.5));
  connect(relativeVelocity.frame_b, revolute.frame_a) annotation (Line(
      points={{-14,-82},{14,-82},{14,0},{20,0}},
      color={95,95,95},
      thickness=0.5));
  connect(relativeVelocity.v_rel[1], v) annotation (Line(points={{-24,-93.3333},{80,-93.3333},{80,-60},{106,-60}},
                                                  color={0,0,127}));
  connect(relativeAngles.angles[3], phi_pole) annotation (Line(points={{30,13.3333},{90,13.3333},{90,22},{106,22}},
                                                    color={0,0,127}));
  connect(relativeAngularVelocity.w_rel[3], w_pole) annotation (Line(points={{30,49.3333},{30,42},{94,42},{94,60},{108,60}},
                                                         color={0,0,127}));
  connect(revolute.frame_a, relativeAngles.frame_a)
    annotation (Line(
      points={{20,0},{16,0},{16,24},{20,24}},
      color={95,95,95},
      thickness=0.5));
  connect(relativeAngularVelocity.frame_a, relativeAngles.frame_a)
    annotation (Line(
      points={{20,60},{16,60},{16,24},{20,24}},
      color={95,95,95},
      thickness=0.5));
  connect(revolute.frame_b, fixedTranslation.frame_a)
    annotation (Line(
      points={{40,0},{60,0},{60,48}},
      color={95,95,95},
      thickness=0.5));
  connect(relativeAngles.frame_b, fixedTranslation.frame_a)
    annotation (Line(
      points={{40,24},{60,24},{60,48}},
      color={95,95,95},
      thickness=0.5));
  connect(relativeAngularVelocity.frame_b, fixedTranslation.frame_a)
    annotation (Line(
      points={{40,60},{44,60},{44,48},{60,48}},
      color={95,95,95},
      thickness=0.5));
  connect(fixedTranslation.frame_b, pointMass_pole.frame_a)
    annotation (Line(
      points={{60,68},{60,82}},
      color={95,95,95},
      thickness=0.5));
  connect(pointMass_cart.frame_a, revolute.frame_a)
    annotation (Line(
      points={{0,0},{20,0}},
      color={95,95,95},
      thickness=0.5));
  annotation (
    experiment(StopTime=10),
    Documentation(info="<html>
<p>
This example demonstrates:
</p>
<ul>
<li>The animation of spring and damper components</li>
<li>A body can be freely moving without any connection to a joint.
    In this case body coordinates are used automatically as
    states (whenever joints are present, it is first tried to
    use the generalized coordinates of the joints as states).</li>
<li>If a body is freely moving, the initial position and velocity of the body
    can be defined with the \"Initialization\" menu as shown with the
    body \"body1\" in the left part (click on \"Initialization\").</li>
</ul>

<img src=\"modelica://Modelica/Resources/Images/Mechanics/MultiBody/Examples/Elementary/FreeBody.png\"
alt=\"model Examples.Elementary.FreeBody\">
</html>"),
  Icon(graphics = {Rectangle(origin = {0, -20}, lineColor = {0, 170, 255}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 20}, {40, -20}}), Line(origin = {0, -40}, points = {{100, 0}, {-100, 0}}, thickness = 1.5), Polygon(origin = {9, 24}, lineColor = {85, 255, 127}, fillColor = {85, 255, 127}, fillPattern = FillPattern.Solid, points = {{7, 46}, {-13, -42}, {-13, -46}, {-11, -48}, {-9, -48}, {-7, -46}, {-7, -44}, {13, 42}, {13, 46}, {11, 48}, {9, 48}, {7, 46}, {7, 46}, {7, 46}}), Text(origin = {-63, 28}, extent = {{-33, 30}, {33, -30}}, textString = "F"), Rectangle(origin = {0, -50}, lineColor = {246, 246, 249}, fillColor = {246, 246, 249}, fillPattern = FillPattern.Solid, extent = {{-100, -10}, {100, 10}})}));
end CartPole;
