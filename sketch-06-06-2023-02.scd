s.boot;
s.options.sampleRate = 24000;
s.reboot;
s.quit;

s.sampleRate;
s.options.blockSize;

// number of blocks per second
s.sampleRate / s.options.blockSize;

// audio rate, samples at the sample rate
// 24000 samples per second for my case when airpods are connected
// higher resolution
// things that you want to listen to
SinOsc.ar();

// control rate, 1 sample per block
// 375 samples in my case
// lower resolution
// LFO, envelopes, etc - good candidates for control rate
SinOsc.kr();

(
{
  [
    SinOsc.ar(120),
    SinOsc.kr(120)
  ];
}.plot;
)

(
{
  SinOsc.ar(freq: 300, phase: 0, mul: 0.2, add: 0)
}.play;
)

(
{
  SinOsc.ar(300, 0, 0.2, 0)
}.play;
)

(
{
  SinOsc.ar(freq: 300, mul: 0.1)
}.play;
)

(
{
  SinOsc.ar(freq: 260) * 0.1 ! 2;
}.play;
)

{ SinOsc.ar(freq: 300) * 0.1 ! 2 }.play
{ LFTri.ar(freq: 300) * 0.1 ! 2 }.play
{ LFTri.ar(freq: 300) * 0.1 ! 2 }.plot
{ LFTri.ar(freq: 300).poll * 0.1 ! 2 }.play;
{ Saw.ar(freq: 300) * 0.1 ! 2 }.play
{ Saw.ar(freq: 300) * 0.1 ! 2 }.plot
{ Pulse.ar(freq: 300) * 0.1 ! 2 }.play
{ PinkNoise.ar(0.1) ! 2 }.play;

{ LFSaw.ar(freq: XLine.kr(20, 20000, 10).poll) * 0.1 ! 2 }.play;

{ Saw.ar(freq: XLine.kr(20, 20000, 10).poll) * 0.1 ! 2 }.play;



(
~fn = {
  arg freq = 160, freqtime = 2;
  var sig;
  // freq = freq.lag(freqtime);
  freq = Lag.kr(freq, freqtime);
  sig = SinOsc.ar(freq: freq).poll;
  sig = sig * 0.1;
  sig = sig ! 2;
};
)

x = ~fn.play;

x.set(\freq, exprand(200, 500), \freqtime, 5);

x.free;

x.release(3);



(
~fn = {
  arg amp = 0.2;
  var sig, mod;
  mod = SinOsc.kr(freq: 1/4, phase: 0, mul: 0.5, add: 0.5);
  sig = PinkNoise.ar(amp ! 2);
  sig = sig * mod;
};
)

{SinOsc.ar(freq: 440, phase: 0, mul: 0.5, add: 0)}.plot;
{SinOsc.ar(freq: 440, phase: 0, mul: 0.5, add: 0.5)}.plot;
{SinOsc.ar(freq: 440, phase: 3pi/2, mul: 0.5, add: 0.5)}.plot;

x = ~fn.play;

(
~fn = {
  arg amp = 0.2;
  var sig, mod;
  mod = SinOsc.kr(freq: 1/4, phase: 3pi/2, mul: 0.5, add: 0.5);
  sig = PinkNoise.ar(amp ! 2);
  sig = sig * mod;
  sig = Limiter.ar(sig).poll;
};
)

x = ~fn.play;
x.release(3);






































