within SMArtInt;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info", Documentation(info="<html>
  <body>
    <p><br></span><b></span><span style=\"font-size: 19.5pt; color: #ffaa00;\">Welcome to the SMArtInt Library</b><span style=\"color: #ffaa00;\"> </span></p>
    <p>
      The <b>SMArtInt</b> (Simple Modelica Artificial Intelligence Interface) library provides components for integrating external neural network models—such as <i>TensorFlow Lite</i> or <i>ONNX</i>—into Modelica-based simulations. It is designed to work with <b>Dymola</b> and <b>OpenModelica</b> and enables hybrid modeling approaches that combine physics-based models with machine-learned surrogate models.
    </p>

    <h2>Purpose</h2>
    <p>
      SMArtInt facilitates the connection between dynamic Modelica models and external AI-based computations by providing reusable interface blocks and examples. Typical use cases include:
    </p>
    <ul>
      <li>Embedding neural networks as <b>surrogate models</b></li>
      <li>Applying <b>hybrid modeling and control strategies</b>, combining physics-based and data-driven components</li>
    </ul>

    <h2>Library Structure</h2>
    <p>The SMArtInt library consists of the following main Modelica packages:</p>
    <ul>
      <li><b>UsersGuide</b>: Introduction and overview of the library, usage patterns, and documentation structure.</li>
      <li><b>Tester</b>: Ready-to-run example models demonstrating how to use SMArtInt components in simulations.</li>
      <li><b>BaseClasses</b>: Abstract base models and partial classes providing reusable structure and logic for custom blocks.</li>
      <li><b>Blocks</b>: Usable interface blocks for loading and running AI models (.onnx or .tflite) inside Modelica models.</li>
      <li><b>Internal</b>: Utility components and internal implementations not intended for direct use.</li>
      </ul>
    <p>
      <b><a href=\"modelica://SMArtInt/Resources/ExampleNeuralNets\">Resources/ExampleNeuralNets</a></b>: Python scripts and neural network files (e.g., .tflite, .onnx) used in the tester examples. They show how to prepare compatible models from common ML frameworks.
    </p>

    <h2>Getting Started</h2>
    <ol>
      <li>Open the SMArtInt library in your preferred Modelica environment (Dymola or OpenModelica).</li>
      <li>Explore the <code><a href=\"modelica://SMArtInt.Tester\">SMArtInt.Tester</a></code> package to run ready-to-use examples.</li>
      <li>Review the documentation included with each block for configuration and usage instructions.</li>
      <li>The <a href=\"modelica://SMArtInt.UsersGuide.Overview\">Overview</a> section also provides a general introduction to the library.</li>
      <li>If needed, use the provided Python scripts to generate your own AI models for integration.</li>
    </ol>

    <h2>Documentation Details</h2>
    <p>
      Detailed usage instructions, parameter descriptions, and model behavior are documented directly within the <b>Modelica components/packages</b>. To understand how a specific block or model works, simply navigate to it in your Modelica tool and view its embedded documentation.
    </p>
    <p>
      The tester models also include additional explanations and typical application patterns. They are intended as both verification models and starting templates for your own projects.
    </p>

    <h2>System Requirements</h2>
    <p>The library relies on external C-libraries and works on 64-bit Windows systems. Please ensure the following for successful use:</p>
    <ul>
      <li>Use 64-bit Dymola (tested) or recent versions of OpenModelica
        <ul>
          <li>Tested for Dymola 2025x Refresh 1 and OpenModelica v1.25.1</li>
        </ul>
      </li>
      <li>Set <code>Advanced.CompileWith64</code> = true in Dymola if required</li>
    </ul>

    <h2>Further Resources</h2>
    <ul>
      <li><b>GitHub Repository</b>: <a href=\"https://github.com/xrg-simulation/SMArtInt\">https://github.com/xrg-simulation/SMArtInt</a></li>
      <li><b>SMArtInt+ (Commercial Version)</b>: Additional features such as extrapolation warnings, dedimensionalization, and automatic block generation are available via XRG Simulation’s <a href=\"https://xrg-simulation.de/en/seiten/smartint\">SMArtInt+ Library</a>.</li>
    </ul>

    <h2>Contact</h2>
    <p>For feedback, questions, or contributions, please visit the GitHub repository or contact XRG Simulation GmbH via their website.</p>
  </body>
</html>
"));
end UsersGuide;
