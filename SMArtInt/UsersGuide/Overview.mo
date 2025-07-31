within SMArtInt.UsersGuide;
model Overview
  extends Modelica.Icons.Information;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    preferredView="info",
    Documentation(info="<html>
<p><br></span><b></span><span style=\"font-size: 19.5pt; color: #ffaa00;\">SMArtInt Library</b><span style=\"color: #ffaa00;\"> </span></p>
<p>The <b>SMArtInt Library</b> is designed to integrate various artificial intelligence (AI) models seamlessly into Modelica-based simulation tools. <b>SMArtInt</b>, short for <b>S</b>imple <b>M</b>odelica <b>Art</b>ificial <b>I</b>ntelligence I<b>nt</b>erface, provides a user-friendly interface that bridges advanced AI capabilities with the power of Modelica simulations, enhancing both modeling efficiency and simulation accuracy. </p>
<p>Currently, it supports the following tools: </p>
<ul>
<li>Dymola </li>
<li>OpenModelica </li>
</ul>
<p>With: </p>
<ul>
<li>TensorFlow models exported as TFLite </li>
<li>ONNX models </li>
</ul>
<p>The repository contains a compiled version of the interface for usage in windows. <b>As a starting point open the Modelica Library. It contains some ready to run examples <a href=\"modelica://SMArtInt.Tester\">Tester</a> which demonstrate the usage.</b> The corresponding python files which create the TF-Lite and ONNX models are located in <a href=\"modelica://SMArtInt/Resources/ExampleNeuralNets\">Resources</a>.</p>
<h4>Hints for usage in Dymola:</h4>
<p>Currently, only a 64-bit version is available. If the variable <code>Advanced.CompileWith64</code> is set on its default value 0, Dymola will automatically compile a 64-bit Dymosim.exe after giving a remark in the translate log file. In case <code>Advanced.CompileWith64=2</code> a 64-bit dymosim.exe is created anyway and in case of <code>Advanced.CompileWith64=1</code> compilation will fail. </p>
<h4>Copyright:</h4>
<p>SMArtInt uses other software - the source code is included as submodule and/or as compiled version for direct usage: </p>
<ul>
<li>Tensorflow (<a href=\"https://github.com/tensorflow/tensorflow\">https://github.com/tensorflow/tensorflow</a>)<br>License: <a href=\"https://github.com/tensorflow/tensorflow/blob/master/LICENSE\">https://github.com/tensorflow/tensorflow/blob/master/LICENSE</a> </li>
<li>Bazel.exe (<a href=\"https://github.com/bazelbuild/bazel\">https://github.com/bazelbuild/bazel</a>)<br>License: <a href=\"https://github.com/bazelbuild/bazel/blob/master/LICENSE\">https://github.com/bazelbuild/bazel/blob/master/LICENSE</a> </li>
<li>ClaRa Delay (<a href=\"https://github.com/xrg-simulation/ClaRaDelay\">https://github.com/xrg-simulation/ClaRaDelay</a>)<br>License: <a href=\"https://github.com/xrg-simulation/ClaRaDelay/blob/main/CSource/LICENSE\">https://github.com/xrg-simulation/ClaRaDelay/blob/main/CSource/LICENSE</a> </li>
<li>ONNX Runtime (<a href=\"https://github.com/microsoft/onnxruntime\">https://github.com/microsoft/onnxruntime</a>)<br>License: <a href=\"https://github.com/microsoft/onnxruntime/blob/main/LICENSE\">https://github.com/microsoft/onnxruntime/blob/main/LICENSE</a> </li>
</ul>
<p>This work was carried out within the framework of the research project DIZPROVI, supported by the Federal Ministry of Education and Research (number 03WIR0105E). </p>
</html>"));
end Overview;
