within SMArtInt.Internal.Utilities;
model RunInterferenceRNN

   // general parameters
  parameter Integer nInputs=1 "Number of scalar inputs";
  parameter Integer nOutputs=1 "Number of scalar outputs";
  parameter Modelica.Units.SI.Time samplePeriod=0.1 "sampling period/interval";
  parameter Integer nHistoricElements=10 "Number of elements from sampling steps for each input fed to the neural net";

  parameter Boolean continuous=false;
  parameter Boolean useClaRaDelay=true "Switch between available delay types: Clara and MSL";
  parameter SubModels.RNNFlatteningMethod flatteningMethod=SubModels.RNNFlatteningMethod.OldFIrstInputSeq;
  parameter Boolean returnSequences=false;

  parameter Integer batchSize=1;

  // instance of SMArtInt class
  parameter SMArtInt.Internal.SMArtIntClass smartint;

  // output dimension
  final parameter Integer yFlatDim=if returnSequences then batchSize*nOutputs*nHistoricElements else batchSize*nOutputs;

  Real y_flat[yFlatDim];

  Real y_sequences[if returnSequences then batchSize else 1,if returnSequences then nOutputs else 1,if returnSequences then nHistoricElements else 1] annotation (HideResult=true);

  // final flat tensor for the AI model (Batch * Window * Features)
  Real[batchSize*nHistoricElements*nInputs] finalFlatTensor;

  Modelica.Blocks.Interfaces.RealInput u[batchSize,nInputs] annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[batchSize,nOutputs] annotation (Placement(transformation(extent={{78,-20},{118,20}})));
  SubModels.RNNFlattenInput flattenedHistory[batchSize](
    each useClaRaDelay=useClaRaDelay,
    each nInputs=nInputs,
    each samplePeriod=samplePeriod,
    each nHistoricElements=nHistoricElements,
    each continuous=continuous,
    each flatteningMethod=flatteningMethod) annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  SubModels.RNNDeflattenOutput unflattenOutput[batchSize](
    each nOutputs=nOutputs,
    each nHistoricElements=nHistoricElements,
    each flatteningMethod=flatteningMethod) annotation (HideResult=not returnSequences, Placement(transformation(extent={{-10,-40},{10,-20}})));

  Modelica.Blocks.Interfaces.RealOutput ySequences[if returnSequences then batchSize else 1,if returnSequences then nOutputs else 1,if returnSequences then nHistoricElements else 1]=y_sequences if returnSequences annotation (Placement(transformation(extent={{80,-80},{120,-40}})));

equation

  y_flat = InterfaceFunctions.runInferenceFlatTensor(
    smartint,
    time,
    finalFlatTensor,
    yFlatDim);

  if returnSequences then
    for i in 1:batchSize loop
      flattenedHistory[i].u = u[i, :];
      finalFlatTensor[(i - 1)*(nHistoricElements*nInputs) + 1:i*(nHistoricElements*nInputs)] = flattenedHistory[i].inputFlattenTensor;

      unflattenOutput[i].outputFlattenTensor = y_flat[(i - 1)*nOutputs*nHistoricElements + 1:i*nOutputs*nHistoricElements];

      for j in 1:nOutputs loop
        unflattenOutput[i].y[j, end] = y[i, j];
        for k in 1:nHistoricElements loop
          y_sequences[i, j, k] = unflattenOutput[i].y[j, k];
        end for;
      end for;
    end for;

  else
    for i in 1:batchSize loop
      unflattenOutput[i].outputFlattenTensor = zeros(nOutputs*nHistoricElements);

      flattenedHistory[i].u = u[i, :];
      finalFlatTensor[(i - 1)*(nHistoricElements*nInputs) + 1:i*(nHistoricElements*nInputs)] = flattenedHistory[i].inputFlattenTensor;
      for j in 1:nOutputs loop
        y_flat[(i - 1)*nOutputs + j] = y[i, j];
      end for;
    end for;
    y_sequences = {{{0}}};
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Bitmap(extent={{-102,-100},{102,100}}, fileName="modelica://SMArtInt/Resources/Images/Icon_Inference.png")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end RunInterferenceRNN;
