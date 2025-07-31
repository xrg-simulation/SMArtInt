within SMArtInt.Internal;
class ModelicaUtilityHelper
  extends ExternalObject;
  extends Modelica.Icons.SourcesPackage;

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
end ModelicaUtilityHelper;
