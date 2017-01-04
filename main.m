prompt = 'Please enter the desired streams in the following way: [Stream Numbers;mCp; Inlet T;Outlet T]\newline\n';
inputStreams = input(prompt);

prompt2='please enter the desired minimum temperature difference\n';
inputDeltaTmin=input(prompt2);

HEnetwork(inputStreams, inputDeltaTmin);