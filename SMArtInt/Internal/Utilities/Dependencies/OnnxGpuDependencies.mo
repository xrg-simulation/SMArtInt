within SMArtInt.Internal.Utilities.Dependencies;
model OnnxGpuDependencies

  function deps
  external "C" Deps_Dummy() annotation (Library={"SMArtInt","onnxruntime_providers_cuda","onnxruntime_providers_shared"}, LibraryDirectory="modelica://SMArtInt/Resources/Library");
  end deps;
equation
  when initial() then
    deps();
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
        Ellipse(
          extent={{100,100},{-100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,74},{86,-68}},
          textColor={124,124,124},
          textString=".dll /.so"),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,0},
          textString="%name")}));
end OnnxGpuDependencies;
