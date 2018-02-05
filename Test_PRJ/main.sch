<Qucs Schematic 0.0.18>
<Properties>
  <View=0,70,1059,863,0.909091,0,0>
  <Grid=10,10,1>
  <DataSet=main.dat>
  <DataDisplay=main.dpl>
  <OpenDisplay=1>
  <Script=main.m>
  <RunScript=0>
  <showFrame=0>
  <FrameText0=Title>
  <FrameText1=Drawn By:>
  <FrameText2=Date:>
  <FrameText3=Revision:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <R R1 1 560 310 15 -26 0 1 "25 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "european" 0>
  <C C1 1 680 310 17 -26 0 1 "2 pF" 1 "" 0 "neutral" 0>
  <GND * 1 620 370 0 0 0 0>
  <TLIN Line1 1 390 240 -26 20 0 0 "50 Ohm" 1 "30 mm" 1 "0 dB" 0 "26.85" 0>
  <TLIN Line2 1 410 650 -26 20 0 0 "50 Ohm" 1 "30 mm" 1 "0.5 dB" 0 "26.85" 0>
  <TLIN Line3 1 530 650 -26 20 0 0 "50 Ohm" 1 "30 mm" 1 "0.5 dB" 0 "26.85" 0>
  <GND * 1 230 740 0 0 0 0>
  <Pac P1 1 230 710 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 1 610 730 0 0 0 0>
  <Pac P2 1 610 700 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <.SP SP1 1 880 660 0 76 0 0 "lin" 1 "0.1 GHz" 1 "5 GHz" 1 "99" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
</Components>
<Wires>
  <560 240 560 280 "" 0 0 0 "">
  <560 240 680 240 "" 0 0 0 "">
  <680 240 680 280 "" 0 0 0 "">
  <560 340 560 370 "" 0 0 0 "">
  <560 370 620 370 "" 0 0 0 "">
  <680 340 680 370 "" 0 0 0 "">
  <620 370 680 370 "" 0 0 0 "">
  <420 240 560 240 "" 0 0 0 "">
  <440 650 500 650 "" 0 0 0 "">
  <230 650 380 650 "" 0 0 0 "">
  <230 650 230 680 "" 0 0 0 "">
  <560 650 610 650 "" 0 0 0 "">
  <610 650 610 670 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
  <Line 520 130 0 310 #00aa00 5 2>
  <Text 460 90 18 #000000 0 "Plane #2">
  <Arrow 690 480 -20 -80 20 8 #000000 5 1 1>
  <Line 520 500 0 -40 #000000 5 1>
  <Arrow 520 460 40 0 20 8 #000000 5 1 1>
  <Line 520 560 0 -30 #000000 4 1>
  <Line 520 530 20 0 #000000 4 1>
  <Line 540 530 0 10 #000000 4 1>
  <Text 530 550 12 #000000 0 "2">
  <Text 620 500 18 #000000 0 "DUT">
  <Line 300 140 0 310 #aa0000 5 2>
  <Line 300 520 0 -40 #000000 5 1>
  <Arrow 300 480 40 0 20 8 #000000 5 1 1>
  <Line 290 570 0 -30 #000000 4 1>
  <Line 290 540 20 0 #000000 4 1>
  <Line 310 540 0 10 #000000 4 1>
  <Text 300 560 12 #000000 0 "1">
  <Text 240 100 18 #000000 0 "Plane #1">
</Paintings>
