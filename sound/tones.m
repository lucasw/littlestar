function tones


music ="CC GG AA G  FF EE DD C  GG FF EE D  GG FF EE D  CC GG AA G  FF EE DD C";
%music ="CC GG AA G" %  FF EE DD C  GG FF EE D  GG FF EE D  CC GG AA G  FF EE DD C";

% tbd build a lookup table of these
[t,a] = chiptone(note2freq('A'),1,1);
[t,b] = chiptone(note2freq('B'),1,1);
[t,c] = chiptone(note2freq('C'),1,1);
[t,d] = chiptone(note2freq('D'),1,1);
[t,e] = chiptone(note2freq('E'),1,1);
[t,f] = chiptone(note2freq('F'),1,1);
[t,g] = chiptone(note2freq('G'),1,1);


ts = 1
samples = 8000.0
step_f = 5
step = round(samples/step_f)
music_s = length(music)
t = [0: 1/samples : (music_s ) / step_f + 2];
tlength = length(t)
tlen_s  = length(t)/samples
data = zeros(1,length(t));

for i = [1:length(music)]
  note = music(i);
 
  if (note != ' ')
    freq = note2freq(note);
    [tsnd, snd] = chiptone(freq,2.0/step_f,1);
    endts = (ts + length(tsnd) - 1);
    sprintf('%d %d %d', length(data), ts, endts)
    data(ts:endts) += snd*0.6;
  end

  ts = ts + step;
end

plot(t, data);
sound(data);

function [freq] = note2freq(note)

note = toascii(toupper(note)) - toascii('A');
f0 = 440;
a = 2^(1/12);
freq = f0 * a^note;

function [t,tn] = chiptone(freq, len_s, depth)
% generate a windowed low bit depth tone

t = [0:1/8000:len_s];

y = sin(t*freq);

window = fliplr(sin(t.*t.*t*pi));
% quantize
y2 = round(y*depth)/depth .* window;

tn = y2;

return

%endfunction


%b = sin(t.*t*1000);
%b2 = (floor(b*4)/4);

%sound(b2);
