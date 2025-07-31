within SMArtInt;
package Blocks
  extends Modelica.Icons.VariantsPackage;

  annotation (preferredView="info", Documentation(info="<html>
<h2 style=\"color: #ffaa00;\">Blocks</h2>
<p>This package provides several blocks which can be used to include different types of neural networks within Modelica models. These blocks can be included in models, but their in- and outputs are still generic arrays. The user has to fill the arrays in the same manner as they are used during training in python.</p>
<p>Steps to include a model:</p>
<ol>
<li>Create and train a model in, e.g., TensorFlow</li>
<li>Export a trained TensorFlow model as TfLite or ONNX model</li>
<li>Place the corresponding block in your model</li>
<li>Parametrize the block (provide path, number of in- and outputs, etc.)</li>
<li>Connect the in- and outputs of the block. The arrays have the same structure as those in the AI model (e.g. TensorFlow): the inputs have to be connected in the same manner as they are used in the neural network during training.</li>
</ol>
<p><br>The examples <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample.TFLite.PipeLocalHeatTransfer_tflite\">PipeLocalHeatTransfer_tflite</a> and <a href=\"modelica://SMArtInt.Tester.ExamplePI.TFLite.TF_PI_Stateful_tflite\">TF_PI_Stateful_tflite</a> use this approach.</p>
</html>"));
end Blocks;
