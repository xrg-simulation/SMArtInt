within SMArtInt.BaseClasses;
partial model BaseNeuralNet

  parameter String pathToAIModel="" "Choose path to AI model" annotation (Dialog(group="Selected Model", loadSelector(filter="AI models (*.tflite *.onnx)", caption="Open file of AI-Model")));

  parameter Integer inputDimensions=1 "Number of input dimension" annotation (Dialog(group="Tensor sizing"));
  parameter Integer[inputDimensions] inputSizes={1} "Vector with size of tensor in each dimension" annotation (Dialog(group="Tensor sizing"));
  final parameter Integer nInputElements=product(inputSizes);

  parameter Integer outputDimensions=1 "Number of output dimension" annotation (Dialog(group="Tensor sizing"));
  parameter Integer[outputDimensions] outputSizes={1} "Vector with size of tensor in each dimension" annotation (Dialog(group="Tensor sizing"));
  final parameter Integer nOutputElements=product(outputSizes);

  parameter Boolean stateful=false "Activate state handling for RNN with state in-/outputs" annotation (Dialog(group="RNN Timing Settings"));
  parameter Real samplePeriod=0 "Fixed sample period for RNNs" annotation (Dialog(group="RNN Timing Settings"));

protected
  final parameter SMArtInt.Internal.ModelicaUtilityHelper modelicaUtilityHelper=SMArtInt.Internal.ModelicaUtilityHelper();

  final parameter SMArtInt.Internal.SMArtIntClass smartint=SMArtInt.Internal.SMArtIntClass(
      modelicaUtilityHelper,
      pathToAIModel,
      inputDimensions,
      inputSizes,
      outputDimensions,
      outputSizes,
      stateful,
      samplePeriod);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://SMArtInt/Resources/Images/Icon_Inference.png")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This base class defines the parameter interface for all classes using the TfLite/ONNX interface. This class does not contain any evaluation call of a TfLite/ONNX model and therefore it should not be used.</p>
</html>"));
end BaseNeuralNet;
