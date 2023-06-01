s.reboot;
~notes = Array.newClear(128);
MIDIClient.init;
MIDIIn.connectAll;

(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(
		\tone,
		[
			\freq, nn.midicps,
			\amp, vel.linexp(1,127,0.02,0.5),
			\gate, 1,
		]
	);
});
)

(
MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	// [vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});
)

(
MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do{arg synth; synth.set(\bend, val.linlin(0,16383,-2,2))};
});
)

~bend = 8192;

(
SynthDef.new(\tone, {
	arg freq = 440, amp = 0.3, gate = 0, bend = 0;
	var sig, env;
	sig = LFTri.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	sig = sig * env * amp;
	SendReply.kr(env, '/oscout', [freq, amp]);
	Out.ar(0, sig);
}).add;
)

~defaultoscsc= NetAddr("localhost", 41234);

(
OSCdef(\sinesend, { |msg|
	var data = msg[3];
    data.postln;
    ~defaultoscsc.sendMsg("/supercollider", data);
}, '/oscout');
)


// Synth.new(\tone, [\freq, 700, \amp, 0.5]);

MIDIdef(\noteOnTest).disable;
MIDIdef(\noteOnTest).enable;
MIDIdef.freeAll;

