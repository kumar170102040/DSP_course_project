%Reading the First Audio Input (Original Audio)
[data1,fs] = audioread('3.ogg');

%Reading the Second Audio Input (Mis-matching Audio)
[data2,fs] = audioread('4.ogg');

%These audios are not of single channels so we will take only one column
%for calculating the cross correlation

x=data1(:,1);
y=data2(:,1);

%We will now take a section of the original audio whose cross correlation
%should have a sharp spike. We have taken the row size almost equal to the
%row-size of the mis-matching audio

z=data1(100000:200000, 1); %section of the original audio

%We will now plot the cross-correlation of both the combinations
figure(1)
plot(xcorr(x,y))
figure(2)
plot(xcorr(x,z))

%We will see that there is no spike in the cross-correlation of
%mis-matching audio and the original audio while there is a spike in the
%plot for the original audio and section of the original audio.