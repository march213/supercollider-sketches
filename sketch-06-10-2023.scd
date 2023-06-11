s.boot;

(
~fn = {
  arg gate = 1;
  var sig, env;
  sig = SinOsc.ar(ExpRand(200, 1000), mul: 0.2) ! 2;
  env = EnvGen.kr(
    Env(
      [0, 1, 0.3, 0],
      [0.02, 0.3, 1],
      [-2, -4, -4],
      2
    ).plot,
    gate,
    doneAction: 2
  );
  sig = sig * env;
}
)

x = ~fn.play;

x.set(\gate, 0);


(
SynthDef(\tone, {
  arg gate = 1, freq = 400, amp = 0.2, out = 0;
  var sig, env;
  sig = SinOsc.ar(freq) ! 2;
  env = EnvGen.kr(
    Env(
      [0, 1, 0.3, 0],
      [0.02, 0.3, 1],
      [-2, -4, -4],
      2
    ),
    gate,
    doneAction: 2
  );
  sig = sig * env;
  sig = sig * amp;
  Out.ar(out, sig);
}).add;
)

(
SynthDef(\tone, {
  var sig, env;
  sig = SinOsc.ar(\freq.kr(400)) ! 2;
  env = EnvGen.kr(
    Env(
      [0, 1, 0.3, 0],
      [0.02, 0.3, 1],
      [-2, -4, -4],
      2
    ),
    gate: \gate.kr(1),
    doneAction: 2
  );
  sig = sig * env;
  sig = sig * \amp.kr(0.2);
  Out.ar(\out.kr(0), sig);
}).add;
)

(
SynthDef(\tone, {
  var sig, env;
  sig = SinOsc.ar(\freq.kr(400)) ! 2;
  env = EnvGen.kr(
    Env(
      [0, 1, 0.3, 0],
      [0.02, 0.3, 1],
      [-2, -4, -4],
      2
    ),
    gate: \gate.kr(1),
    doneAction: 2
  );
  sig = sig * env;
  sig = sig * \amp.kr(0.2);
  Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\tone, [gate: 1, freq: 62.midicps, amp: 0.5]);
x.set(\freq, 70.midicps);
x.set(\freq, 52.midicps)
x.set(\gate, 0);


///////////////////////////

// Buffer - a block of memory, is allocated, can store samples

b = Buffer.read(s, "/Users/evgeniyamolodetskaya/personal/supercollider-sketches/sample2.aiff");
b.play;
b.duration;
b.query;
b.free;
Buffer.freeAll;

(
SynthDef(\play, {
  var sig, env;

  sig = PlayBuf.ar(
    numChannels: 2,
    bufnum: \buf.kr(0),
    // helps to normalize sample rate between files one and server
    rate: BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
    // frame where to begin
    startPos: \spos.kr(0),
    loop: 1,
//    doneAction: 2,
  );
  
  env = EnvGen.kr(
    Env(
      [0, 1, 0],
      [0.02, 3],
      [-2, -4],
    ),
    gate: \gate.kr(1),
    doneAction: 2
  );

  sig = sig * env;
  sig = sig * \amp.kr(0.5);
  Out.ar(\out.kr(0), sig);
}).add;
)

// my sampleRate is 48000
// buffer sample rate is 44100
// so when Synth is playing pitch is different
Synth(\play, [buf: b.bufnum, rate: 0.7]);
(
Synth(\play, [
  buf: b.bufnum,
  rate: -5.midiratio,
  amp: 0.8,
  spos: b.sampleRate * 4
]);
)
s.plotTree;




























