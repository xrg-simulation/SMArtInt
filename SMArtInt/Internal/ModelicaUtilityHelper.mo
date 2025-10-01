within SMArtInt.Internal;
class ModelicaUtilityHelper
  extends ExternalObject;

  function constructor
    extends Modelica.Icons.Function;
    output ModelicaUtilityHelper modelicaUtiltityHelper;
  external "C" modelicaUtiltityHelper = createModelicaUtitlityHelper() annotation (Include="#include \"ModelicaUtilityInterface.cpp\"", IncludeDirectory="modelica://SMArtInt/Resources/Include/");
  end constructor;

  function destructor
    extends Modelica.Icons.Function;
    input ModelicaUtilityHelper modelicaUtiltityHelper;
  external "C" deleteModelicaUtitlityHelper(modelicaUtiltityHelper) annotation (Include="#include \"ModelicaUtilityInterface.cpp\"", IncludeDirectory="modelica://SMArtInt/Resources/Include/");
  end destructor;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(origin={23.3333,0},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-23.333,30.0},{46.667,0.0},{-23.333,-30.0}}),
        Rectangle(
          fillColor = {128,128,128},
          pattern = LinePattern.None,
          fillPattern = FillPattern.Solid,
          extent={{-70,-4.5},{0,4.5}})}));
end ModelicaUtilityHelper;
