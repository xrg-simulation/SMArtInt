within SMArtInt.Tester.PipeHeatTransferExample.ReferenceModels;
model TestModelEvaluation_Ref
  extends Modelica.Icons.Example;
  extends TFLite.TestModelEvaluation_tflite(redeclare Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer heatTransfer);
end TestModelEvaluation_Ref;
