within SMArtInt.Blocks;
model EvaluateRecurrentNeuralNet
  extends BaseClasses.BaseRecurrentNeuralNet;
  Modelica.Blocks.Interfaces.RealInput u[numberOfInputs] annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Interfaces.RealOutput                  y[numberOfOutputs]
    annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
equation
  connect(runInterferenceHistory.u, u) annotation (Line(points={{-10,0},{-100,0}}, color={0,0,127}));
  connect(runInterferenceHistory.y_flat, y) annotation (Line(points={{9.8,0},{100,0}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>Use this block if you want to include a recurrent neural network in Modelica.</p>
<p>Please place this block in your model and</p>
<ul>
<li>give the path to the TFLite/ONNX model</li>
<li>specify the number of inputs</li>
<li>specify the sampling interval and how many elements from previous times should be fed into the net</li>
<li>provide the values for the input of the block and use the outputs in the same manner as it was done during training</li>
</ul>
<p>In continuous mode the historic values are generated by a delay. You could choose between the computational improved Clara-Delay and the delay in the Modelica-Standard-Library. If continuous is deactivated the model will create an event when reaching the sampling time - this should be avoided for performance reasons.</p>
<p>As tensorflow lite uses a flattened input array, you have to specify the flattening method. In the standard tensorflow setting you have to use the predefined option OldFirstInputSequential.</p>
<p>The example <a href=\"modelica://SMArtInt.Tester.ExamplePI.TFLite.TF_PI_RNN_tflite\">TF_PI_RNN_tflite</a> uses this block.</p>
</html>"));
end EvaluateRecurrentNeuralNet;
