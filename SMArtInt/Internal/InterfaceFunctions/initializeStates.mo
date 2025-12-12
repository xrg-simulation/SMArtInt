within SMArtInt.Internal.InterfaceFunctions;
function initializeStates
  extends Modelica.Icons.Function;
  input SMArtIntClass smartint;
  input Real time_value;
  input Real[:] flatStateValues;
external "C" NeuralNet_initializeStates(
    smartint,
    time_value,
    flatStateValues,
    size(flatStateValues, 1)) annotation (Library={"SMArtInt","tensorflowlite_c","onnxruntime_c","onnxruntime_c_cpu","onnxruntime_providers_cuda","onnxruntime_providers_shared"}, LibraryDirectory="modelica://SMArtInt/Resources/Library");
end initializeStates;
