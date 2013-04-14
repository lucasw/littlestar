function tones

music =" CC GG AA G  FF EE DD C  GG FF EE D  GG FF EE D  CC GG AA G  FF EE DD C ";
music =" CC GG "; % AA G  FF EE DD C "; %  GG FF EE D  GG FF EE D  CC GG AA G  FF EE DD C ";
%music =" CC GG AA G"; %  FF EE DD C"; %GG FF EE D  GG FF EE D  CC GG AA G  FF EE DD C";
sus = [0.0 1.0 0.75 0.0 1.0 0.75 0.0 1.0 0.75 0.0 1.5 0.0];
%sus = [0.0 2.0 0.5 0.0 1.0 0.5 0.0 1.0 0.5 0.0 1.0 0.0]
sus = [sus, 0.0 0.75 1.0 0.0 0.75 1.0 0.0 1.0 0.75 0.0 1.5 0.0];
%sustains = [sus, sus, sus, sus, sus, sus];


% tbd build a lookup table of these
%[t,a] = chiptone(note2freq('A'),1,1);
%[t,b] = chiptone(note2freq('B'),1,1);
%[t,c] = chiptone(note2freq('C'),1,1);
%[t,d] = chiptone(note2freq('D'),1,1);
%[t,e] = chiptone(note2freq('E'),1,1);
%[t,f] = chiptone(note2freq('F'),1,1);
%[t,g] = chiptone(note2freq('G'),1,1);


quantize = 5;
ts = 1
samples = 8000.0
step_f = 3.0
tone_length = 2.0/step_f
step = round(samples/step_f)
music_s = length(music)
t = [0: 1/samples :  music_s / step_f + 1];
tlength = length(t)
tlen_s  = length(t) / samples
data = zeros(1,length(t));
base_freq = 2000

length(sus)

for i = [1:length(music)]
  note = music(i);
 
  i2 = round(mod(i-1, length(sus))+1);
  sustain = sus(i2);

  if (note != ' ')
    freq = note2freq(note, base_freq) + randn(1)*10;
    [tsnd, snd] = chiptone(freq, tone_length*sustain, quantize);
    %snd = snd.*chiptone(freq*10, tone_length*sustain, quantize);
    snd = snd/max(snd);
    endts = (ts + length(tsnd) - 1);
    %sprintf('%d %d %d', length(data), ts, endts);
    %sprintf('%c %d %d', note, note-'A', sustain)
    %sprintf('%d %d %g', i, i2, sustain)
    data(ts:endts) += snd;
  end

  ts = ts + round(step*sustain);
end

t = t(1:endts);
data = data(1:endts);
plot(t, data,'-.');
sound(data); %(1:36000));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [freq] = note2freq(note, f0)

note = toascii(toupper(note)) - toascii('A');
note = mod(note - 2, 7);
%f0 = 440;
a = 2.0^(1.0/12.0);
freq = f0 * a^note;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t,tn] = chiptone(freq, len_s, depth)
% generate a windowed low bit depth tone

t = [0:1/8000:len_s];
t = t + 0.15*randn(size(t))/8000;

y = sin(t*freq);

%window = ones(1,length(y)); %fliplr(sin(t.*t.*t*pi));
t2 = t/len_s;
window = fliplr(sin(t2.*t2.*t2.*t2 * pi));
%window = fliplr(sin(t2 * pi));
% quantize
y2 = round(y*depth) / depth .* window;


% tbd convolve with filter to round edges slightly.
fltr = [ones(1,3) 0.5 0.1 0.1 0.05];
%fltr2 = conv(fltr, ones(1,500));
%fltr2 = fltr2/sum(fltr2);

%fltr = [fltr, zeros(1,1000), fltr2];
fltr = fltr/sum(fltr);
y2 = conv(y2,fltr);
%y2 = y2(1:length(y));

y2 = y2 / max(y2);

y2 = y2;

tn = y2;



t = [1:length(y2)]/8000;

return




