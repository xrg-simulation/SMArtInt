within SMArtInt.Tester;
package PipeHeatTransferExample
  extends Modelica.Icons.ExamplesPackage;

  annotation (preferredView="info", Documentation(info="<html>
  <body>
    <h2 style=\"color: #ffaa00;\">Heat Transfer Example</h2>

    <p>
      This package demonstrates how to replace traditional heat transfer coefficient calculations with Feed-Forward Neural Networks (FFNNs) in a Modelica simulation.
    </p>

    <p>
      Two types of neural networks are integrated as surrogates for the physical Nusselt number model:
    </p>
    <ul>
      <li>A simple FFNN</li>
      <li>A deeper, more complex FFNN</li>
    </ul>

    <p>
      Both models are exported in TensorFlow Lite and ONNX formats and are incorporated into Modelica via SMArtInt interface blocks.
    </p>

    <p>
      The pipe model is spatially discretized into 100 segments. Each segment requires one inference, which is performed efficiently in batch mode using a single neural network instance.
    </p>

    <br> <h3>Key Variables to Observe</h3>

    <h4>Model Evaluation</h4>
    <p>This model compares neural network outputs directly to a physical reference for a set of test inputs. Important variables to monitor:</p>
    <ul>
      <li><b>Nusselt number (predicted)</b> (<code>heatTransfer.Nus</code>): Neural network output for heat transfer estimation.</li>
      <li><b>Heat transfer coefficient</b> (<code>heatTransfer.alphas</code>): Derived from the predicted Nusselt number.</li>
    </ul>

    <h4>Pipe Model</h4>
    <p>In this model, the neural network replaces the heat transfer calculation inside the pipe simulation. Key variables include:</p>
    <ul>
      <li><b>Inlet enthalpy [J/kg]</b> (<code>pipe.port_a.h_outflow</code>): Enthalpy at the pipe entry.</li>
      <li><b>Outlet enthalpy [J/kg]</b> (<code>pipe.port_b.h_outflow</code>): Enthalpy at the pipe exit.</li>
      <li><b>Temperature in heat ports [K]</b> (<code>pipe.heatPorts.T</code>): Port/wall temperature in different pipe segments.</li>
    </ul>

  </body>
</html>
"));
end PipeHeatTransferExample;
