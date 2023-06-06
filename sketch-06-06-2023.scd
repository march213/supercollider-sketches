s.boot;
s.options.sampleRate = 24000;
s.reboot;

(
 ~fn = {
  var sig0, sig1;
  sig0 = PinkNoise.ar(mul: 0.2 ! 2);
  sig1 = SinOsc.ar(200, mul: 0.1 ! 2);
  sig0 + sig1;
}
)

x = ~fn.play;
x.free;

(
 ~fn = {
  arg amp = 0.2;
  var sig, mod;

  mod= SinOsc.kr(
    freq: 1/4,
    phase: 3pi/2, // shifts where the fist cycle begins
    mul: 0.5, // mul: is a value that is multiplied by every sample
    add: 0.5, // add: is a value that is added to every sample in the output signal
  );
  sig = PinkNoise.ar(amp ! 2);
  sig = sig * mod;
}
)

(
 ~fn = {
  arg amp = 0.2;
  var sig, mod;

  mod= SinOsc.kr(
    freq: 1/4,
    phase: 3pi/2,
  ).range(0, 1);
  sig = PinkNoise.ar(amp ! 2);
  sig = sig * mod;
}
)

(
 ~fn = {
  arg modwidth = 200;
  var sig, mod;
  mod = SinOsc.kr(freq: 5).bipolar(modwidth);
  sig = SinOsc.ar(300 + mod, mul: 0.1);
}
)

x = ~fn.play;
x.set(\modwidth, 100)
x.free;

x.release(5);

// Envelopes

(
~fn = {
  var sig, env;
  sig = SinOsc.ar(ExpRand(200, 1000), mul: 0.1) ! 2;
//  env = Line.kr(1, 0, 1, doneAction: 2); // just straign line
  env = XLine.kr(1, 0.001, 1, doneAction: 2); // exponential line
  sig = sig * env;
};
)

x = ~fn.play;

x.free;

s.plotTree;

(
e = Env.new(
  levels: [0, 1, 0.4, 0.6, 0],
  times: [0.5, 0.5, 2, 0.5],
  curve: [0, 0, 0, 0],
);
)

(
e = Env.new(
  levels: [0, 1, 0.4, 0.6, 0],
  times: [0.5, 0.5, 2, 0.5],
  curve: [3, 0, 0, 0],
);
)

(
e = Env.new(
  levels: [0, 1, 0.4, 0.6, 0],
  times: [0.5, 0.5, 2, 0.5],
  curve: [-3, 0, 0, 0],
);
)

e.plot;

// fixed duration envelope
(
~fn = {
  var sig, env;
  sig = SinOsc.ar(ExpRand(200, 1000), mul: 0.1) ! 2;
  env = EnvGen.kr(
    envelope: Env(
      levels: [0, 1, 0.4, 0.6, 0],
      times: [0.5, 0.5, 2, 0.5],
      curve: [0, 0, 0, 0],
    ),
    doneAction: 2,
  );

  sig = sig * env;
};
)

x = ~fn.play;

x.free;

// can be sustained indefinitely, until gate set to 0
(
~fn = {
  arg gate = 1;
  var sig, env;
  sig = SinOsc.ar(ExpRand(200, 1000), mul: 0.1) ! 2;
  env = EnvGen.kr(
    envelope: Env(
      levels: [0, 1, 0.3, 0],
      // attack, decay, release
      times: [0.05, 0.6, 2],
      curve: [-3, -1, -1],
      releaseNode: 2,
    ),
    gate: gate,
    doneAction: 2,
  );

  sig = sig * env;
};
)

x = ~fn.play;

x.set(\gate, 0);

x.free;


// fixed duration envelope
(
~fn = {
  // t_gate is a trigger control and helps to play the fixed duration envelope from the beginning as many times as i want
  // without it, i would have to set the gate value to 0 and then to 1, because it ends at 1;
  // works only with doneAction: 0, unless quick enough with the doneAction: 2
  arg t_gate = 1;
  var sig, env;
  sig = SinOsc.ar(ExpRand(200, 1000), mul: 0.1) ! 2;
  env = EnvGen.kr(
    envelope: Env(
      levels: [0, 1, 0],
      times: [0.02, 1],
      curve: [-2, -4],
    ),
    gate: t_gate,
    // when done action at 0, it will persist until freed
    doneAction: 0,
  );

  sig = sig * env;
};
)

x = ~fn.play;

x.set(\t_gate, 1);

x.free;


// Multichannel Expansion

s.options.numOutputBusChannels = 24; // kind of 24 speakers
s.reboot;
s.meter;

{ PinkNoise.ar(0.1) ! 4 }.play;

{ PinkNoise.ar([0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64]) }.play;

{ PinkNoise.ar(0.1 ! 2) }.play;

// example what to avoid to do when setting multichannel signals
// these example tries to expand multichannel signal that is already expanded
(
{
  var sig;
  sig = [PinkNoise.ar(0.1), SinOsc.ar(200, mul: 0.1)];
  sig = (sig ! 2).postln;
  0;
}.play;
)
























