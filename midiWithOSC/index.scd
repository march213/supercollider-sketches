s.boot;

// global variables
~notes = Array.newClear(128);
~defaultOsc = NetAddr("localhost", 41234);

// MIDI setup
MIDIClient.init;
MIDIIn.connectAll;

// Debug
MIDIFunc.trace(true);
MIDIFunc.trace(false);

// Setup MIDI synth
(
SynthDef(\tone, {
  arg freq = 440, amp = 0.3, gate = 0, out = 0;
  var sig, env;
  sig = SinOsc.ar(freq, mul: amp ! 2);
  env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
  sig = sig * env;
  SendReply.kr(env, '/oscout', [freq, amp]);
  Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
  arg vel, nn, chan, src;
	~notes[nn] = Synth(\tone, [
    freq: nn.midicps,
    amp: vel.linexp(1, 127, 0.02, 1),
    gate: 1,
    out: 0,
  ]);
})
)

(
MIDIdef.noteOff(\off, {
  arg vel, num, chan, src;
  ~notes[num].set(\gate, 0);
  ~notes[num] = nil;
})
)

(
SynthDef(\noisewater, {
  arg noiseFreq = 1, res = 0.08, noiseTrig = 0.5, hFreq = 1900, pulseTrig = 1, pwm = 0.05, out = 0, atk = 0.1, rel = 0.3, rate = 10, chan = 0.1;
  var sig, env, trig, pulse;
  trig = Impulse.kr(rate);
  chan = LFTri.kr(0.1);
  sig = Pan2.ar(RLPF.ar(BrownNoise.ar(noiseFreq), hFreq, res), LFNoise2.kr(chan), 1);
  SendReply.kr(trig, '/noisea', noiseFreq);
  Out.ar(out, sig);
}).add;
)

~noiseMiddleLowSec = Synth(\noisewater, [
  freq: 0.005,
  hFreq: 120,
  res: 0.02,
  chan: 0.5
]);

(
OSCdef(\noisesend, {
  arg msg;
  var dataAmp;
  dataAmp = msg[3];
  ~defaultOsc.sendMsg("/noise", dataAmp);
}, '/noisea')
)

// Send MIDI stuff
(
OSCdef(\sinesendfreq, {
  arg msg;
  var dataFreq;
  dataFreq = msg[3];
  ~defaultOsc.sendMsg("/freq", dataFreq);
}, '/oscout')
)

(
OSCdef(\sinesendamp, {
  arg msg;
  var dataAmp;
  dataAmp= msg[4];
  ~defaultOsc.sendMsg("/amp", dataAmp);
}, '/oscout')
)

(
MIDIdef.cc(\control, {
  arg vel, num, chan, src;
  ~noiseMiddleLowSec.set(freq: vel.linlin(0, 127, 0, 0.08));
}, 3);
)























