within SMArtInt.Tester.ExampleTFAgentsRL;
model CartPoleDQNTest
  extends Modelica.Icons.Example;

  parameter Real Ts = 0.01 "Sampling period for observations (s)";

  SubModels.CartPole cartPole(phi_start=75*Modelica.Constants.pi/180)  annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  SMArtInt.Blocks.EvaluateSimpleFeedForwardNeuralNetwork evaluateSimpleFeedForwardNeuralNetwork(
    numberOfInputs=4,
    numberOfOutputs=1,
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt/Resources/ExampleNeuralNets/TFAgentsCartPole/cart_pole_DQN.tflite"))
                                                                                                                                          annotation (Placement(transformation(origin={-70,0},   extent={{-10,-10},{10,10}})));
  SubModels.SignalNormalization w_norm(y_min=-5, y_max=5) annotation (Placement(transformation(origin={50,40}, extent={{-10,-10},{10,10}})));
  SubModels.SignalNormalization pos_cart_norm(y_min=-2.4, y_max=2.4) annotation (Placement(transformation(origin={50,-20}, extent={{-10,-10},{10,10}})));
  SubModels.SignalNormalization phi_cart_norm(y_min=1.36, y_max=1.78) annotation (Placement(transformation(origin={50,20}, extent={{-10,-10},{10,10}})));
  SubModels.SignalNormalization v_norm(y_min=-5, y_max=5) annotation (Placement(transformation(origin={50,-40}, extent={{-10,-10},{10,10}})));

// Sampler + ZeroOrderHold (sample & hold) en cada observación
  Modelica.Blocks.Discrete.Sampler      s_pos(samplePeriod=Ts) annotation(
    Placement(transformation(origin={80,-20},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.ZeroOrderHold z_pos(samplePeriod=Ts) annotation(
    Placement(transformation(origin={100,-20},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.Sampler      s_v(  samplePeriod=Ts) annotation(
    Placement(transformation(origin={80,-40},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.ZeroOrderHold z_v( samplePeriod=Ts) annotation(
    Placement(transformation(origin={100,-40},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.Sampler      s_phi(samplePeriod=Ts) annotation(
    Placement(transformation(origin={80,20},     extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.ZeroOrderHold z_phi(samplePeriod=Ts) annotation(
    Placement(transformation(origin={100,20},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.Sampler      s_w(  samplePeriod=Ts) annotation(
    Placement(transformation(origin={80,40},    extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Discrete.ZeroOrderHold z_w( samplePeriod=Ts) annotation(
    Placement(transformation(origin={100,40},   extent = {{-7, -7}, {7, 7}})));

  SubModels.DiscreteIndexToForce discreteIndexToForce(Fmin=-100, Fmax=100) annotation (Placement(transformation(origin={-42,0}, extent={{-10,-10},{10,10}})));
equation
  connect(cartPole.w_pole, w_norm.u) annotation(
    Line(points={{21.6,12},{32,12},{32,40},{39.9,40}},      color = {0, 0, 127}));
  connect(cartPole.phi_pole, phi_cart_norm.u) annotation(
    Line(points={{21.2,4.4},{36,4.4},{36,20},{39.9,20}},        color = {0, 0, 127}));
  connect(cartPole.pos_cart, pos_cart_norm.u) annotation(
    Line(points={{21.2,-4},{36,-4},{36,-20},{39.9,-20}},        color = {0, 0, 127}));
  connect(cartPole.v, v_norm.u) annotation(
    Line(points={{21.2,-12},{34,-12},{34,-40},{39.9,-40}},      color = {0, 0, 127}));
  connect(discreteIndexToForce.cont_action,cartPole.F)  annotation(
    Line(points={{-31,0},{-17.6,0}},                                   color = {0, 0, 127}));
  connect(evaluateSimpleFeedForwardNeuralNetwork.arrayOut[1, 1], discreteIndexToForce.disc_action) annotation(
    Line(points={{-60,0},{-53,0}},          color = {0, 0, 127}));
  connect(w_norm.y, s_w.u) annotation(
    Line(points={{59.9,40},{71.6,40}},  color = {0, 0, 127}));
  connect(s_w.y, z_w.u) annotation(
    Line(points={{87.7,40},{91.6,40}},  color = {0, 0, 127}));
  connect(phi_cart_norm.y, s_phi.u) annotation(
    Line(points={{59.9,20},{71.6,20}},    color = {0, 0, 127}));
  connect(s_phi.y, z_phi.u) annotation(
    Line(points={{87.7,20},{91.6,20}},    color = {0, 0, 127}));
  connect(pos_cart_norm.y, s_pos.u) annotation(
    Line(points={{59.9,-20},{71.6,-20}},  color = {0, 0, 127}));
  connect(s_pos.y, z_pos.u) annotation(
    Line(points={{87.7,-20},{91.6,-20}},  color = {0, 0, 127}));
  connect(v_norm.y, s_v.u) annotation(
    Line(points={{59.9,-40},{71.6,-40}},  color = {0, 0, 127}));
  connect(z_v.u, s_v.y) annotation(
    Line(points={{91.6,-40},{87.7,-40}},  color = {0, 0, 127}));
  connect(z_pos.y, evaluateSimpleFeedForwardNeuralNetwork.arrayIn[1, 1]) annotation(
    Line(points={{107.7,-20},{120,-20},{120,-52},{-86,-52},{-86,0},{-79.8,0}},            color = {0, 0, 127}));
  connect(z_v.y, evaluateSimpleFeedForwardNeuralNetwork.arrayIn[1, 2]) annotation(
    Line(points={{107.7,-40},{120,-40},{120,-52},{-86,-52},{-86,0},{-79.8,0}},            color = {0, 0, 127}));
  connect(z_phi.y, evaluateSimpleFeedForwardNeuralNetwork.arrayIn[1, 3]) annotation(
    Line(points={{107.7,20},{118,20},{118,54},{-86,54},{-86,0},{-79.8,0}},                color = {0, 0, 127}));
  connect(z_w.y, evaluateSimpleFeedForwardNeuralNetwork.arrayIn[1, 4]) annotation(
    Line(points={{107.7,40},{118,40},{118,54},{-86,54},{-86,0},{-79.8,0}},              color = {0, 0, 127}));

annotation(
  Diagram(coordinateSystem(extent = {{-100, 60}, {140, -60}})));
end CartPoleDQNTest;
