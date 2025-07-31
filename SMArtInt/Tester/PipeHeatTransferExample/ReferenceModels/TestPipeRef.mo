within SMArtInt.Tester.PipeHeatTransferExample.ReferenceModels;
model TestPipeRef
  extends Modelica.Icons.Example;
  extends TFLite.TestPipe_tflite(pipe(redeclare model HeatTransfer = Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer));
  annotation (experiment(StopTime=100, __Dymola_Algorithm="Dassl"), Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample\">PipeHeatTransferExample</a>.
  <br>
</html>
"));
end TestPipeRef;
