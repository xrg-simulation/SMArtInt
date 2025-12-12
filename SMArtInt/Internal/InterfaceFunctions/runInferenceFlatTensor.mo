within SMArtInt.Internal.InterfaceFunctions;
function runInferenceFlatTensor
  extends Modelica.Icons.Function;
  input SMArtIntClass smartint;
  input Real currentTime;
  input Real[:] flatInputTensor;
  input Integer n_out;
  output Real[n_out] flatOutputTensor;
external "C" NeuralNet_runInferenceFlatTensor(
    smartint,
    currentTime,
    flatInputTensor,
    size(flatInputTensor, 1),
    flatOutputTensor,
    n_out) annotation (Library={"SMArtInt","tensorflowlite_c","onnxruntime_c","onnxruntime_c_cpu","onnxruntime_providers_cuda","onnxruntime_providers_shared"}, LibraryDirectory="modelica://SMArtInt/Resources/Library");
end runInferenceFlatTensor;
