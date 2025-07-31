within SMArtInt.Tester;
package ExamplePI
  extends Modelica.Icons.ExamplesPackage;

  annotation (preferredView="info", Documentation(info="<html>
  <body>
    <h2 style=\"color: #ffaa00;\">PI Controller Example</h2>

    <p>
      This package demonstrates how to replace a traditional PI controller with Recurrent Neural Networks (RNNs) within a Modelica simulation.
    </p>

    <p>
      Two types of neural networks are integrated as surrogates for the PI controller:
    </p>
    <ul>
      <li>A standard RNN using 250 historical input values</li>
      <li>A stateful RNN (sRNN) that maintains internal state across simulation steps</li>
    </ul>

    <p>
      Both networks are provided in TensorFlow Lite and ONNX formats and are incorporated into Modelica via SMArtInt interface blocks.
    </p>

    <p>
      To validate the neural controllers, a step test applies a constant control deviation after 10 seconds. This allows observation of the proportional and integral actions compared to the traditional PI controller.
    </p>

    <p>
      Additionally, a more complex scenario models a two-room temperature regulation system. Here, the PI controller adjusts heating based on an external temperature profile provided through a <code>CombiTable</code>. A physical reference model is included to compare against the neural network controllers.
    </p>


    <br> <h3>Key Variables for Analysis</h3>

    <h4>Step Test Model</h4>
    <p>For the step test where a constant control deviation is applied, monitor the following variables:</p>
    <ul>
      <li><b>Controller input</b> (<code>controller.u</code>): The step input applied after 10 seconds.</li>
      <li><b>Controller output</b> (<code>controller.y</code>): Output signal of the PI controller and the neural network surrogates.</li>
    </ul>

    <h4>Two-Room Temperature Control Model</h4>
    <p>For the two-room temperature regulation scenario, important variables to observe include:</p>
    <ul>
      <li><b>Controller input</b> (<code>controller.u</code>): Difference between temperature setpoint and measured temperature (controller error).</li>
      <li><b>Controller output</b> (<code>controller.y</code>): Output signal of the PI controller and the neural network surrogates.</li>
      <li><b>Room temperature [K]</b> (<code>temperature.T</code>): Temperature in each room controlled by the PI or neural network controller.</li>
      <li><b>Temperature Setpoint [K]</b> (<code>combiTimeTable.y[1]</code>): Table output defining the setpoint for the room temperature. (Useful to plot alongside the actual room temperature.)</li>
    </ul>
  </body>
</html>
"));
end ExamplePI;
