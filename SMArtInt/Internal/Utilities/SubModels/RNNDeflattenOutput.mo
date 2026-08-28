within SMArtInt.Internal.Utilities.SubModels;
model RNNDeflattenOutput
  parameter Integer nOutputs=1 "Number of outputs";
  parameter Integer nHistoricElements=10 "Number of elements from sampling steps for each output";

  parameter Types.RNNFlatteningMethod flatteningMethod=Types.RNNFlatteningMethod.NewFirstInputSeq annotation (Evaluate=true);

  input Real[nHistoricElements*nOutputs] outputFlattenTensor annotation (Dialog);

  output Real[nOutputs,nHistoricElements] y annotation (Dialog);

equation
  for t in 1:nHistoricElements loop
    for i in 1:nOutputs loop
      if flatteningMethod == Types.RNNFlatteningMethod.NewFirstInputSeq then
        y[i, t] = outputFlattenTensor[(t - 1)*nOutputs + i];
      elseif flatteningMethod == Types.RNNFlatteningMethod.NewFirstTimeSeq then
        y[i, t] = outputFlattenTensor[(i - 1)*nHistoricElements + t];
      elseif flatteningMethod == Types.RNNFlatteningMethod.OldFIrstInputSeq then
        y[i, t] = outputFlattenTensor[(t - 1)*nOutputs + i];
      elseif flatteningMethod == Types.RNNFlatteningMethod.OldFirstTimeSeq then
        y[i, t] = outputFlattenTensor[(i - 1)*nHistoricElements + t];
      end if;
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end RNNDeflattenOutput;
