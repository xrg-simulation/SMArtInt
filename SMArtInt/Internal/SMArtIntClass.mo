within SMArtInt.Internal;
class SMArtIntClass
  extends ExternalObject;

  function constructor
    extends Modelica.Icons.Function;
    input ModelicaUtilityHelper modelicaUtilityHelper;
    input String pathToAIModel "String to file";
    input Integer n_inputDim "Number of dimensions of input array";
    input Integer[n_inputDim] inputSizes "Sizes in each dimensions of input array";
    input Integer n_outputDim;
    input Integer[n_outputDim] outputSizes "Sizes in each dimensions of input array";
    input Boolean stateful=false;
    input Real fixEvalStep=0;
    output SMArtIntClass smartint;
  external "C" smartint = NeuralNet_createObject(
        modelicaUtilityHelper,
        pathToAIModel,
        n_inputDim,
        inputSizes,
        n_outputDim,
        outputSizes,
        stateful,
        fixEvalStep) annotation (Library={"SMArtInt","tensorflowlite_c","onnxruntime_c"}, LibraryDirectory="modelica://SMArtInt/Resources/Library");
  end constructor;

  function destructor
    extends Modelica.Icons.Function;
    input SMArtIntClass smartint;
  external "C" NeuralNet_destroyObject(smartint) annotation (Library={"SMArtInt","tensorflowlite_c","onnxruntime_c"}, LibraryDirectory="modelica://SMArtInt/Resources/Library");
  end destructor;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          fillColor = {128,128,128},
          pattern = LinePattern.None,
          fillPattern = FillPattern.Solid,
          extent={{-70,-4.5},{0,4.5}}),
        Polygon(origin={23.3333,0},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-23.333,30.0},{46.667,0.0},{-23.333,-30.0}})}));
end SMArtIntClass;
