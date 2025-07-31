within SMArtInt.Tester.PipeHeatTransferExample.ReferenceModels;
model TestModelEvaluation_Ref
  extends Modelica.Icons.Example;
  extends TFLite.TestModelEvaluation_tflite(redeclare Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer heatTransfer);
  annotation (Documentation(info="<html>
  For more detailed information about this model, including explanations of its components and key variables for analysis, please refer to the documentation of the higher-level package <a href=\"modelica://SMArtInt.Tester.PipeHeatTransferExample\">PipeHeatTransferExample</a>.
  <br>
</html>
"));
end TestModelEvaluation_Ref;
