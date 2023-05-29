s.reboot;

// first example
/*(
SynthDef(\modsinewithnoise, { arg freq=440, rate=10, out = [0,1];
    var sig=PinkNoise.ar(XLine.kr(0.1,0.9,100));
    var trig =Impulse.kr(rate);
    //SendReply is used here to send our UGEN values as messages via osc
    SendReply.kr(trig, '/modhydranoise', sig);
    Out.ar(out,[sig*trig,sig*trig])
}).add;
)

~defaultoscsc= NetAddr("localhost",41234);
~modulatewithNoise = Synth(\modsinewithnoise);
~modulatewithNoise.set(\rate,0.5, \freq,200);
(
OSCdef(\sender, { |msg|
    var data = msg[3]*100;
    data.postln;
    ~defaultoscsc.sendMsg("/a", data);
}, '/modhydranoise');
)

~modulatewithNoise.free;*/


~defaultoscsc= NetAddr("localhost", 41234);

(
OSCdef(\sinesend, { |msg|
    var data = msg[3]*100;
    data.postln;
    ~defaultoscsc.sendMsg("/a", data);
}, '/oscout');
)

(
SynthDef(\march213, { arg lfoRate = 2, out = 1, sineFreq = 200, sineAmpControl = 100;
	var trig, sig;
	trig = LFNoise2.kr(lfoRate);
	sig = SinOsc.ar(sineFreq, 0, SinOsc.kr(sineAmpControl));
	SendReply.kr(trig, '/oscout', sig);
	Out.ar(out, sig * trig);
}).add;
)

~myFirstThing = Synth(\march213);
~myFirstThing.set(\lfoRate,20, \sineFreq.exprand(200, 800));
~myFirstThing.free;