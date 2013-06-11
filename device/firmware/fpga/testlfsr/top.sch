VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3e"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL GCLK11
        SIGNAL XLXN_18
        SIGNAL ADC_SCLK
        SIGNAL ADC_SEN
        SIGNAL ADC_SDATA
        SIGNAL ADC_CLKP
        SIGNAL XLXN_88
        SIGNAL SLRD
        SIGNAL SLOE
        SIGNAL FIFOADR1
        SIGNAL FIFOADR0
        SIGNAL ADC_RESET
        SIGNAL ADC_CLKOUT
        SIGNAL SLWR
        SIGNAL PB(0:15)
        SIGNAL PB(0)
        SIGNAL PB(1)
        SIGNAL PB(2)
        SIGNAL PB(3)
        SIGNAL PB(4)
        SIGNAL PB(5)
        SIGNAL PB(6)
        SIGNAL PB(7)
        SIGNAL PB(8)
        SIGNAL PB(9)
        SIGNAL PB(10)
        SIGNAL PB(11)
        SIGNAL PB(12)
        SIGNAL PB(13)
        SIGNAL PB(14)
        SIGNAL PB(15)
        SIGNAL XLXN_151
        PORT Input GCLK11
        PORT Output ADC_SCLK
        PORT Output ADC_SEN
        PORT Output ADC_SDATA
        PORT Output ADC_CLKP
        PORT Output SLRD
        PORT Output SLOE
        PORT Output FIFOADR1
        PORT Output FIFOADR0
        PORT Output ADC_RESET
        PORT Input ADC_CLKOUT
        PORT Output SLWR
        PORT Output PB(0)
        PORT Output PB(1)
        PORT Output PB(2)
        PORT Output PB(3)
        PORT Output PB(4)
        PORT Output PB(5)
        PORT Output PB(6)
        PORT Output PB(7)
        PORT Output PB(8)
        PORT Output PB(9)
        PORT Output PB(10)
        PORT Output PB(11)
        PORT Output PB(12)
        PORT Output PB(13)
        PORT Output PB(14)
        PORT Output PB(15)
        BEGIN BLOCKDEF title
            TIMESTAMP 2000 1 1 10 10 10
            LINE N -764 -288 -796 -256 
            LINE N -732 -256 -764 -288 
            LINE N -776 -256 -732 -256 
            LINE N -788 -264 -776 -256 
            LINE N -840 -256 -796 -256 
            LINE N -804 -256 -836 -288 
            LINE N -800 -256 -832 -288 
            LINE N -796 -256 -828 -288 
            LINE N -832 -288 -800 -320 
            LINE N -828 -288 -796 -320 
            LINE N -828 -352 -796 -384 
            LINE N -840 -384 -796 -384 
            LINE N -796 -384 -764 -352 
            LINE N -800 -320 -832 -352 
            LINE N -796 -320 -828 -352 
            LINE N -804 -320 -836 -352 
            LINE N -832 -352 -800 -384 
            LINE N -836 -352 -804 -384 
            LINE N -872 -352 -840 -384 
            LINE N -868 -352 -836 -384 
            LINE N -732 -384 -764 -352 
            LINE N -776 -384 -732 -384 
            LINE N -788 -376 -776 -384 
            LINE N -764 -356 -736 -384 
            LINE N -768 -360 -740 -384 
            LINE N -768 -356 -740 -384 
            LINE N -772 -360 -744 -384 
            LINE N -772 -360 -748 -384 
            LINE N -772 -360 -752 -384 
            LINE N -840 -352 -808 -384 
            LINE N -844 -352 -812 -384 
            LINE N -848 -352 -816 -384 
            LINE N -852 -352 -820 -384 
            LINE N -816 -256 -848 -288 
            LINE N -820 -256 -852 -288 
            LINE N -872 -352 -828 -352 
            LINE N -836 -320 -868 -352 
            LINE N -832 -320 -864 -352 
            LINE N -828 -320 -860 -352 
            LINE N -824 -320 -856 -352 
            LINE N -872 -288 -840 -320 
            LINE N -872 -288 -828 -288 
            LINE N -860 -352 -828 -384 
            LINE N -864 -352 -832 -384 
            LINE N -856 -352 -824 -384 
            LINE N -856 -288 -824 -320 
            LINE N -852 -288 -820 -320 
            LINE N -848 -288 -816 -320 
            LINE N -844 -288 -812 -320 
            LINE N -840 -288 -808 -320 
            LINE N -836 -288 -804 -320 
            LINE N -868 -288 -836 -320 
            LINE N -864 -288 -832 -320 
            LINE N -860 -288 -828 -320 
            LINE N -840 -320 -872 -352 
            LINE N -820 -320 -852 -352 
            LINE N -816 -320 -848 -352 
            LINE N -812 -320 -844 -352 
            LINE N -808 -320 -840 -352 
            LINE N -808 -256 -840 -288 
            LINE N -812 -256 -844 -288 
            LINE N -836 -256 -868 -288 
            LINE N -840 -256 -872 -288 
            LINE N -824 -256 -856 -288 
            LINE N -828 -256 -860 -288 
            LINE N -832 -256 -864 -288 
            LINE N -772 -364 -756 -384 
            LINE N -776 -364 -756 -384 
            LINE N -776 -368 -760 -384 
            LINE N -780 -368 -764 -384 
            LINE N -780 -372 -768 -384 
            LINE N -784 -372 -772 -384 
            LINE N -784 -376 -772 -384 
            LINE N -612 -272 -612 -368 
            LINE N -616 -272 -616 -368 
            LINE N -620 -272 -620 -368 
            LINE N -564 -276 -612 -276 
            LINE N -456 -272 -456 -368 
            LINE N -460 -272 -460 -368 
            LINE N -640 -272 -640 -368 
            LINE N -392 -272 -444 -368 
            LINE N -392 -368 -444 -272 
            LINE N -660 -272 -712 -368 
            LINE N -660 -368 -716 -272 
            LINE N -544 -272 -544 -368 
            LINE N -644 -272 -644 -368 
            LINE N -636 -272 -636 -368 
            LINE N -656 -272 -708 -368 
            LINE N -468 -272 -520 -368 
            LINE N -660 -272 -716 -368 
            LINE N -664 -272 -720 -368 
            LINE N -524 -272 -524 -368 
            LINE N -528 -272 -528 -368 
            LINE N -632 -272 -632 -368 
            LINE N -468 -272 -524 -368 
            LINE N -540 -272 -540 -368 
            LINE N -464 -272 -516 -368 
            LINE N -460 -272 -516 -368 
            LINE N -548 -272 -548 -368 
            LINE N -388 -272 -440 -368 
            LINE N -564 -272 -612 -272 
            LINE N -664 -368 -720 -272 
            LINE N -772 -256 -784 -264 
            LINE N -784 -268 -772 -256 
            LINE N -768 -256 -780 -268 
            LINE N -780 -272 -764 -256 
            LINE N -760 -256 -776 -272 
            LINE N -776 -276 -756 -256 
            LINE N -756 -256 -772 -276 
            LINE N -772 -280 -752 -256 
            LINE N -748 -256 -772 -280 
            LINE N -772 -280 -744 -256 
            LINE N -740 -256 -768 -280 
            LINE N -768 -284 -740 -256 
            LINE N -736 -256 -764 -284 
            LINE N -388 -272 -436 -368 
            LINE N -384 -272 -436 -368 
            LINE N -388 -368 -440 -272 
            LINE N -112 -176 -1140 -176 
            BEGIN LINE W -1136 -416 -1136 -212 
            END LINE
            BEGIN LINE W -80 -416 -80 -220 
            END LINE
            BEGIN LINE W -1136 -416 -80 -416 
            END LINE
            LINE N -1136 -128 -80 -128 
            LINE N -1132 -220 -80 -220 
            BEGIN LINE W -80 -80 -352 -80 
            END LINE
            BEGIN LINE W -1136 -80 -352 -80 
            END LINE
            BEGIN LINE W -1136 -224 -1136 -80 
            END LINE
            BEGIN LINE W -144 -80 -152 -80 
            END LINE
            BEGIN LINE W -80 -224 -80 -80 
            END LINE
            LINE N -112 -176 -80 -176 
            LINE N -176 -128 -144 -128 
            LINE N -296 -128 -296 -80 
        END BLOCKDEF
        BEGIN BLOCKDEF adcapi
            TIMESTAMP 2007 6 2 7 8 42
            RECTANGLE N 64 -192 320 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -32 0 -32 
            LINE N 320 -160 384 -160 
            LINE N 320 -96 384 -96 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF adcclk
            TIMESTAMP 2007 6 2 7 22 45
            RECTANGLE N 64 -128 400 0 
            LINE N 64 -96 0 -96 
            LINE N 400 -96 464 -96 
            LINE N 400 -32 464 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF gnd
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 64 -64 64 -96 
            LINE N 76 -48 52 -48 
            LINE N 68 -32 60 -32 
            LINE N 88 -64 40 -64 
            LINE N 64 -64 64 -80 
            LINE N 64 -128 64 -96 
        END BLOCKDEF
        BEGIN BLOCKDEF vcc
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 64 -32 64 -64 
            LINE N 64 0 64 -32 
            LINE N 96 -64 32 -64 
        END BLOCKDEF
        BEGIN BLOCKDEF lfsr
            TIMESTAMP 2007 9 3 6 25 12
            RECTANGLE N 64 -128 320 0 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 320 -96 384 -96 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCK XLXI_1 title
            ATTR TitleFieldText " SoRAD Data Generator for Bandwidth Test"
            ATTR NameFieldText " Chris Hiszpanski"
        END BLOCK
        BEGIN BLOCK XLXI_5 adcclk
            PIN CLKIN_IN GCLK11
            PIN CLKFX_OUT ADC_CLKP
            PIN CLKIN_IBUFG_OUT XLXN_18
        END BLOCK
        BEGIN BLOCK XLXI_2 adcapi
            PIN reset XLXN_88
            PIN clk XLXN_18
            PIN sclk ADC_SCLK
            PIN sen ADC_SEN
            PIN sdata ADC_SDATA
        END BLOCK
        BEGIN BLOCK XLXI_47 gnd
            PIN G XLXN_88
        END BLOCK
        BEGIN BLOCK XLXI_41 vcc
            PIN P SLRD
        END BLOCK
        BEGIN BLOCK XLXI_42 vcc
            PIN P SLOE
        END BLOCK
        BEGIN BLOCK XLXI_43 vcc
            PIN P FIFOADR1
        END BLOCK
        BEGIN BLOCK XLXI_48 gnd
            PIN G ADC_RESET
        END BLOCK
        BEGIN BLOCK XLXI_44 gnd
            PIN G FIFOADR0
        END BLOCK
        BEGIN BLOCK XLXI_65 lfsr
            PIN clk ADC_CLKOUT
            PIN reset XLXN_151
            PIN gate SLWR
            PIN q(15:0) PB(0:15)
        END BLOCK
        BEGIN BLOCK XLXI_77 gnd
            PIN G XLXN_151
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE XLXI_1 3600 2800 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_5 240 240 R0
        END INSTANCE
        BEGIN BRANCH GCLK11
            WIRE 208 144 240 144
        END BRANCH
        IOMARKER 208 144 GCLK11 R180 28
        BEGIN INSTANCE XLXI_2 832 464 R0
        END INSTANCE
        BEGIN BRANCH ADC_SCLK
            WIRE 1216 304 1248 304
        END BRANCH
        BEGIN BRANCH ADC_SEN
            WIRE 1216 368 1248 368
        END BRANCH
        BEGIN BRANCH ADC_SDATA
            WIRE 1216 432 1248 432
        END BRANCH
        IOMARKER 1248 304 ADC_SCLK R0 28
        IOMARKER 1248 368 ADC_SEN R0 28
        IOMARKER 1248 432 ADC_SDATA R0 28
        BEGIN BRANCH XLXN_18
            WIRE 704 208 720 208
            WIRE 720 208 720 432
            WIRE 720 432 832 432
        END BRANCH
        BEGIN BRANCH ADC_CLKP
            WIRE 704 144 736 144
        END BRANCH
        IOMARKER 736 144 ADC_CLKP R0 28
        INSTANCE XLXI_47 560 480 R0
        BEGIN BRANCH XLXN_88
            WIRE 624 304 832 304
            WIRE 624 304 624 352
        END BRANCH
        BEGIN BRANCH SLRD
            WIRE 256 656 256 720
            WIRE 256 720 304 720
        END BRANCH
        INSTANCE XLXI_41 192 656 R0
        INSTANCE XLXI_42 192 848 R0
        BEGIN BRANCH SLOE
            WIRE 256 848 256 864
            WIRE 256 864 304 864
        END BRANCH
        INSTANCE XLXI_43 192 992 R0
        BEGIN BRANCH FIFOADR1
            WIRE 256 992 256 1008
            WIRE 256 1008 304 1008
        END BRANCH
        INSTANCE XLXI_48 192 1440 R0
        INSTANCE XLXI_44 192 1216 R0
        BEGIN BRANCH FIFOADR0
            WIRE 256 1072 256 1088
            WIRE 256 1072 304 1072
        END BRANCH
        BEGIN BRANCH ADC_RESET
            WIRE 256 1248 304 1248
            WIRE 256 1248 256 1312
        END BRANCH
        IOMARKER 304 1008 FIFOADR1 R0 28
        IOMARKER 304 864 SLOE R0 28
        IOMARKER 304 720 SLRD R0 28
        IOMARKER 304 1072 FIFOADR0 R0 28
        IOMARKER 304 1248 ADC_RESET R0 28
        BEGIN BRANCH ADC_CLKOUT
            WIRE 1472 144 1552 144
        END BRANCH
        BEGIN INSTANCE XLXI_65 1552 240 R0
        END INSTANCE
        BEGIN BRANCH SLWR
            WIRE 1936 144 2352 144
        END BRANCH
        BEGIN BRANCH PB(0:15)
            WIRE 1936 208 2064 208
            WIRE 2064 208 2192 208
            WIRE 2192 208 2192 240
            WIRE 2192 240 2192 288
            WIRE 2192 288 2192 336
            WIRE 2192 336 2192 384
            WIRE 2192 384 2192 432
            WIRE 2192 432 2192 480
            WIRE 2192 480 2192 528
            WIRE 2192 528 2192 576
            WIRE 2192 576 2192 624
            WIRE 2192 624 2192 672
            WIRE 2192 672 2192 720
            WIRE 2192 720 2192 768
            WIRE 2192 768 2192 816
            WIRE 2192 816 2192 864
            WIRE 2192 864 2192 912
            WIRE 2192 912 2192 960
            WIRE 2192 960 2192 976
            BEGIN DISPLAY 2064 208 ATTR Name
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 2192 240 2288 240
        BUSTAP 2192 288 2288 288
        BUSTAP 2192 336 2288 336
        BUSTAP 2192 384 2288 384
        BUSTAP 2192 432 2288 432
        BUSTAP 2192 480 2288 480
        BUSTAP 2192 528 2288 528
        BUSTAP 2192 576 2288 576
        BUSTAP 2192 624 2288 624
        BUSTAP 2192 672 2288 672
        BUSTAP 2192 720 2288 720
        BUSTAP 2192 768 2288 768
        BUSTAP 2192 816 2288 816
        BUSTAP 2192 864 2288 864
        BUSTAP 2192 912 2288 912
        BUSTAP 2192 960 2288 960
        BEGIN BRANCH PB(0)
            WIRE 2288 240 2352 240
        END BRANCH
        BEGIN BRANCH PB(1)
            WIRE 2288 288 2352 288
        END BRANCH
        BEGIN BRANCH PB(2)
            WIRE 2288 336 2352 336
        END BRANCH
        BEGIN BRANCH PB(3)
            WIRE 2288 384 2352 384
        END BRANCH
        BEGIN BRANCH PB(4)
            WIRE 2288 432 2352 432
        END BRANCH
        BEGIN BRANCH PB(5)
            WIRE 2288 480 2352 480
        END BRANCH
        BEGIN BRANCH PB(6)
            WIRE 2288 528 2352 528
        END BRANCH
        BEGIN BRANCH PB(7)
            WIRE 2288 576 2352 576
        END BRANCH
        BEGIN BRANCH PB(8)
            WIRE 2288 624 2352 624
        END BRANCH
        BEGIN BRANCH PB(9)
            WIRE 2288 672 2352 672
        END BRANCH
        BEGIN BRANCH PB(10)
            WIRE 2288 720 2352 720
        END BRANCH
        BEGIN BRANCH PB(11)
            WIRE 2288 768 2352 768
        END BRANCH
        BEGIN BRANCH PB(12)
            WIRE 2288 816 2352 816
        END BRANCH
        BEGIN BRANCH PB(13)
            WIRE 2288 864 2352 864
        END BRANCH
        BEGIN BRANCH PB(14)
            WIRE 2288 912 2352 912
        END BRANCH
        BEGIN BRANCH PB(15)
            WIRE 2288 960 2352 960
        END BRANCH
        IOMARKER 1472 144 ADC_CLKOUT R180 28
        IOMARKER 2352 240 PB(0) R0 28
        IOMARKER 2352 288 PB(1) R0 28
        IOMARKER 2352 336 PB(2) R0 28
        IOMARKER 2352 384 PB(3) R0 28
        IOMARKER 2352 432 PB(4) R0 28
        IOMARKER 2352 480 PB(5) R0 28
        IOMARKER 2352 528 PB(6) R0 28
        IOMARKER 2352 576 PB(7) R0 28
        IOMARKER 2352 624 PB(8) R0 28
        IOMARKER 2352 672 PB(9) R0 28
        IOMARKER 2352 720 PB(10) R0 28
        IOMARKER 2352 960 PB(15) R0 28
        IOMARKER 2352 912 PB(14) R0 28
        IOMARKER 2352 768 PB(11) R0 28
        IOMARKER 2352 816 PB(12) R0 28
        IOMARKER 2352 864 PB(13) R0 28
        IOMARKER 2352 144 SLWR R0 28
        BEGIN BRANCH XLXN_151
            WIRE 1520 208 1552 208
            WIRE 1520 208 1520 256
        END BRANCH
        INSTANCE XLXI_77 1456 384 R0
    END SHEET
END SCHEMATIC
