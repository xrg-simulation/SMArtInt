within SMArtInt.Internal.Utilities;
model RunInferenceFlatInputStatefulRNN
  parameter Integer nTotalInputsElements;
  parameter Integer nTotalOutputElements;

  parameter SMArtIntClass smartint;

  parameter Boolean continuous=true;
  parameter Real samplePeriod=0 "Fixed sample period for RNNs";

  final parameter Modelica.Units.SI.Time startTime(fixed=false);
  Boolean sampleTrigger;

  Modelica.Blocks.Interfaces.RealInput u[nTotalInputsElements]
    annotation (Placement(transformation(extent={{-118,-20},{-78,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nTotalOutputElements] annotation (Placement(transformation(extent={{80,-20},{120,20}})));

initial equation
  startTime = time;
equation
  if continuous then
    sampleTrigger = true;
    y[:] =InterfaceFunctions.runInferenceFlatTensor(
      smartint,
      time,
      u,
      nTotalOutputElements);
  else
    sampleTrigger = sample(startTime, samplePeriod);

    when {sampleTrigger, initial()} then
      y[:] =InterfaceFunctions.runInferenceFlatTensor(
        smartint,
        time,
        u,
        nTotalOutputElements);
    end when;


  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Bitmap(extent={{-102,-100},{102,100}},
          fileName="modelica://SMArtInt/Resources/Images/Icon_Inference.png")}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end RunInferenceFlatInputStatefulRNN;
