within SMArtInt;
package Tester
  extends Modelica.Icons.ExamplesPackage;
  annotation (preferredView="info", Documentation(info="<html>
  <body>
    <h2 style=\"color: #ffaa00;\">Tester</h2>
    <p>
      This section provides basic examples demonstrating how to use the SMArtInt library for integrating neural networks into Modelica simulations.
    </p>

    <h3>Included Examples</h3>
    <ul>
      <li>
        <a href=\"modelica://SMArtInt.Tester.ExamplePI\">PI Controller Example</a><br/>
        Demonstrates the use of Recurrent Neural Networks (RNNs), including:
        <ul>
          <li>A stateless RNN with 250 historical input values</li>
          <li>A stateful RNN (sRNN) variant</li>
        </ul>
      </li>
      <li>
        <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample\">Pipe Heat Transfer Example</a><br/>
        Replaces a physical pipe model with a Feed-Forward Neural Network. A batched input is used to simulate the spatial discretization.
      </li>
    </ul>

    <p>
      Both examples are provided for <b>ONNX</b> and <b>TFLite</b> versions of the neural networks and include a corresponding physics-based reference model for comparison.
    </p>
  </body>
</html>
"));
end Tester;
