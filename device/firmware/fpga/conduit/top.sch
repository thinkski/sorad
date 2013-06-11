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
        SIGNAL ADC_D0
        SIGNAL ADC_D1
        SIGNAL ADC_D2
        SIGNAL ADC_D3
        SIGNAL ADC_D4
        SIGNAL ADC_D5
        SIGNAL ADC_D6
        SIGNAL PB0
        SIGNAL PB1
        SIGNAL PB2
        SIGNAL PB3
        SIGNAL PB4
        SIGNAL PB5
        SIGNAL PB6
        SIGNAL PB7
        SIGNAL PB8
        SIGNAL PB9
        SIGNAL PB10
        SIGNAL ADC_D7
        SIGNAL ADC_D8
        SIGNAL ADC_D9
        SIGNAL ADC_D10
        SIGNAL ADC_D11
        SIGNAL PB11
        SIGNAL SLRD
        SIGNAL ADC_OVR
        SIGNAL PB12
        SIGNAL PB13
        SIGNAL PB14
        SIGNAL PB15
        SIGNAL SLOE
        SIGNAL FIFOADR1
        SIGNAL FIFOADR0
        SIGNAL XLXN_88
        SIGNAL ADC_RESET
        SIGNAL ADC_CLKOUT
        SIGNAL XLXN_101
        SIGNAL SLWR
        PORT Input GCLK11
        PORT Output ADC_SCLK
        PORT Output ADC_SEN
        PORT Output ADC_SDATA
        PORT Output ADC_CLKP
        PORT Input ADC_D0
        PORT Input ADC_D1
        PORT Input ADC_D2
        PORT Input ADC_D3
        PORT Input ADC_D4
        PORT Input ADC_D5
        PORT Input ADC_D6
        PORT Output PB0
        PORT Output PB1
        PORT Output PB2
        PORT Output PB3
        PORT Output PB4
        PORT Output PB5
        PORT Output PB6
        PORT Output PB7
        PORT Output PB8
        PORT Output PB9
        PORT Output PB10
        PORT Input ADC_D7
        PORT Input ADC_D8
        PORT Input ADC_D9
        PORT Input ADC_D10
        PORT Input ADC_D11
        PORT Output PB11
        PORT Output SLRD
        PORT Input ADC_OVR
        PORT Output PB12
        PORT Output PB13
        PORT Output PB14
        PORT Output PB15
        PORT Output SLOE
        PORT Output FIFOADR1
        PORT Output FIFOADR0
        PORT Output ADC_RESET
        PORT Input ADC_CLKOUT
        PORT Output SLWR
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
        BEGIN BLOCKDEF buf
            TIMESTAMP 2000 1 1 10 10 10
            LINE N 0 -32 64 -32 
            LINE N 224 -32 128 -32 
            LINE N 64 0 128 -32 
            LINE N 128 -32 64 -64 
            LINE N 64 -64 64 0 
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
        BEGIN BLOCK XLXI_1 title
            ATTR TitleFieldText " SoRAD Conduit"
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
        BEGIN BLOCK XLXI_14 buf
            PIN I ADC_D0
            PIN O PB0
        END BLOCK
        BEGIN BLOCK XLXI_15 buf
            PIN I ADC_D1
            PIN O PB1
        END BLOCK
        BEGIN BLOCK XLXI_16 buf
            PIN I ADC_D2
            PIN O PB2
        END BLOCK
        BEGIN BLOCK XLXI_17 buf
            PIN I ADC_D3
            PIN O PB3
        END BLOCK
        BEGIN BLOCK XLXI_18 buf
            PIN I ADC_D4
            PIN O PB4
        END BLOCK
        BEGIN BLOCK XLXI_19 buf
            PIN I ADC_D5
            PIN O PB5
        END BLOCK
        BEGIN BLOCK XLXI_20 buf
            PIN I ADC_D6
            PIN O PB6
        END BLOCK
        BEGIN BLOCK XLXI_21 buf
            PIN I ADC_D7
            PIN O PB7
        END BLOCK
        BEGIN BLOCK XLXI_22 buf
            PIN I ADC_D8
            PIN O PB8
        END BLOCK
        BEGIN BLOCK XLXI_23 buf
            PIN I ADC_D9
            PIN O PB9
        END BLOCK
        BEGIN BLOCK XLXI_24 buf
            PIN I ADC_D10
            PIN O PB10
        END BLOCK
        BEGIN BLOCK XLXI_25 buf
            PIN I ADC_D11
            PIN O PB11
        END BLOCK
        BEGIN BLOCK XLXI_33 buf
            PIN I ADC_OVR
            PIN O PB12
        END BLOCK
        BEGIN BLOCK XLXI_38 gnd
            PIN G PB13
        END BLOCK
        BEGIN BLOCK XLXI_39 gnd
            PIN G PB14
        END BLOCK
        BEGIN BLOCK XLXI_40 gnd
            PIN G PB15
        END BLOCK
        BEGIN BLOCK XLXI_41 vcc
            PIN P SLRD
        END BLOCK
        BEGIN BLOCK XLXI_42 vcc
            PIN P SLOE
        END BLOCK
        BEGIN BLOCK XLXI_44 gnd
            PIN G FIFOADR0
        END BLOCK
        BEGIN BLOCK XLXI_47 gnd
            PIN G XLXN_88
        END BLOCK
        BEGIN BLOCK XLXI_48 gnd
            PIN G ADC_RESET
        END BLOCK
        BEGIN BLOCK XLXI_59 gnd
            PIN G FIFOADR1
        END BLOCK
        BEGIN BLOCK XLXI_60 buf
            PIN I ADC_CLKOUT
            PIN O SLWR
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
        INSTANCE XLXI_14 336 592 R0
        INSTANCE XLXI_15 336 688 R0
        INSTANCE XLXI_16 336 784 R0
        INSTANCE XLXI_17 336 880 R0
        INSTANCE XLXI_18 336 976 R0
        INSTANCE XLXI_19 336 1072 R0
        INSTANCE XLXI_20 336 1168 R0
        INSTANCE XLXI_21 336 1264 R0
        INSTANCE XLXI_22 336 1360 R0
        INSTANCE XLXI_23 336 1456 R0
        INSTANCE XLXI_24 336 1552 R0
        BEGIN BRANCH ADC_D0
            WIRE 304 560 336 560
        END BRANCH
        IOMARKER 304 560 ADC_D0 R180 28
        BEGIN BRANCH ADC_D1
            WIRE 304 656 336 656
        END BRANCH
        IOMARKER 304 656 ADC_D1 R180 28
        BEGIN BRANCH ADC_D2
            WIRE 304 752 336 752
        END BRANCH
        IOMARKER 304 752 ADC_D2 R180 28
        BEGIN BRANCH ADC_D3
            WIRE 304 848 336 848
        END BRANCH
        IOMARKER 304 848 ADC_D3 R180 28
        BEGIN BRANCH ADC_D4
            WIRE 304 944 336 944
        END BRANCH
        IOMARKER 304 944 ADC_D4 R180 28
        BEGIN BRANCH ADC_D5
            WIRE 304 1040 336 1040
        END BRANCH
        IOMARKER 304 1040 ADC_D5 R180 28
        BEGIN BRANCH ADC_D6
            WIRE 304 1136 336 1136
        END BRANCH
        IOMARKER 304 1136 ADC_D6 R180 28
        BEGIN BRANCH PB0
            WIRE 560 560 592 560
        END BRANCH
        IOMARKER 592 560 PB0 R0 28
        BEGIN BRANCH PB1
            WIRE 560 656 592 656
        END BRANCH
        IOMARKER 592 656 PB1 R0 28
        BEGIN BRANCH PB2
            WIRE 560 752 592 752
        END BRANCH
        IOMARKER 592 752 PB2 R0 28
        BEGIN BRANCH PB3
            WIRE 560 848 592 848
        END BRANCH
        IOMARKER 592 848 PB3 R0 28
        BEGIN BRANCH PB4
            WIRE 560 944 592 944
        END BRANCH
        IOMARKER 592 944 PB4 R0 28
        BEGIN BRANCH PB5
            WIRE 560 1040 592 1040
        END BRANCH
        IOMARKER 592 1040 PB5 R0 28
        BEGIN BRANCH PB6
            WIRE 560 1136 592 1136
        END BRANCH
        IOMARKER 592 1136 PB6 R0 28
        BEGIN BRANCH PB7
            WIRE 560 1232 592 1232
        END BRANCH
        IOMARKER 592 1232 PB7 R0 28
        BEGIN BRANCH PB8
            WIRE 560 1328 592 1328
        END BRANCH
        IOMARKER 592 1328 PB8 R0 28
        BEGIN BRANCH PB9
            WIRE 560 1424 592 1424
        END BRANCH
        IOMARKER 592 1424 PB9 R0 28
        BEGIN BRANCH PB10
            WIRE 560 1520 592 1520
        END BRANCH
        IOMARKER 592 1520 PB10 R0 28
        BEGIN BRANCH ADC_D7
            WIRE 304 1232 336 1232
        END BRANCH
        IOMARKER 304 1232 ADC_D7 R180 28
        BEGIN BRANCH ADC_D8
            WIRE 304 1328 336 1328
        END BRANCH
        IOMARKER 304 1328 ADC_D8 R180 28
        BEGIN BRANCH ADC_D9
            WIRE 304 1424 336 1424
        END BRANCH
        IOMARKER 304 1424 ADC_D9 R180 28
        BEGIN BRANCH ADC_D10
            WIRE 304 1520 336 1520
        END BRANCH
        IOMARKER 304 1520 ADC_D10 R180 28
        INSTANCE XLXI_25 336 1648 R0
        BEGIN BRANCH ADC_D11
            WIRE 304 1616 336 1616
        END BRANCH
        IOMARKER 304 1616 ADC_D11 R180 28
        BEGIN BRANCH PB11
            WIRE 560 1616 592 1616
        END BRANCH
        IOMARKER 592 1616 PB11 R0 28
        BEGIN BRANCH SLRD
            WIRE 752 592 752 656
            WIRE 752 656 1312 656
        END BRANCH
        IOMARKER 1312 656 SLRD R0 28
        INSTANCE XLXI_33 336 1744 R0
        BEGIN BRANCH ADC_OVR
            WIRE 304 1712 336 1712
        END BRANCH
        IOMARKER 304 1712 ADC_OVR R180 28
        BEGIN BRANCH PB12
            WIRE 560 1712 592 1712
        END BRANCH
        IOMARKER 592 1712 PB12 R0 28
        INSTANCE XLXI_38 240 1968 R0
        BEGIN BRANCH PB13
            WIRE 304 1824 304 1840
            WIRE 304 1824 592 1824
        END BRANCH
        IOMARKER 592 1824 PB13 R0 28
        INSTANCE XLXI_39 240 2224 R0
        INSTANCE XLXI_40 240 2480 R0
        BEGIN BRANCH PB14
            WIRE 304 2080 304 2096
            WIRE 304 2080 592 2080
        END BRANCH
        BEGIN BRANCH PB15
            WIRE 304 2336 304 2352
            WIRE 304 2336 592 2336
        END BRANCH
        IOMARKER 592 2080 PB14 R0 28
        IOMARKER 592 2336 PB15 R0 28
        INSTANCE XLXI_41 688 592 R0
        INSTANCE XLXI_42 688 784 R0
        BEGIN BRANCH SLOE
            WIRE 752 784 752 800
            WIRE 752 800 1312 800
        END BRANCH
        IOMARKER 1312 800 SLOE R0 28
        INSTANCE XLXI_44 688 1200 R0
        BEGIN BRANCH FIFOADR0
            WIRE 752 1056 752 1072
            WIRE 752 1056 1312 1056
        END BRANCH
        IOMARKER 1312 1056 FIFOADR0 R0 28
        INSTANCE XLXI_47 560 480 R0
        BEGIN BRANCH XLXN_88
            WIRE 624 304 832 304
            WIRE 624 304 624 352
        END BRANCH
        INSTANCE XLXI_48 688 1424 R0
        BEGIN BRANCH ADC_RESET
            WIRE 752 1280 752 1296
            WIRE 752 1280 1312 1280
        END BRANCH
        IOMARKER 1312 1280 ADC_RESET R0 28
        BEGIN BRANCH ADC_CLKOUT
            WIRE 1552 560 1616 560
            WIRE 1616 560 1632 560
        END BRANCH
        BEGIN BRANCH FIFOADR1
            WIRE 752 880 752 896
            WIRE 752 880 1312 880
        END BRANCH
        INSTANCE XLXI_59 688 1024 R0
        IOMARKER 1312 880 FIFOADR1 R0 28
        INSTANCE XLXI_60 1632 592 R0
        IOMARKER 1888 560 SLWR R0 28
        BEGIN BRANCH SLWR
            WIRE 1856 560 1872 560
            WIRE 1872 560 1888 560
        END BRANCH
        IOMARKER 1552 560 ADC_CLKOUT R180 28
    END SHEET
END SCHEMATIC
