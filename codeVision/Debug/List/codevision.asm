
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x9:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x0
_0x13:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/31/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;#include <string.h>
;
;#include <stdio.h>
;
;#include <stdlib.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: Int., cap. on AREF
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 002C {

	.CSEG
; 0000 002D ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 002E // Delay needed for the stabilization of the ADC input voltage
; 0000 002F delay_us(10);
; 0000 0030 // Start the AD conversion
; 0000 0031 ADCSRA|=(1<<ADSC);
; 0000 0032 // Wait for the AD conversion to complete
; 0000 0033 while ((ADCSRA & (1<<ADIF))==0);
; 0000 0034 ADCSRA|=(1<<ADIF);
; 0000 0035 return ADCW;
; 0000 0036 }
;
;void TODelay(){
; 0000 0038 void TODelay(){
; 0000 0039     TCNT0 = 1;
; 0000 003A     TCCR0 = 0x05;
; 0000 003B     while ((TIFR&(1<<TOV0))==0);
; 0000 003C     TCCR0 = 0;
; 0000 003D     TIFR = 0x1;
; 0000 003E }
;
;TODelays(){
; 0000 0040 TODelays(){
; 0000 0041     TODelay();
; 0000 0042     TODelay();
; 0000 0043     TODelay();
; 0000 0044     TODelay();
; 0000 0045     TODelay();
; 0000 0046     TODelay();
; 0000 0047     TODelay();
; 0000 0048     TODelay();
; 0000 0049     TODelay();
; 0000 004A }
;
;int floorSqrt(int x)
; 0000 004D {
_floorSqrt:
; .FSTART _floorSqrt
; 0000 004E     long start = 1, end = x / 2, ans = 0;
; 0000 004F     if (x == 0 || x == 1)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x9*2)
	LDI  R31,HIGH(_0x9*2)
	CALL __INITLOCB
;	x -> Y+12
;	start -> Y+8
;	end -> Y+4
;	ans -> Y+0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	CALL __CWD1
	__PUTD1S 4
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,0
	BREQ _0xB
	SBIW R26,1
	BRNE _0xA
_0xB:
; 0000 0050         return x;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RJMP _0x20C0005
; 0000 0051     while (start <= end) {
_0xA:
_0xD:
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BRLT _0xF
; 0000 0052         int mid = (start + end) / 2;
; 0000 0053         if (mid * mid == x)
	SBIW R28,2
;	x -> Y+14
;	start -> Y+10
;	end -> Y+6
;	ans -> Y+2
;	mid -> Y+0
	__GETD1S 6
	__GETD2S 10
	CALL __ADDD21
	__GETD1N 0x2
	CALL __DIVD21
	ST   Y,R30
	STD  Y+1,R31
	CALL SUBOPT_0x0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x10
; 0000 0054             return (int)mid;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R28,2
	RJMP _0x20C0005
; 0000 0055         if (mid * mid < x) {
_0x10:
	CALL SUBOPT_0x0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x11
; 0000 0056             start = mid + 1;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	CALL __CWD1
	__PUTD1S 10
; 0000 0057             ans = mid;
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0x1
; 0000 0058         }
; 0000 0059         else{
	RJMP _0x12
_0x11:
; 0000 005A             end = mid - 1;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	CALL __CWD1
	__PUTD1S 6
; 0000 005B         }
_0x12:
; 0000 005C     }
	ADIW R28,2
	RJMP _0xD
_0xF:
; 0000 005D     return (int)ans;
	LD   R30,Y
	LDD  R31,Y+1
_0x20C0005:
	ADIW R28,14
	RET
; 0000 005E }
; .FEND
;
;void main(void)
; 0000 0061 {
_main:
; .FSTART _main
; 0000 0062 // Declare your local variables here
; 0000 0063 char x=0;
; 0000 0064 float Temperature ;
; 0000 0065 char Previous_temperature, out[10];
; 0000 0066 bit first = 0;
; 0000 0067 char i=-1;
; 0000 0068 float firstNum=0.00;
; 0000 0069 float secondNum=0.00;
; 0000 006A float thirdNum=0.00;
; 0000 006B int operator=0;
; 0000 006C bit isSecondNum=0;
; 0000 006D char out1[10];
; 0000 006E // Input/Output Ports initialization
; 0000 006F // Port A initialization
; 0000 0070 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0071 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,36
	LDI  R24,12
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	LDI  R30,LOW(_0x13*2)
	LDI  R31,HIGH(_0x13*2)
	CALL __INITLOCB
;	x -> R17
;	Temperature -> Y+32
;	Previous_temperature -> R16
;	out -> Y+22
;	first -> R15.0
;	i -> R19
;	firstNum -> Y+18
;	secondNum -> Y+14
;	thirdNum -> Y+10
;	operator -> R20,R21
;	isSecondNum -> R15.1
;	out1 -> Y+0
	CLR  R15
	LDI  R17,0
	LDI  R19,255
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0072 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0073 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0074 
; 0000 0075 // Port B initialization
; 0000 0076 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0077 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0078 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0079 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 007A 
; 0000 007B // Port C initialization
; 0000 007C // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 007D DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 007E // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 007F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0080 
; 0000 0081 // Port D initialization
; 0000 0082 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0083 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0084 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0085 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0086 
; 0000 0087 // Timer/Counter 0 initialization
; 0000 0088 // Clock source: System Clock
; 0000 0089 // Clock value: Timer 0 Stopped
; 0000 008A // Mode: Normal top=0xFF
; 0000 008B // OC0 output: Disconnected
; 0000 008C TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 008D TCNT0=0x00;
	OUT  0x32,R30
; 0000 008E OCR0=0x00;
	OUT  0x3C,R30
; 0000 008F 
; 0000 0090 // Timer/Counter 1 initialization
; 0000 0091 // Clock source: System Clock
; 0000 0092 // Clock value: Timer1 Stopped
; 0000 0093 // Mode: Normal top=0xFFFF
; 0000 0094 // OC1A output: Disconnected
; 0000 0095 // OC1B output: Disconnected
; 0000 0096 // Noise Canceler: Off
; 0000 0097 // Input Capture on Falling Edge
; 0000 0098 // Timer1 Overflow Interrupt: Off
; 0000 0099 // Input Capture Interrupt: Off
; 0000 009A // Compare A Match Interrupt: Off
; 0000 009B // Compare B Match Interrupt: Off
; 0000 009C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 009D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 009E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A0 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00A1 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A2 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A3 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A4 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A6 
; 0000 00A7 // Timer/Counter 2 initialization
; 0000 00A8 // Clock source: System Clock
; 0000 00A9 // Clock value: Timer2 Stopped
; 0000 00AA // Mode: Normal top=0xFF
; 0000 00AB // OC2 output: Disconnected
; 0000 00AC ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00AD TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00AE TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AF OCR2=0x00;
	OUT  0x23,R30
; 0000 00B0 
; 0000 00B1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B2 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00B3 
; 0000 00B4 // External Interrupt(s) initialization
; 0000 00B5 // INT0: Off
; 0000 00B6 // INT1: Off
; 0000 00B7 // INT2: Off
; 0000 00B8 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00B9 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00BA 
; 0000 00BB // USART initialization
; 0000 00BC // USART disabled
; 0000 00BD UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00BE 
; 0000 00BF // Analog Comparator initialization
; 0000 00C0 // Analog Comparator: Off
; 0000 00C1 // The Analog Comparator's positive input is
; 0000 00C2 // connected to the AIN0 pin
; 0000 00C3 // The Analog Comparator's negative input is
; 0000 00C4 // connected to the AIN1 pin
; 0000 00C5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C6 
; 0000 00C7 // ADC initialization
; 0000 00C8 // ADC Clock frequency: 7.813 kHz
; 0000 00C9 // ADC Voltage Reference: Int., cap. on AREF
; 0000 00CA // ADC Auto Trigger Source: Free Running
; 0000 00CB ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 00CC ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(167)
	OUT  0x6,R30
; 0000 00CD SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00CE 
; 0000 00CF // SPI initialization
; 0000 00D0 // SPI disabled
; 0000 00D1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00D2 
; 0000 00D3 // TWI initialization
; 0000 00D4 // TWI disabled
; 0000 00D5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00D6 
; 0000 00D7 // Alphanumeric LCD initialization
; 0000 00D8 // Connections are specified in the
; 0000 00D9 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00DA // RS - PORTC Bit 0
; 0000 00DB // RD - PORTC Bit 1
; 0000 00DC // EN - PORTC Bit 2
; 0000 00DD // D4 - PORTC Bit 4
; 0000 00DE // D5 - PORTC Bit 5
; 0000 00DF // D6 - PORTC Bit 6
; 0000 00E0 // D7 - PORTC Bit 7
; 0000 00E1 // Characters/line: 16
; 0000 00E2 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00E3 
; 0000 00E4 while (1)
_0x14:
; 0000 00E5       {
; 0000 00E6 
; 0000 00E7             //  calculator
; 0000 00E8 
; 0000 00E9             //  First row
; 0000 00EA 
; 0000 00EB             PORTD = 0b00000001;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 00EC 
; 0000 00ED             //  Add 7
; 0000 00EE 
; 0000 00EF             if(PIND.4==1){
	SBIS 0x10,4
	RJMP _0x17
; 0000 00F0             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x18
; 0000 00F1                 firstNum = (firstNum * 10) + 7;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
; 0000 00F2             }
; 0000 00F3             else{
	RJMP _0x19
_0x18:
; 0000 00F4                 secondNum = (secondNum * 10) + 7;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
; 0000 00F5             }
_0x19:
; 0000 00F6             i=i+1;
	CALL SUBOPT_0x7
; 0000 00F7             lcd_gotoxy(i,1);
; 0000 00F8             lcd_putchar('7');
	LDI  R26,LOW(55)
	CALL _lcd_putchar
; 0000 00F9             }
; 0000 00FA 
; 0000 00FB             //  Add 8
; 0000 00FC 
; 0000 00FD             if(PIND.5==1){
_0x17:
	SBIS 0x10,5
	RJMP _0x1A
; 0000 00FE             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x1B
; 0000 00FF                 firstNum = (firstNum * 10) + 8;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x8
	CALL SUBOPT_0x4
; 0000 0100             }
; 0000 0101             else{
	RJMP _0x1C
_0x1B:
; 0000 0102                 secondNum = (secondNum * 10) + 8;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
; 0000 0103             }
_0x1C:
; 0000 0104             i=i+1;
	CALL SUBOPT_0x7
; 0000 0105             lcd_gotoxy(i,1);
; 0000 0106             lcd_putchar('8');
	LDI  R26,LOW(56)
	CALL _lcd_putchar
; 0000 0107             }
; 0000 0108 
; 0000 0109             //  Add 9
; 0000 010A 
; 0000 010B             if(PIND.6==1){
_0x1A:
	SBIS 0x10,6
	RJMP _0x1D
; 0000 010C             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x1E
; 0000 010D                 firstNum = (firstNum * 10) + 9;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x4
; 0000 010E             }
; 0000 010F             else{
	RJMP _0x1F
_0x1E:
; 0000 0110                 secondNum = (secondNum * 10) + 9;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x9
	CALL SUBOPT_0x6
; 0000 0111             }
_0x1F:
; 0000 0112             i=i+1;
	CALL SUBOPT_0x7
; 0000 0113             lcd_gotoxy(i,1);
; 0000 0114             lcd_putchar('9');
	LDI  R26,LOW(57)
	CALL _lcd_putchar
; 0000 0115             }
; 0000 0116 
; 0000 0117             //  Division operator
; 0000 0118 
; 0000 0119             if(PIND.7==1){
_0x1D:
	SBIS 0x10,7
	RJMP _0x20
; 0000 011A             if(operator == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x21
; 0000 011B                 operator = 5;
	__GETWRN 20,21,5
; 0000 011C             }
; 0000 011D             else{
	RJMP _0x22
_0x21:
; 0000 011E                 operator = 1;
	__GETWRN 20,21,1
; 0000 011F                 isSecondNum = 1;
	SET
	BLD  R15,1
; 0000 0120             }
_0x22:
; 0000 0121             i=i+1;
	CALL SUBOPT_0x7
; 0000 0122             lcd_gotoxy(i,1);
; 0000 0123             lcd_putchar('/');
	LDI  R26,LOW(47)
	CALL _lcd_putchar
; 0000 0124             }
; 0000 0125 
; 0000 0126             delay_ms(80);
_0x20:
	CALL SUBOPT_0xA
; 0000 0127 
; 0000 0128 
; 0000 0129             //  Second row
; 0000 012A 
; 0000 012B             PORTD = 0b00000010;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 012C 
; 0000 012D             //  Add 4
; 0000 012E 
; 0000 012F             if(PIND.4==1){
	SBIS 0x10,4
	RJMP _0x23
; 0000 0130             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x24
; 0000 0131                 firstNum = (firstNum * 10) + 4;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xB
	CALL SUBOPT_0x4
; 0000 0132             }
; 0000 0133             else{
	RJMP _0x25
_0x24:
; 0000 0134                 secondNum = (secondNum * 10) + 4;
	CALL SUBOPT_0x5
	CALL SUBOPT_0xB
	CALL SUBOPT_0x6
; 0000 0135             }
_0x25:
; 0000 0136             i=i+1;
	CALL SUBOPT_0x7
; 0000 0137             lcd_gotoxy(i,1);
; 0000 0138             lcd_putchar('4');
	LDI  R26,LOW(52)
	CALL _lcd_putchar
; 0000 0139             }
; 0000 013A 
; 0000 013B             //  Add 5
; 0000 013C 
; 0000 013D             if(PIND.5==1){
_0x23:
	SBIS 0x10,5
	RJMP _0x26
; 0000 013E             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x27
; 0000 013F                 firstNum = (firstNum * 10) + 5;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xC
	CALL SUBOPT_0x4
; 0000 0140             }
; 0000 0141             else{
	RJMP _0x28
_0x27:
; 0000 0142                 secondNum = (secondNum * 10) + 5;
	CALL SUBOPT_0x5
	CALL SUBOPT_0xC
	CALL SUBOPT_0x6
; 0000 0143             }
_0x28:
; 0000 0144             i=i+1;
	CALL SUBOPT_0x7
; 0000 0145             lcd_gotoxy(i,1);
; 0000 0146             lcd_putchar('5');
	LDI  R26,LOW(53)
	CALL _lcd_putchar
; 0000 0147             }
; 0000 0148 
; 0000 0149             //  Add 6
; 0000 014A 
; 0000 014B             if(PIND.6==1){
_0x26:
	SBIS 0x10,6
	RJMP _0x29
; 0000 014C             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x2A
; 0000 014D                 firstNum = (firstNum * 10) + 6;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xD
	CALL SUBOPT_0x4
; 0000 014E             }
; 0000 014F             else{
	RJMP _0x2B
_0x2A:
; 0000 0150                 secondNum = (secondNum * 10) + 6;
	CALL SUBOPT_0x5
	CALL SUBOPT_0xD
	CALL SUBOPT_0x6
; 0000 0151             }
_0x2B:
; 0000 0152             i=i+1;
	CALL SUBOPT_0x7
; 0000 0153             lcd_gotoxy(i,1);
; 0000 0154             lcd_putchar('6');
	LDI  R26,LOW(54)
	CALL _lcd_putchar
; 0000 0155             }
; 0000 0156 
; 0000 0157             //  Multiplication operator
; 0000 0158 
; 0000 0159             if(PIND.7==1){
_0x29:
	SBIS 0x10,7
	RJMP _0x2C
; 0000 015A             if(operator == 2){
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x2D
; 0000 015B                 operator = 6;
	__GETWRN 20,21,6
; 0000 015C             }
; 0000 015D             else{
	RJMP _0x2E
_0x2D:
; 0000 015E                 operator = 2;
	__GETWRN 20,21,2
; 0000 015F                 isSecondNum = 1;
	SET
	BLD  R15,1
; 0000 0160             }
_0x2E:
; 0000 0161             i=i+1;
	CALL SUBOPT_0x7
; 0000 0162             lcd_gotoxy(i,1);
; 0000 0163             lcd_putchar('*');
	LDI  R26,LOW(42)
	CALL _lcd_putchar
; 0000 0164             }
; 0000 0165 
; 0000 0166             delay_ms(80);
_0x2C:
	CALL SUBOPT_0xA
; 0000 0167 
; 0000 0168 
; 0000 0169             // Third row
; 0000 016A 
; 0000 016B             PORTD = 0b00000100;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 016C 
; 0000 016D             //  Add 1
; 0000 016E 
; 0000 016F             if(PIND.4==1){
	SBIS 0x10,4
	RJMP _0x2F
; 0000 0170             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x30
; 0000 0171                 firstNum = (firstNum * 10) + 1;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xE
	CALL SUBOPT_0x4
; 0000 0172             }
; 0000 0173             else{
	RJMP _0x31
_0x30:
; 0000 0174                 secondNum = (secondNum * 10) + 1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0xE
	CALL SUBOPT_0x6
; 0000 0175             }
_0x31:
; 0000 0176             i=i+1;
	CALL SUBOPT_0x7
; 0000 0177             lcd_gotoxy(i,1);
; 0000 0178             lcd_putchar('1');
	LDI  R26,LOW(49)
	CALL _lcd_putchar
; 0000 0179             }
; 0000 017A 
; 0000 017B             //  Add 2
; 0000 017C 
; 0000 017D             if(PIND.5==1){
_0x2F:
	SBIS 0x10,5
	RJMP _0x32
; 0000 017E             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x33
; 0000 017F                 firstNum = (firstNum * 10) + 2;
	CALL SUBOPT_0x2
	CALL SUBOPT_0xF
	CALL SUBOPT_0x4
; 0000 0180             }
; 0000 0181             else{
	RJMP _0x34
_0x33:
; 0000 0182                 secondNum = (secondNum * 10) + 2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0xF
	CALL SUBOPT_0x6
; 0000 0183             }
_0x34:
; 0000 0184             i=i+1;
	CALL SUBOPT_0x7
; 0000 0185             lcd_gotoxy(i,1);
; 0000 0186             lcd_putchar('2');
	LDI  R26,LOW(50)
	CALL _lcd_putchar
; 0000 0187             }
; 0000 0188 
; 0000 0189             //  Add 3
; 0000 018A 
; 0000 018B             if(PIND.6==1){
_0x32:
	SBIS 0x10,6
	RJMP _0x35
; 0000 018C             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x36
; 0000 018D                 firstNum = (firstNum * 10) + 3;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x10
	CALL SUBOPT_0x4
; 0000 018E             }
; 0000 018F             else{
	RJMP _0x37
_0x36:
; 0000 0190                 secondNum = (secondNum * 10) + 3;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x10
	CALL SUBOPT_0x6
; 0000 0191             }
_0x37:
; 0000 0192             i=i+1;
	CALL SUBOPT_0x7
; 0000 0193             lcd_gotoxy(i,1);
; 0000 0194             lcd_putchar('3');
	LDI  R26,LOW(51)
	CALL _lcd_putchar
; 0000 0195             }
; 0000 0196 
; 0000 0197             // Subtraction operator
; 0000 0198 
; 0000 0199             if(PIND.7==1){
_0x35:
	SBIS 0x10,7
	RJMP _0x38
; 0000 019A             if(operator == 3){
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x39
; 0000 019B                 operator = 7;
	__GETWRN 20,21,7
; 0000 019C             }
; 0000 019D             else{
	RJMP _0x3A
_0x39:
; 0000 019E                 operator = 3;
	__GETWRN 20,21,3
; 0000 019F                 isSecondNum = 1;
	SET
	BLD  R15,1
; 0000 01A0             }
_0x3A:
; 0000 01A1             i=i+1;
	CALL SUBOPT_0x7
; 0000 01A2             lcd_gotoxy(i,1);
; 0000 01A3             lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 01A4             }
; 0000 01A5 
; 0000 01A6             delay_ms(80);
_0x38:
	CALL SUBOPT_0xA
; 0000 01A7 
; 0000 01A8 
; 0000 01A9             // Fourth row
; 0000 01AA 
; 0000 01AB             PORTD = 0b00001000;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 01AC 
; 0000 01AD             //  Clear calculator
; 0000 01AE 
; 0000 01AF             if(PIND.4==1){
	SBIS 0x10,4
	RJMP _0x3B
; 0000 01B0             lcd_clear();
	CALL _lcd_clear
; 0000 01B1             firstNum=0;
	LDI  R30,LOW(0)
	__CLRD1S 18
; 0000 01B2             secondNum=0;
	__CLRD1S 14
; 0000 01B3             thirdNum=0;
	__CLRD1S 10
; 0000 01B4             operator=0;
	__GETWRN 20,21,0
; 0000 01B5             i=-1;
	LDI  R19,LOW(255)
; 0000 01B6             isSecondNum=0;
	CLT
	BLD  R15,1
; 0000 01B7             }
; 0000 01B8 
; 0000 01B9             //  Add 0
; 0000 01BA 
; 0000 01BB             if(PIND.5==1){
_0x3B:
	SBIS 0x10,5
	RJMP _0x3C
; 0000 01BC             if(isSecondNum == 0){
	SBRC R15,1
	RJMP _0x3D
; 0000 01BD                 firstNum = (firstNum * 10) + 0;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x11
	CALL SUBOPT_0x4
; 0000 01BE             }
; 0000 01BF             else{
	RJMP _0x3E
_0x3D:
; 0000 01C0                 secondNum = (secondNum * 10) + 0;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x11
	CALL SUBOPT_0x6
; 0000 01C1             }
_0x3E:
; 0000 01C2             i=i+1;
	CALL SUBOPT_0x7
; 0000 01C3             lcd_gotoxy(i,1);
; 0000 01C4             lcd_putchar('0');
	LDI  R26,LOW(48)
	CALL _lcd_putchar
; 0000 01C5             }
; 0000 01C6 
; 0000 01C7             //  Operations calculations
; 0000 01C8 
; 0000 01C9             if(PIND.6==1){
_0x3C:
	SBIS 0x10,6
	RJMP _0x3F
; 0000 01CA             i=i+1;
	CALL SUBOPT_0x7
; 0000 01CB             lcd_gotoxy(i,1);
; 0000 01CC             lcd_putchar('=');
	LDI  R26,LOW(61)
	CALL _lcd_putchar
; 0000 01CD             switch(operator) {
	MOVW R30,R20
; 0000 01CE               case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x43
; 0000 01CF                 thirdNum = firstNum / secondNum;
	CALL SUBOPT_0x12
	CALL __DIVF21
	RJMP _0x4F
; 0000 01D0                 break;
; 0000 01D1               case 2:
_0x43:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x44
; 0000 01D2                 thirdNum = firstNum * secondNum;
	CALL SUBOPT_0x12
	CALL __MULF12
	RJMP _0x4F
; 0000 01D3                 break;
; 0000 01D4               case 3:
_0x44:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x45
; 0000 01D5                 thirdNum = firstNum - secondNum;
	__GETD2S 14
	CALL SUBOPT_0x13
	CALL __SUBF12
	RJMP _0x4F
; 0000 01D6                 break;
; 0000 01D7               case 4:
_0x45:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x46
; 0000 01D8                 thirdNum = firstNum + secondNum;
	CALL SUBOPT_0x12
	RJMP _0x50
; 0000 01D9                 break;
; 0000 01DA               case 5:
_0x46:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x47
; 0000 01DB                 thirdNum = floorSqrt(firstNum);
	CALL SUBOPT_0x13
	CALL __CFD1
	MOVW R26,R30
	RCALL _floorSqrt
	CALL SUBOPT_0x14
	RJMP _0x4F
; 0000 01DC                 break;
; 0000 01DD               case 6:
_0x47:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x48
; 0000 01DE                 thirdNum = firstNum * firstNum;
	CALL SUBOPT_0x13
	__GETD2S 18
	CALL __MULF12
	RJMP _0x4F
; 0000 01DF                 break;
; 0000 01E0               case 7:
_0x48:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x49
; 0000 01E1                 thirdNum = firstNum - 1;
	CALL SUBOPT_0x15
	CALL __SUBF12
	RJMP _0x4F
; 0000 01E2                 break;
; 0000 01E3               case 8:
_0x49:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x42
; 0000 01E4                 thirdNum = firstNum + 1;
	CALL SUBOPT_0x15
_0x50:
	CALL __ADDF12
_0x4F:
	__PUTD1S 10
; 0000 01E5                 break;
; 0000 01E6             }
_0x42:
; 0000 01E7             ftoa(thirdNum, 2, out1);
	__GETD1S 10
	CALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,5
	CALL _ftoa
; 0000 01E8             i=i+1;
	CALL SUBOPT_0x7
; 0000 01E9             lcd_gotoxy(i,1);
; 0000 01EA             lcd_puts(out1);
	MOVW R26,R28
	CALL _lcd_puts
; 0000 01EB             }
; 0000 01EC 
; 0000 01ED             //  Addition operator
; 0000 01EE 
; 0000 01EF             if(PIND.7==1){
_0x3F:
	SBIS 0x10,7
	RJMP _0x4B
; 0000 01F0             if(operator == 4){
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x4C
; 0000 01F1                 operator = 8;
	__GETWRN 20,21,8
; 0000 01F2             }
; 0000 01F3             else{
	RJMP _0x4D
_0x4C:
; 0000 01F4                 operator = 4;
	__GETWRN 20,21,4
; 0000 01F5                 isSecondNum = 1;
	SET
	BLD  R15,1
; 0000 01F6             }
_0x4D:
; 0000 01F7             i=i+1;
	CALL SUBOPT_0x7
; 0000 01F8             lcd_gotoxy(i,1);
; 0000 01F9             lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 01FA             }
; 0000 01FB 
; 0000 01FC             delay_ms(80);
_0x4B:
	CALL SUBOPT_0xA
; 0000 01FD 
; 0000 01FE       }
	RJMP _0x14
; 0000 01FF }
_0x4E:
	RJMP _0x4E
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x204000D
	CALL SUBOPT_0x16
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20C0004
_0x204000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x204000C
	CALL SUBOPT_0x16
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20C0004
_0x204000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x204000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	LDI  R30,LOW(45)
	ST   X,R30
_0x204000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2040010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2040010:
	LDD  R17,Y+8
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1
	RJMP _0x2040011
_0x2040013:
	CALL SUBOPT_0x1B
	CALL __ADDF12
	CALL SUBOPT_0x17
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x1
_0x2040014:
	CALL SUBOPT_0x1B
	CALL __CMPF12
	BRLO _0x2040016
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2040017
	CALL SUBOPT_0x16
	__POINTW2FN _0x2040000,5
	CALL _strcpyf
	RJMP _0x20C0004
_0x2040017:
	RJMP _0x2040014
_0x2040016:
	CPI  R17,0
	BRNE _0x2040018
	CALL SUBOPT_0x18
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2040019
_0x2040018:
_0x204001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001C
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	__GETD2N 0x3F000000
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1B
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x18
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x19
	CALL SUBOPT_0x14
	CALL __MULF12
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	RJMP _0x204001A
_0x204001C:
_0x2040019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0003
	CALL SUBOPT_0x18
	LDI  R30,LOW(46)
	ST   X,R30
_0x204001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2040020
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x17
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x18
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x14
	CALL SUBOPT_0x1E
	RJMP _0x204001E
_0x2040020:
_0x20C0003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 2
	SBI  0x15,2
	__DELAY_USB 2
	CBI  0x15,2
	__DELAY_USB 2
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 17
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1F
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	CP   R5,R7
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x20C0002
_0x2060007:
_0x2060004:
	INC  R5
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDD  R31,Y+1
	LD   R26,Y
	LDD  R27,Y+1
	CALL __MULW12
	MOVW R26,R30
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x2:
	__GETD2S 18
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD2N 0x40E00000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	__PUTD1S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x5:
	__GETD2S 14
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	__PUTD1S 14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x7:
	SUBI R19,-LOW(1)
	ST   -Y,R19
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD2N 0x41000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD2N 0x41100000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(80)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD2N 0x40800000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD2N 0x40A00000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD2N 0x40C00000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__GETD2N 0x3F800000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD2N 0x40000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__GETD2N 0x40400000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETD2N 0x0
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	__GETD1S 14
	__GETD2S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	__GETD1S 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x13
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL __SWAPD12
	CALL __SUBF12
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
