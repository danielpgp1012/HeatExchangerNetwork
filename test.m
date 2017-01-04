% Test 1
testInputStreams=[1 0.5 330 160;2 3 220 50;3 1.5 220 105;4 2.5 205 320;5 1 95 150;6 2 40 205];
testDeltaTmin=10;
[NEA,NEB]=HEnetwork(testInputStreams, testDeltaTmin);
assert(NEA == 2, 'NEA expected to be 2');
assert(NEB == 6, 'NEB expected to be 6');