s.options.sampleRate = 24000;
s.boot;

f={SinOsc.ar(200,0,SinOsc.kr(50))}.play;


x={Blip.ar(Blip.kr(4, 5, 500, 60), 59, 0.1)}.play;
x.free;

(
y={
	arg frequency = 200, amplitude = 0.125;
	var signal;
	signal = SinOsc.ar(frequency, amplitude);
}.play;
)

y.set(\frequency, 400);
y.free;


{SinOsc.ar(200, mul:0.125)}.play;

{SinOsc.ar(MouseX.kr(200,600), mul:0.125)}.play;

{SinOsc.ar(MouseX.kr(200,600), mul:MouseY.kr(0.125,0.5))}.play;

s.scope;

(
g={
	arg rate = 2;
	var signal,frequency;
	frequency = LFNoise0.kr(rate).exprange(200, 800);
	signal = SinOsc.ar(frequency, 0, SinOsc.kr(50));
}.play;
)
g.set(\rate, exprand(4,8));
// fade out time in seconds
g.release(5);

{ LFNoise0.ar(XLine.kr(1000, 10000, 10), 0.25) }.play;



(
q={
	arg rate = 2;
	var signal,frequency;
	frequency = LFNoise0.kr(rate).exprange(2, 10);
	signal = Blip.ar(200, Line.kr(1,100,30,frequency / 20), 0.2);
}.play
)
q.set(\rate, exprand(4,8));
