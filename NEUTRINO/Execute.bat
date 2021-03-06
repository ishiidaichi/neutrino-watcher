@echo off
setlocal enabledelayedexpansion
cd /d %~dp0

: Project settings
set BASENAME=%1
set NumThreads=6

: musicXML_to_label.exe
set SUFFIX=musicxml

: NEUTRINO.exe
set ModelDir=%2
set StyleShift=0

: WORLD.exe
set PitchShift=1.0
set FormantShift=1.0


echo %date% %time% : start MusicXMLtoLabel
bin\musicXMLtoLabel.exe score\musicxml\%BASENAME%.%SUFFIX% score\label\full\%BASENAME%.lab score\label\mono\%BASENAME%.lab

echo %date% %time% : start NEUTRINO
bin\NEUTRINO.exe score\label\full\%BASENAME%.lab score\label\timing\%BASENAME%.lab output\%BASENAME%.f0 output\%BASENAME%.mgc output\%BASENAME%.bap model\%ModelDir%\ -n %NumThreads% -k %StyleShift% -m -t

echo %date% %time% : start WORLD
bin\WORLD.exe output\%BASENAME%.f0 output\%BASENAME%.mgc output\%BASENAME%.bap -f %PitchShift% -m %FormantShift% -o output\%BASENAME%_syn.wav -n %NumThreads% -t

echo %date% %time% : start NSF
bin\NSF_IO.exe score\label\full\%BASENAME%.lab score\label\timing\%BASENAME%.lab output\%BASENAME%.f0 output\%BASENAME%.mgc output\%BASENAME%.bap %MODELDIR% output\%BASENAME%_nsf.wav -t

echo %date% %time% : end
