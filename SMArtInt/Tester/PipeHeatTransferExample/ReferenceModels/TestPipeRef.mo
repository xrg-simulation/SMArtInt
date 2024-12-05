within SMArtInt.Tester.PipeHeatTransferExample.ReferenceModels;
model TestPipeRef
  extends Modelica.Icons.Example;
  extends TFLite.TestPipe_tflite(pipe(redeclare model HeatTransfer = Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.LocalPipeFlowHeatTransfer));
end TestPipeRef;
