; None verbose drone synth for custom cosmo
; Based on knob-test.csd by Bernt Isak Wærstad
; https://github.com/cosmoproject/cosmo-dsp
;
; Live performance version v0.6b
; Version info:
; Switch 6 reverse hw operation
; Switch 3 through 7 unassigned 
; Changelog:
; 0.5b added unused buttons
; 0.1b cleaned up code
;
; .:FiEND:.
<CsoundSynthesizer>
<CsOptions>
-odac:hw:1,0 -iadc:hw:1 -d -+rtaudio=ALSA -b128 -B1024
</CsOptions>
<CsInstruments>
sr      = 44100
ksmps   = 32
0dbfs   = 1
nchnls  = 2

instr 1

        #include "includes/adc_channels.inc"
        #include "includes/gpio_channels.inc"

; init buttons and variables

        kbutt0 init 0
        kbutt1 init 0
        kbutt2 init 0
;       kbutt3 init 0
;       kbutt4 init 0
;       kbutt5 init 0
;       kbutt6 init 0
;       kbutt7 init 0
        koct init 1
        ksteep = 150

;red left momentary button (switch)
        if (gkswitch0 == 1 && kbutt0 == 0) then
                kwub = 1
/* code example for verbose output
                Sswitch0 sprintfk "Header: %f", gkswitch0
                        puts Sswitch0, gkswitch0+1
*/
                kbutt0 = 1
        elseif (gkswitch0 == 0 && kbutt0 == 1) then
                kwub = 0.5
                kbutt0 = 0
        endif
;red right momentary button (switch)
        if (gkswitch1 == 1 && kbutt1 == 0) then
                kreso = 0.7
                kbutt1 = 1
        elseif (gkswitch1 == 0 && kbutt1 == 1) then
                kreso = 1.1
                kbutt1 = 0
        endif
;switch 1
        if (gkswitch2 == 1 && kbutt2 == 0) then
                koct = 1
                kbutt2 = 1
        elseif (gkswitch2 == 0 && kbutt2 == 1) then
                koct = 0.5
                kbutt2 = 0
        endif
;switch 2
/*        if (gkswitch3 == 1 && kbutt3 == 0) then
                kbutvar3 = 1
                kbutt3 = 1
        elseif (gkswitch3 == 0 && kbutt3 == 1) then
                kbutvar3 = 0
                kbutt3 = 0
        endif
*/
;switch 3
/*        if (gkswitch4 == 1 && kbutt4 == 0) then
                kbutvar4 = 1
                kbutt4 = 1
        elseif (gkswitch4 == 0 && kbutt4 == 1) then
                kbutvar4 = 0
                kbutt4 = 0
        endif
*/
;switch 4
/*        if (gkswitch5 == 1 && kbutt5 == 0) then
                kbutvar5 = 1
                kbutt5 = 1
        elseif (gkswitch5 == 0 && kbutt5 == 1) then
                kbutvar5 = 0
                kbutt5 = 0
        endif
*/
/*
; switch 5

        if (gkswitch6 == 1 && kbutt6 == 0) then
                kbutvar6 = 0
                kbutt6 = 1
        elseif (gkswitch6 == 0 && kbutt6 == 1) then
                kbytvar6 = 1
                kbutt6 = 0
        endif
*/
;switch 6
/*        if (gkswitch7 == 1 && kbutt5 == 0) then
                kbutvar7 = 1
                kbutt7 = 1
        elseif (gkswitch7 == 0 && kbutt5 == 1) then
                kbutvar7 = 0
                kbutt7 = 0
        endif
*/

; pot 1.1 FM
        kfmidx scale gkpot1, 0, 8
        kfmidx portk kfmidx, 0.1
; pot 1.2 FM2
        gkpot1 expcurve gkpot2, 30
        kfmfreq scale gkpot2, 0.1, 500
        kfmfreq portk kfmfreq, 0.1
; pot 1.3 LPF18
        gkpot2 expcurve gkpot4, 30
        klpfreq scale gkpot4, 5000, 200
        klpfreq portk klpfreq, 0.1
; pot 1.4 distortion
        gkrevpot6 scale gkpot6, 0, 2
        kdist expcurve gkrevpot6, 30
; oscillator pot 2.1
        koscvoll1 scale gkpot0, 0, 1
        koscvol1 expcurve koscvoll1, ksteep
; oscillator pot 2.2
        koscvoll2 scale gkpot3, 0, 1
        koscvol2 expcurve koscvoll2, ksteep
; oscillator pot 2.3
        koscvoll3 scale gkpot5, 0, 1
        koscvol3 expcurve koscvoll3, ksteep
; pot 2.4 finetune
        ktune scale gkpot7, -60, 60
; FM and wub
        afm poscil kfmidx*kfmfreq, kfmfreq*kwub
; 3x2 oscillators and fm + octaver
        a1 poscil koscvol1, (ktune + 111 + afm)*koct
        a2 poscil koscvol2, (ktune + 222 + afm)*koct
        a3 poscil koscvol3, (ktune + 333 + afm)*koct
        a4 poscil koscvol1, (ktune + 444 + afm)*koct
        a5 poscil koscvol2, (ktune + 555 + afm)*koct
        a6 poscil koscvol3, (ktune + 666 + afm)*koct
; mux
        asynth = a1 + a2 + a3 + a4 + a5 + a6
; lpf18 asig, kfco, kres, kdist [, iskip]
        asynth lpf18 asynth, klpfreq, kreso, kdist

        outs asynth, asynth
endin


</CsInstruments>
<CsScore>
i1 0 86400
</CsScore>
</CsoundSynthesizer>
