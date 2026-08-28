within SMArtInt.Internal.Utilities.SubModels.Tests;
model Test_ReturnSequences
  extends Modelica.Icons.Example;
  Blocks.EvaluateRecurrentNeuralNet SeqFalse(
    final samplePeriod=1,
    final numberOfInputs=1,
    final numberOfOutputs=2,
    final batchSize=2,
    final returnSequences=false,
    useClaRaDelay=true,
    final nHistoricElements=10,
    continuous=true,
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt/Resources/ExampleNeuralNets/ReturnSequencesTester/accumulatorRNN_last.tflite")) annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=10,
    duration=10,
    offset=0,
    startTime=0) annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Constant const(k=1) annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Blocks.EvaluateRecurrentNeuralNet SeqTrue(
    final samplePeriod=1,
    final numberOfInputs=1,
    final numberOfOutputs=2,
    final batchSize=2,
    final returnSequences=true,
    useClaRaDelay=true,
    final nHistoricElements=10,
    continuous=true,
    pathToAIModel=Modelica.Utilities.Files.loadResource("modelica://SMArtInt/Resources/ExampleNeuralNets/ReturnSequencesTester/accumulatorRNN_seq.tflite")) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
equation
  connect(ramp.y, SeqFalse.u[1, 1]) annotation (Line(points={{-19,20},{18,20},{18,19.5}}, color={0,0,127}));
  connect(const.y, SeqTrue.u[2, 1]) annotation (Line(points={{-19,-20},{17,-20},{17,-19.5},{18,-19.5}}, color={0,0,127}));
  connect(ramp.y, SeqTrue.u[1, 1]) annotation (Line(points={{-19,20},{0,20},{0,-20},{18,-20}}, color={0,0,127}));
  connect(const.y, SeqFalse.u[2, 1]) annotation (Line(points={{-19,-20},{0,-20},{0,20},{18,20}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=20, __Dymola_Algorithm="Dassl"),
    Documentation(figures={Figure(
          title="Plot_Sequences",
          preferred=true,
          plots={Plot(curves={Curve(x=time, y=SeqTrue.ySequences[1, 1, 1]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 2]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 3]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 4]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 5]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 6]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 7]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 8]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 9]),Curve(x=time, y=SeqTrue.ySequences[1, 1, 10])})}),Figure(
          title="Plot_Sequences_Input",
          preferred=true,
          plots={Plot(curves={Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[1]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[2]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[3]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[4]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[5]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[6]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[7]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[8]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[9]),Curve(x=time, y=SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor[10])})}),Figure(
          title="Plot_Sequences_Output",
          preferred=true,
          plots={Plot(curves={Curve(x=time, y=SeqTrue.y[1, 1]),Curve(x=time, y=SeqTrue.y[1, 2]),Curve(x=time, y=SeqTrue.y[2, 1]),Curve(x=time, y=SeqTrue.y[2, 2]),Curve(x=time, y=SeqFalse.y[1, 1]),Curve(x=time, y=SeqFalse.y[1, 2]),Curve(x=time, y=SeqFalse.y[2, 1]),Curve(x=time, y=SeqFalse.y[2, 2])})}),Figure(
          title="Plot_Sequences_constInput",
          preferred=true,
          plots={Plot(curves={Curve(x=time, y=SeqTrue.ySequences[2, 1, 1]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 2]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 3]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 4]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 5]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 6]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 7]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 8]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 9]),Curve(x=time, y=SeqTrue.ySequences[2, 1, 10])})})}, info="<html>
  <body>
    <h2 style=\"color: #ffaa00;\">
      Test_ReturnSequences – 2-Output Linear Integrator RNN Example
    </h2>

    <p>
      This package demonstrates and validates the behavior of the
      <b>returnSequences</b> functionality for a recurrent neural network
      with <b>two outputs</b>.
    </p>

    <p>
      The model
      <code>SMArtInt.Internal.Utilities.SubModels.Tests.Test_ReturnSequences</code>
      implements a simple linear SimpleRNN without bias. Each output channel has
      its own recurrent weight, allowing the two outputs to evolve independently.
    </p>

    <p>
      The recurrence relation for each output is defined as:
    </p>

    <p style=\"margin-left:20px;\">
      h_i(t) = h_i(t-1) + W_i · x_i(t), &nbsp; i = 1, 2
    </p>

    <p>
      Consequently, each output acts as an independent discrete-time integrator,
      accumulating its respective input over time, scaled by its recurrent
      weight W<sub>i</sub>.
    </p>

    <h3>Purpose of the Model</h3>

    <p>
      The main objective of this test model is to verify the functional
      difference between:
    </p>

    <ul>
      <li>
        <b>returnSequences = true</b> – The network outputs the full output
        sequence for both outputs.
      </li>
      <li>
        <b>returnSequences = false</b> – The network outputs only the final
        values for both outputs.
      </li>
    </ul>

    <p>
      Because the network is linear and has two outputs, the expected behavior
      can be computed analytically. For constant input, each output grows
      linearly, at a rate determined by its recurrent weight W<sub>i</sub>.
    </p>

    <h3>Test Scenario</h3>

    <p>
      A constant input signal is applied to both outputs over multiple time
      steps. In this test configuration, the two output channels use different
      recurrent weights:
    </p>

    <p style=\"margin-left:20px;\">
      • Output 1: W = 1<br>
      • Output 2: W = 2
    </p>

    <p>
      The hidden states therefore evolve according to:
    </p>

    <p style=\"margin-left:20px;\">
      h_i(t) = h_i(t-1) + W_i · x_i(t), &nbsp; i = 1, 2
    </p>

    <p>
      With constant input, both outputs behave as linear integrators but grow at
      different rates depending on their respective weights.
    </p>

    <p>
      For example, if x_i(t) = 1 for all time steps, the output sequences become:
    </p>

    <p style=\"margin-left:20px;\">
      Output 1 (W = 1): 1, 2, 3, …, 10<br>
      Output 2 (W = 2): 2, 4, 6, …, 20
    </p>

    <p>
      This highlights that although both outputs follow the same integration
      principle, their growth differs due to their different recurrent weights.
    </p>

    <h3>Key Variables for Analysis</h3>

    <h4>Sequence Output Variant (returnSequences = true)</h4>
    <ul>
      <li>
        <b>Network input</b>
        (<code>SeqTrue.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor</code>):
        Flattened test signal for both outputs.
      </li>
      <li>
        <b>Network output</b> (<code>SeqTrue.y</code>): Final values for
        both outputs.
      </li>
      <li>
        <b>Network sequence output</b> (<code>SeqTrue.ySequences</code>): Full
        output sequences for both outputs.
      </li>
    </ul>

    <h4>Final-State Variant (returnSequences = false)</h4>
    <ul>
      <li>
        <b>Network input</b>
        (<code>SeqFalse.runInterferenceHistory.flattenedHistory[1].inputFlattenTensor</code>):
        Flattened test signal for both outputs.
      </li>
      <li>
        <b>Network output</b> (<code>SeqFalse.y</code>): Final value for
        both outputs.
      </li>
    </ul>

    <p>
      When simulated, the most important variables are plotted automatically.
    </p>

    <p>
      The final outputs of the <b>returnSequences = false</b> configuration must
      match the last values of the sequences from the
      <b>returnSequences = true</b> configuration for both outputs.
    </p>

    <h3>Expected Behavior</h3>

    <ul>
      <li>Linear growth for each output when input is constant</li>
      <li>No decay or forgetting (no bias, linear update equation)</li>
      <li>Different growth rates based on W = 1 and W = 2</li>
      <li>Identical final values between the two configurations</li>
      <li>Independent but consistent accumulation for the two outputs</li>
    </ul>

    <p>
      This model serves as a minimal, analytically verifiable benchmark for
      validating sequence handling and multi-output behavior in RNNs within the
      SMArtInt framework.
    </p>
  </body>
</html>"));
end Test_ReturnSequences;
