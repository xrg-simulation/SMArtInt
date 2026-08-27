within SMArtInt.Tester.PipeHeatTransferExample.ONNX;
model NNHeatTransfer_onnx
  extends Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialPipeFlowHeatTransfer;

  replaceable ONNX.PipeLocalHeatTransfer_onnx pipeLocalHeatTransfer(batchSize=n) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression Expr_Res[n](y=Res) annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.RealExpression Expr_Prs[n](y=Prs) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression Expr_dByLs[n](y={diameters[i]/lengths[i]/(if vs[i] >= 0 then (i - 0.5) else (n - i + 0.5)) for i in 1:n}) annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  Nus = pipeLocalHeatTransfer.Nu[:];

  connect(Expr_Res.y, pipeLocalHeatTransfer.Re) annotation (Line(points={{-39,20},{-20,20},{-20,6},{-12,6}}, color={0,0,127}));
  connect(Expr_Prs.y, pipeLocalHeatTransfer.Pr) annotation (Line(points={{-39,0},{-12,0}},           color={0,0,127}));
  connect(Expr_dByLs.y, pipeLocalHeatTransfer.dByL) annotation (Line(points={{-39,-20},{-20,-20},{-20,-6},{-12,-6}},            color={0,0,127}));
end NNHeatTransfer_onnx;
