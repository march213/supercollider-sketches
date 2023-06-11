s.reboot;
s.options.sampleRate = 48000;

(
{ SinOsc.ar(LFNoise0.kr(12, mul: 600, add: 1000), 0.3) ! 2 }.play;
)

(
play({
  RLPF.ar(
    Dust.ar([20, 60]),
    LFNoise1.ar(1/[3, 7], 1500, 1600),
    0.02
  )
});
)

(
play({
  var sines = 5, speed = 10;
  Mix.fill(sines,
    {
      arg x;
      Pan2.ar(
        SinOsc.ar(
          ExpRand(100, 1000),
          mul: max(0, LFNoise1.kr(speed) + Line.kr(1, -1, 30))
        ),
        rand(2, 1.0)
      )
    }
  );
})
)

dup('echo', 20);
round([3.141, 5.9265, 358.98, ], 0.01);
sort([23, 64, 3874, 1, 22, 98, 448]);
round(dup({exprand(1, 10)}, 100), 0.1);
sort(round(dup({exprand(1, 10)}, 100), 0.1));

(
play(
  {
    CombN.ar(
      SinOsc.ar(
        midicps(
          LFNoise1.ar(3, 24, LFSaw.ar([5, 5.123], 0, 3, 80))
        ),
        0,
        0.4
      ),
      1,
      0.3,
      2
    )
  }
)
)


// Multichannel Expansion

{Blip.ar(25, LFNoise0.kr(5, 12, 14), 0.3)}.play; // single channel
{Blip.ar(25, LFNoise0.kr([5, 10], 12, 14), 0.3)}.play; // stereo
{Blip.ar(25, LFNoise0.kr([5, 10, 2, 25], 12, 14), 0.3)}.play; // quad
{Blip.ar(25, LFNoise0.kr([5, 4, 7, 9, 5, 1, 9, 2], 12, 14), 0.3)}.play; // 8 channel

{PMOsc.ar(440, MouseY.kr(1, 550), MouseX.kr(1, 15)) ! 2}.play;

(
{
  Blip.ar(
    TRand.kr( // frequency or VCO
      100, 1000, // range
      Impulse.kr(Line.kr(1, 20, 60)) // trigger
    ),
    TRand.kr( // number of harmonics or VCF
      1, 10, // range
      Impulse.kr(Line.kr(1, 20, 60)) // trigger
    ),
    Linen.kr( // mul, or amplitude, VCA
      Impulse.kr(Line.kr(1, 20, 60)), // trigger
      0, // attack
      0.5, // sustain level
      1 / Line.kr(1, 20 , 60) // trigger
    )
  ) ! 2
}.play;
)





































































