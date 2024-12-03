within SMArtInt.Internal;
class SMArtIntClass
  extends ExternalObject;
  extends Modelica.Icons.SourcesPackage;

  function constructor
    input ModelicaUtilityHelper modelicaUtilityHelper;
    input String pathToTfLiteFile "String to file";
    input Integer n_inputDim "Number of dimensions of input array";
    input Integer[n_inputDim] inputSizes "Sizes in each dimensions of input array";
    input Integer n_outputDim;
    input Integer[n_outputDim] outputSizes "Sizes in each dimensions of input array";
    input Boolean stateful = false;
    input Real fixEvalStep = 0;
    output SMArtIntClass smartint;
    external "C" smartint = NeuralNet_createObject(modelicaUtilityHelper, pathToTfLiteFile,
      n_inputDim, inputSizes, n_outputDim, outputSizes,
      stateful, fixEvalStep) annotation (
      Library={"SMArtInt","tensorflowlite_c", "onnxruntime_c"},
      LibraryDirectory="modelica://SMArtInt/Resources/Library");
  end constructor;

  function destructor
    input SMArtIntClass smartint;
  external"C" NeuralNet_destroyObject(smartint) annotation (
      Library={"SMArtInt","tensorflowlite_c", "onnxruntime_c"},
      LibraryDirectory="modelica://SMArtInt/Resources/Library");
  end destructor;
end SMArtIntClass;
