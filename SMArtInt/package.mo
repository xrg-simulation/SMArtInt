within ;
package SMArtInt
  extends Modelica.Icons.Package;
  annotation (
    uses(Modelica(version="4.1.0")),
    preferredView="info",
    Documentation(info="<html>
<p><img src=\"modelica://SMArtInt/Resources/Images/SMArtInt-library.jpg\"/> </p>
<p><b><span style=\"font-size: 12pt; color: #ef9b13;\">SMArtInt Library</span></b></p>
<p>The SMArtInt library was developed within the German research projects PHyMoS and DIZPROVI and provides models for integration of different types of neural networks in Modelica.</p>
<p>This library is a product of XRG Simulation GmbH. It makes use of external, non-commercial models supplied by the Modelica Standard Library. In order to work correctly, please ensure that this library is always loaded with the Modelica Standard Library.</p>
<p>The extended commercial SMArtInt+ Library provides more valuable features such as generation of neural networks from Modelica models. Please refer to our product website or send a request using the XRG contact form for more information.</p>
<p><b><span style=\"font-size: 12pt; color: #ef9b13;\">Contact </span></b></p>
<h4>XRG Simulation GmbH</h4>
<h4>Harburger Schlossstrasse 6-12</h4>
<h4>21079 Hamburg</h4>
<h4>Germany</h4>
<p><b>SMArtInt Library</b> is a trademark of XRG Simulation GmbH. </p>
</html>"),
    Icon(graphics={Bitmap(extent={{-95,-95},{95,95}}, fileName="modelica://SMArtInt/Resources/Images/SMArtInt_Icon.png")}),
    conversion(from(
        version="0.5.2",
        to="1.0.0",
        script="modelica://SMArtInt/Resources/Scripts/ConvertFrom052_to_100.mos")),
    version="1.0.0");
end SMArtInt;
