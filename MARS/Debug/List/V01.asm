
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
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

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
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
	.DEF _cod0=R3
	.DEF _cod0_msb=R4
	.DEF _codTemp=R5
	.DEF _codTemp_msb=R6
	.DEF _permit=R8
	.DEF _co2p=R7
	.DEF _timerCounter=R10
	.DEF _consentration=R11
	.DEF _consentration_msb=R12
	.DEF _co2=R13
	.DEF _co2_msb=R14
	.DEF _txWrIndex=R9

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

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
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  _usart_dre_isr
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _twi_int_handler
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0x10
_0x4:
	.DB  0x78,0x78,0x78,0x78,0x2E,0x78
_0x5:
	.DB  0x78,0x78,0x2E,0x78,0x30
_0x6:
	.DB  0x2B,0x78,0x78,0x2E,0x78
_0x7:
	.DB  0x2B,0x78,0x78,0x2E,0x78
_0x8:
	.DB  0x78,0x78,0x78,0x2E,0x78,0x78
_0x0:
	.DB  0x2B,0x78,0x78,0x2E,0x78,0x43,0x20,0x78
	.DB  0x78,0x78,0x2E,0x78,0x78,0x6B,0x50,0x61
	.DB  0x0,0x78,0x78,0x2E,0x78,0x78,0x25,0x20
	.DB  0x78,0x78,0x78,0x78,0x2E,0x78,0x70,0x70
	.DB  0x6D,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040003:
	.DB  0x7
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x09
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _dataLed
	.DW  _0x3*2

	.DW  0x06
	.DW  _co2s
	.DW  _0x4*2

	.DW  0x05
	.DW  _vs
	.DW  _0x5*2

	.DW  0x05
	.DW  _t1s
	.DW  _0x6*2

	.DW  0x05
	.DW  _t2s
	.DW  _0x7*2

	.DW  0x06
	.DW  _ps
	.DW  _0x8*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

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
	OUT  MCUCR,R31
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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0x300

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
;Date    : 02.11.2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;/*
;Управление
;    G   -   начать передачу данных по ВТ
;    R   -   остановить передачу данных по ВТ
;    C   -   передавать температуру оцифрованную DHT-22
;    c   -   передавать темпераутру оцифрованную BMP-180
;    S   -   перейти в режим настройки (концентрация СО2 указывается в коде, а не ррм
;    s   -   перейти в обычный режим
;    x   -   в режиме настройки команда х111, где 111 - любые цифры, изменяет в программе код0
;Возврат
;*/
;
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <math.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define Bit(bit)				(1<<(bit))						//Обратится к биту
;#define ClearBit(reg, bit)      reg &= (~(1<<(bit)))			//Очистить бит
;#define SetBit(reg, bit)        reg |= (1<<(bit))				//Установить бит
;#define BitIsClear(reg, bit)    ((reg & (1<<(bit))) == 0)		//Проверка очистки бита
;#define BitIsSet(reg, bit)      ((reg & (1<<(bit))) != 0)		//Проверка установки бита
;#define InvBit(reg, bit)        reg ^= (1<<(bit))				//Инвертировать бит
;
;#define DC_GAIN 8.5
;#define ZERO_POINT_VOLTAGE  0.325
;#define REACTION_VOLTAGE    0.02
;#define UREF                5
;
;eeprom unsigned int etemp;
;eeprom unsigned char eCod0,eCod1;
;unsigned int cod0,codTemp;
;unsigned char dataLed[96]={0x10};

	.DSEG
;
;// Declare your global variables here
;bit timerEnd,errorDHT,Sw,Run,Stp,Ust;
;unsigned char permit,co2p,timerCounter=0;
;unsigned int consentration,co2,v,co2led,vled;
;int t1;
;float xxx,xxx1;
;
;
;unsigned char txBuffer[256];
;unsigned char txWrIndex=0,txRdIndex=0;
;unsigned char co2s[7]={'x','x','x','x','.','x',0};
;unsigned char vs[6]={'x','x','.','x','0',0};
;unsigned char t1s[6]={'+','x','x','.','x',0};
;unsigned char t2s[6]={'+','x','x','.','x',0};
;unsigned char ps[7]={'x','x','x','.','x','x',0};
;unsigned char twi_eeprom[22];
;unsigned char twi_adr[2];
;int ac1,ac2,ac3,b1,b2,mb,mc,md;
;unsigned int ac4,ac5,ac6;
;long int ut,x1,x2,b5,t,b6,x3,b3,pressure,p;
;unsigned long b4,b7;
;
;unsigned char nnn;
;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0056 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0057     unsigned char temp;
; 0000 0058     temp=UDR0;
	ST   -Y,R17
;	temp -> R17
	LDS  R17,198
; 0000 0059     if (Ust)
	SBIS 0x1E,5
	RJMP _0x9
; 0000 005A     {
; 0000 005B         codTemp*=10;
	__GETW1R 5,6
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	__PUTW1R 5,6
; 0000 005C         codTemp+=temp-'0';
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	__ADDWRR 5,6,30,31
; 0000 005D         nnn--;
	LDS  R30,_nnn
	SUBI R30,LOW(1)
	STS  _nnn,R30
; 0000 005E         if (nnn==0)
	CPI  R30,0
	BREQ PC+3
	JMP _0xA
; 0000 005F         {
; 0000 0060             eCod0=codTemp/256;
	MOV  R30,R6
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(_eCod0)
	LDI  R27,HIGH(_eCod0)
	CALL __EEPROMWRB
; 0000 0061             eCod1=codTemp%256;
	MOV  R30,R5
	LDI  R26,LOW(_eCod1)
	LDI  R27,HIGH(_eCod1)
	CALL __EEPROMWRB
; 0000 0062             cod0=codTemp;
	__MOVEWRR 3,4,5,6
; 0000 0063             Ust=0;
	CBI  0x1E,5
; 0000 0064         }
; 0000 0065     }
_0xA:
; 0000 0066     if (temp=='C')
_0x9:
	CPI  R17,67
	BREQ PC+3
	JMP _0xD
; 0000 0067         Sw=1;
	SBI  0x1E,2
; 0000 0068     if (temp=='c')
_0xD:
	CPI  R17,99
	BREQ PC+3
	JMP _0x10
; 0000 0069         Sw=0;
	CBI  0x1E,2
; 0000 006A     if (temp=='G')
_0x10:
	CPI  R17,71
	BREQ PC+3
	JMP _0x13
; 0000 006B         Run=1;
	SBI  0x1E,3
; 0000 006C     if (temp=='R')
_0x13:
	CPI  R17,82
	BREQ PC+3
	JMP _0x16
; 0000 006D         Run=0;
	CBI  0x1E,3
; 0000 006E     if (temp=='S')
_0x16:
	CPI  R17,83
	BREQ PC+3
	JMP _0x19
; 0000 006F         Stp=0;
	CBI  0x1E,4
; 0000 0070     if (temp=='s')
_0x19:
	CPI  R17,115
	BREQ PC+3
	JMP _0x1C
; 0000 0071         Stp=1;
	SBI  0x1E,4
; 0000 0072     if (temp=='x')
_0x1C:
	CPI  R17,120
	BREQ PC+3
	JMP _0x1F
; 0000 0073         if (Stp==0)
	SBIC 0x1E,4
	RJMP _0x20
; 0000 0074         {
; 0000 0075             Ust=1;
	SBI  0x1E,5
; 0000 0076             nnn=3;
	LDI  R30,LOW(3)
	STS  _nnn,R30
; 0000 0077             codTemp=0;
	CLR  R5
	CLR  R6
; 0000 0078         }
; 0000 0079 }
_0x20:
_0x1F:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 007D {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 007E     ClearBit(UCSR0B,TXCIE0);									//Запретить прерывания по завершению передачи
	LDS  R30,193
	ANDI R30,0xBF
	STS  193,R30
; 0000 007F 	if (txRdIndex!=txWrIndex)									//Если появился новый символ для передачи
	LDS  R26,_txRdIndex
	CP   R9,R26
	BRNE PC+3
	JMP _0x23
; 0000 0080 		SetBit(UCSR0B,UDRIE0);
	LDS  R30,193
	ORI  R30,0x20
	STS  193,R30
; 0000 0081 }
_0x23:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// USART DRE interrupt service routine
;interrupt [USART_DRE] void usart_dre_isr(void)
; 0000 0085 {
_usart_dre_isr:
; .FSTART _usart_dre_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0086     UDR0=txBuffer[txRdIndex++];
	LDS  R30,_txRdIndex
	SUBI R30,-LOW(1)
	STS  _txRdIndex,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	STS  198,R30
; 0000 0087     if (txRdIndex==txWrIndex)									//Если достигли конца команды
	LDS  R26,_txRdIndex
	CP   R9,R26
	BREQ PC+3
	JMP _0x24
; 0000 0088 	{
; 0000 0089 		ClearBit(UCSR0B,UDRIE0);								//Запретить прерывания - регистр данных пуст
	LDS  R30,193
	ANDI R30,0xDF
	STS  193,R30
; 0000 008A 		SetBit(UCSR0B,TXCIE0);
	LDS  R30,193
	ORI  R30,0x40
	STS  193,R30
; 0000 008B 	}
; 0000 008C }
_0x24:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0090 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0091     timerCounter++;
	INC  R10
; 0000 0092     if (timerCounter==7)
	LDI  R30,LOW(7)
	CP   R30,R10
	BREQ PC+3
	JMP _0x25
; 0000 0093     {
; 0000 0094         timerEnd=0;
	CBI  0x1E,0
; 0000 0095         timerCounter=0;
	CLR  R10
; 0000 0096     }
; 0000 0097 }
_0x25:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;unsigned int readADC(void)
; 0000 009D {
_readADC:
; .FSTART _readADC
; 0000 009E     SetBit(ADCSRA,ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 009F     // Wait for the AD conversion to complete
; 0000 00A0     while (BitIsClear(ADCSRA,ADIF)){};
_0x28:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ PC+3
	JMP _0x2A
	RJMP _0x28
_0x2A:
; 0000 00A1     SetBit(ADCSRA,ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 00A2     return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	RET
; 0000 00A3 }
; .FEND
;
;unsigned char dataDHT[5];						//Данные (5 байт) принимаемые от DHT22
;unsigned char readDHT(void)
; 0000 00A7 {
_readDHT:
; .FSTART _readDHT
; 0000 00A8     unsigned char id,jd;
; 0000 00A9 	SetBit(DDRD,2);
	ST   -Y,R17
	ST   -Y,R16
;	id -> R17
;	jd -> R16
	SBI  0xA,2
; 0000 00AA 	ClearBit(PORTD,2);
	CBI  0xB,2
; 0000 00AB 	delay_ms(25);
	LDI  R26,LOW(25)
	LDI  R27,0
	CALL _delay_ms
; 0000 00AC 	SetBit(PORTD,2);
	SBI  0xB,2
; 0000 00AD     delay_us(30);
	__DELAY_USB 160
; 0000 00AE 	ClearBit(DDRD,2);
	CBI  0xA,2
; 0000 00AF 	delay_us(40);
	__DELAY_USB 213
; 0000 00B0 	if (BitIsSet(PIND,2)) return 0;
	SBIS 0x9,2
	RJMP _0x2B
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00B1 	delay_us(80);
_0x2B:
	__DELAY_USW 320
; 0000 00B2 	if (BitIsClear(PIND,2)) return 0;
	SBIC 0x9,2
	RJMP _0x2C
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00B3 	while (BitIsSet(PIND,2))
_0x2C:
_0x2D:
	SBIS 0x9,2
	RJMP _0x2F
; 0000 00B4         if (!timerEnd)
	SBIC 0x1E,0
	RJMP _0x30
; 0000 00B5             return 0;
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00B6 	for (id=0;id<5;id++){
_0x30:
	RJMP _0x2D
_0x2F:
	LDI  R17,LOW(0)
_0x32:
	CPI  R17,5
	BRLO PC+3
	JMP _0x33
; 0000 00B7 		dataDHT[id]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dataDHT)
	SBCI R31,HIGH(-_dataDHT)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00B8         jd=7;
	LDI  R16,LOW(7)
; 0000 00B9         while (jd!=0xff)
_0x34:
	CPI  R16,255
	BRNE PC+3
	JMP _0x36
; 0000 00BA         {
; 0000 00BB 			while (BitIsClear(PIND,2))
_0x37:
	SBIC 0x9,2
	RJMP _0x39
; 0000 00BC                 if (!timerEnd)
	SBIC 0x1E,0
	RJMP _0x3A
; 0000 00BD                     return 0;
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00BE 			delay_us(40);
_0x3A:
	RJMP _0x37
_0x39:
	__DELAY_USB 213
; 0000 00BF 			if (BitIsSet(PIND,2))
	SBIS 0x9,2
	RJMP _0x3B
; 0000 00C0 				dataDHT[id]|=(1<<jd);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dataDHT)
	SBCI R31,HIGH(-_dataDHT)
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
; 0000 00C1 			while (BitIsSet(PIND,2))
_0x3B:
_0x3C:
	SBIS 0x9,2
	RJMP _0x3E
; 0000 00C2                 if (!timerEnd)
	SBIC 0x1E,0
	RJMP _0x3F
; 0000 00C3                     return 0;
	LDI  R30,LOW(0)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00C4             jd--;
_0x3F:
	RJMP _0x3C
_0x3E:
	SUBI R16,1
; 0000 00C5 		}
	RJMP _0x34
_0x36:
; 0000 00C6 	}
_0x31:
	SUBI R17,-1
	RJMP _0x32
_0x33:
; 0000 00C7 	return 1;
	LDI  R30,LOW(1)
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00C8 }
; .FEND
;
;#pragma warn-
;void asmSendData(unsigned char n){
; 0000 00CB void asmSendData(unsigned char n){
_asmSendData:
; .FSTART _asmSendData
; 0000 00CC #asm
	ST   -Y,R26
;	n -> Y+0
; 0000 00CD 	cli
	cli
; 0000 00CE 	push r30
	push r30
; 0000 00CF 	push r31
	push r31
; 0000 00D0     push r28
    push r28
; 0000 00D1     push r29
    push r29
; 0000 00D2     push r26
    push r26
; 0000 00D3     push r27
    push r27
; 0000 00D4 	push r18
	push r18
; 0000 00D5 	push r19
	push r19
; 0000 00D6 	push r20
	push r20
; 0000 00D7     ld   r18,y               ;R18 bytes
    ld   r18,y               ;R18 bytes
; 0000 00D8 	ldi R30,0x00	            ;Z dataLed  (0x0300)
	ldi R30,0x00	            ;Z dataLed  (0x0300)
; 0000 00D9 	ldi R31,0x03
	ldi R31,0x03
; 0000 00DA m4:	ldi R19,8				;R19 bits
m4:	ldi R19,8				;R19 bits
; 0000 00DB 	ld R20,Z+				;R20 data
	ld R20,Z+				;R20 data
; 0000 00DC m3:	cbi 0x05,3				;0x05 PORTB
m3:	cbi 0x05,3				;0x05 PORTB
; 0000 00DD m5:	nop
m5:	nop
; 0000 00DE 	nop
	nop
; 0000 00DF 	nop
	nop
; 0000 00E0 	lsl R20
	lsl R20
; 0000 00E1 	sbi 0x05,3
	sbi 0x05,3
; 0000 00E2 	nop
	nop
; 0000 00E3 	nop
	nop
; 0000 00E4 	nop
	nop
; 0000 00E5 	brcs m1
	brcs m1
; 0000 00E6 	cbi 0x05,3
	cbi 0x05,3
; 0000 00E7 	nop
	nop
; 0000 00E8 	nop
	nop
; 0000 00E9 	nop
	nop
; 0000 00EA 	nop
	nop
; 0000 00EB 	nop
	nop
; 0000 00EC 	dec R19
	dec R19
; 0000 00ED 	brne m5
	brne m5
; 0000 00EE 	dec R18
	dec R18
; 0000 00EF 	brne m4
	brne m4
; 0000 00F0 	pop r20
	pop r20
; 0000 00F1 	pop r19
	pop r19
; 0000 00F2 	pop r18
	pop r18
; 0000 00F3 	pop r31
	pop r31
; 0000 00F4 	pop r30
	pop r30
; 0000 00F5 	sei
	sei
; 0000 00F6 	ret
	ret
; 0000 00F7 m1:	nop
m1:	nop
; 0000 00F8 	nop
	nop
; 0000 00F9 	nop
	nop
; 0000 00FA 	nop
	nop
; 0000 00FB 	dec R19
	dec R19
; 0000 00FC 	brne m3
	brne m3
; 0000 00FD 	nop
	nop
; 0000 00FE 	cbi 0x05,3
	cbi 0x05,3
; 0000 00FF 	dec R18
	dec R18
; 0000 0100 	brne m4
	brne m4
; 0000 0101 	pop r20
	pop r20
; 0000 0102 	pop r19
	pop r19
; 0000 0103 	pop r18
	pop r18
; 0000 0104     pop r27
    pop r27
; 0000 0105     pop r26
    pop r26
; 0000 0106     pop r29
    pop r29
; 0000 0107     pop r28
    pop r28
; 0000 0108 	pop r31
	pop r31
; 0000 0109 	pop r30
	pop r30
; 0000 010A 	sei
	sei
; 0000 010B 	ret
	ret
; 0000 010C #endasm
; 0000 010D }
	ADIW R28,1
	RET
; .FEND
;#pragma warn+
;
;
;
;
;// TWI functions
;#include <twi.h>
;
;void main(void)
; 0000 0117 {
_main:
; .FSTART _main
; 0000 0118 // Declare your local variables here
; 0000 0119 unsigned char temp;
; 0000 011A // Crystal Oscillator division factor: 1
; 0000 011B #pragma optsize-
; 0000 011C CLKPR=(1<<CLKPCE);
;	temp -> R17
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 011D CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 011E #ifdef _OPTIMIZE_SIZE_
; 0000 011F #pragma optsize+
; 0000 0120 #endif
; 0000 0121 
; 0000 0122 // Input/Output Ports initialization
; 0000 0123 // Port B initialization
; 0000 0124 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0125 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x4,R30
; 0000 0126 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0127 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0128 
; 0000 0129 // Port C initialization
; 0000 012A // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 012B DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(48)
	OUT  0x7,R30
; 0000 012C // State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 012D PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 012E 
; 0000 012F // Port D initialization
; 0000 0130 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 0131 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(246)
	OUT  0xA,R30
; 0000 0132 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 0133 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0134 
; 0000 0135 // Timer/Counter 0 initialization
; 0000 0136 // Clock source: System Clock
; 0000 0137 // Clock value: 15,625 kHz
; 0000 0138 // Mode: Normal top=0xFF
; 0000 0139 // OC0A output: Disconnected
; 0000 013A // OC0B output: Disconnected
; 0000 013B // Timer Period: 16,384 ms
; 0000 013C TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 013D TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 013E TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 013F OCR0A=0x00;
	OUT  0x27,R30
; 0000 0140 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0141 
; 0000 0142 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0143 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0144 
; 0000 0145 // USART initialization
; 0000 0146 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0147 // USART Receiver: On
; 0000 0148 // USART Transmitter: On
; 0000 0149 // USART0 Mode: Asynchronous
; 0000 014A // USART Baud Rate: 9600
; 0000 014B UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 014C UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 014D UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 014E UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 014F UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 0150 
; 0000 0151 // ADC initialization
; 0000 0152 // ADC Clock frequency: 125,000 kHz
; 0000 0153 // ADC Voltage Reference: AVCC pin
; 0000 0154 // ADC Auto Trigger Source: ADC Stopped
; 0000 0155 // Digital input buffers on ADC0: On, ADC1: Off, ADC2: On, ADC3: On
; 0000 0156 // ADC4: On, ADC5: On
; 0000 0157 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (1<<ADC1D) | (0<<ADC0D);
	LDI  R30,LOW(2)
	STS  126,R30
; 0000 0158 ADMUX=ADC_VREF_TYPE | 1;
	LDI  R30,LOW(65)
	STS  124,R30
; 0000 0159 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	STS  122,R30
; 0000 015A ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 015B 
; 0000 015C // TWI initialization
; 0000 015D // Mode: TWI Master
; 0000 015E // Bit Rate: 100 kHz
; 0000 015F twi_master_init(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _twi_master_init
; 0000 0160 
; 0000 0161 // Alphanumeric LCD initialization
; 0000 0162 // Connections are specified in the
; 0000 0163 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0164 // RS - PORTB Bit 0
; 0000 0165 // RD - PORTB Bit 1
; 0000 0166 // EN - PORTB Bit 2
; 0000 0167 // D4 - PORTD Bit 4
; 0000 0168 // D5 - PORTD Bit 5
; 0000 0169 // D6 - PORTD Bit 6
; 0000 016A // D7 - PORTD Bit 7
; 0000 016B // Characters/line: 16
; 0000 016C lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 016D lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 016E lcd_putsf("+xx.xC xxx.xxkPa");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 016F lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0170 lcd_putsf("xx.xx% xxxx.xppm");
	__POINTW2FN _0x0,17
	CALL _lcd_putsf
; 0000 0171 
; 0000 0172 xxx=(float)REACTION_VOLTAGE*DC_GAIN*1023/UREF/(3-2.602);
	__GETD1N 0x42AEC8AF
	STS  _xxx,R30
	STS  _xxx+1,R31
	STS  _xxx+2,R22
	STS  _xxx+3,R23
; 0000 0173 cod0=eCod0;
	LDI  R26,LOW(_eCod0)
	LDI  R27,HIGH(_eCod0)
	CALL __EEPROMRDB
	MOV  R3,R30
	CLR  R4
; 0000 0174 cod0*=256;
	MOV  R4,R3
	CLR  R3
; 0000 0175 cod0+=eCod1;
	LDI  R26,LOW(_eCod1)
	LDI  R27,HIGH(_eCod1)
	CALL __EEPROMRDB
	LDI  R31,0
	__ADDWRR 3,4,30,31
; 0000 0176 //cod0=665;
; 0000 0177 
; 0000 0178 permit=etemp;
	LDI  R26,LOW(_etemp)
	LDI  R27,HIGH(_etemp)
	CALL __EEPROMRDB
	MOV  R8,R30
; 0000 0179 permit=0;
	CLR  R8
; 0000 017A consentration=0;
	CLR  R11
	CLR  R12
; 0000 017B timerCounter=0;
	CLR  R10
; 0000 017C Sw=0;
	CBI  0x1E,2
; 0000 017D Run=0;
	CBI  0x1E,3
; 0000 017E Stp=1;
	SBI  0x1E,4
; 0000 017F nnn=0;
	LDI  R30,LOW(0)
	STS  _nnn,R30
; 0000 0180 Ust=0;
	CBI  0x1E,5
; 0000 0181 
; 0000 0182 // Global enable interrupts
; 0000 0183 #asm("sei")
	sei
; 0000 0184 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 0185 twi_adr[0]=0xF4;
	LDI  R30,LOW(244)
	STS  _twi_adr,R30
; 0000 0186 twi_adr[1]=0x2E;
	LDI  R30,LOW(46)
	__PUTB1MN _twi_adr,1
; 0000 0187 //twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
; 0000 0188 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0189 twi_adr[0]=0xAA;
	LDI  R30,LOW(170)
	STS  _twi_adr,R30
; 0000 018A twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,22);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(_twi_adr)
	LDI  R31,HIGH(_twi_adr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_twi_eeprom)
	LDI  R31,HIGH(_twi_eeprom)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(22)
	CALL _twi_master_trans
; 0000 018B //twi_master_trans(0x77,0,0,(unsigned char *)&twi_adr,2);
; 0000 018C ac1=(twi_eeprom[0]<<8)|(twi_eeprom[1]);
	LDS  R27,_twi_eeprom
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac1,R30
	STS  _ac1+1,R31
; 0000 018D ac2=(twi_eeprom[2]<<8)|(twi_eeprom[3]);
	__GETBRMN 27,_twi_eeprom,2
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,3
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac2,R30
	STS  _ac2+1,R31
; 0000 018E ac3=(twi_eeprom[4]<<8)|(twi_eeprom[5]);
	__GETBRMN 27,_twi_eeprom,4
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,5
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac3,R30
	STS  _ac3+1,R31
; 0000 018F ac4=(twi_eeprom[6]<<8)|(twi_eeprom[7]);
	__GETBRMN 27,_twi_eeprom,6
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,7
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac4,R30
	STS  _ac4+1,R31
; 0000 0190 ac5=(twi_eeprom[8]<<8)|(twi_eeprom[9]);
	__GETBRMN 27,_twi_eeprom,8
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,9
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac5,R30
	STS  _ac5+1,R31
; 0000 0191 ac6=(twi_eeprom[10]<<8)|(twi_eeprom[11]);
	__GETBRMN 27,_twi_eeprom,10
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _ac6,R30
	STS  _ac6+1,R31
; 0000 0192 b1=(twi_eeprom[12]<<8)|(twi_eeprom[13]);
	__GETBRMN 27,_twi_eeprom,12
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,13
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _b1,R30
	STS  _b1+1,R31
; 0000 0193 b2=(twi_eeprom[14]<<8)|(twi_eeprom[15]);
	__GETBRMN 27,_twi_eeprom,14
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,15
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _b2,R30
	STS  _b2+1,R31
; 0000 0194 mb=(twi_eeprom[16]<<8)|(twi_eeprom[17]);
	__GETBRMN 27,_twi_eeprom,16
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _mb,R30
	STS  _mb+1,R31
; 0000 0195 mc=(twi_eeprom[18]<<8)|(twi_eeprom[19]);
	__GETBRMN 27,_twi_eeprom,18
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,19
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _mc,R30
	STS  _mc+1,R31
; 0000 0196 md=(twi_eeprom[20]<<8)|(twi_eeprom[21]);
	__GETBRMN 27,_twi_eeprom,20
	LDI  R26,LOW(0)
	__GETB1MN _twi_eeprom,21
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _md,R30
	STS  _md+1,R31
; 0000 0197 
; 0000 0198 ClearBit(DDRD,2);
	CBI  0xA,2
; 0000 0199 delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 019A 
; 0000 019B 
; 0000 019C 
; 0000 019D     while (1)
_0x48:
; 0000 019E     {
; 0000 019F         timerEnd=1;
	SBI  0x1E,0
; 0000 01A0         permit++;
	INC  R8
; 0000 01A1         if (permit<9)
	LDI  R30,LOW(9)
	CP   R8,R30
	BRLO PC+3
	JMP _0x4D
; 0000 01A2         {
; 0000 01A3             consentration+=readADC();
	CALL _readADC
	__ADDWRR 11,12,30,31
; 0000 01A4         }
; 0000 01A5         if (permit==9)
_0x4D:
	LDI  R30,LOW(9)
	CP   R30,R8
	BREQ PC+3
	JMP _0x4E
; 0000 01A6         {
; 0000 01A7            co2=consentration>>3;
	__GETW1R 11,12
	CALL __LSRW3
	__PUTW1R 13,14
; 0000 01A8            if (Stp)
	SBIS 0x1E,4
	RJMP _0x4F
; 0000 01A9            {
; 0000 01AA              //co2=400*pow(10,(consentration-cod0)/xxx);
; 0000 01AB              if (co2>cod0)
	__CPWRR 3,4,13,14
	BRLO PC+3
	JMP _0x50
; 0000 01AC                 co2=400;
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	__PUTW1R 13,14
; 0000 01AD              else
	RJMP _0x51
_0x50:
; 0000 01AE              {
; 0000 01AF                 co2=cod0-co2;
	__GETW1R 3,4
	SUB  R30,R13
	SBC  R31,R14
	__PUTW1R 13,14
; 0000 01B0                 xxx1=co2/xxx;
	LDS  R30,_xxx
	LDS  R31,_xxx+1
	LDS  R22,_xxx+2
	LDS  R23,_xxx+3
	__GETW2R 13,14
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __DIVF21
	STS  _xxx1,R30
	STS  _xxx1+1,R31
	STS  _xxx1+2,R22
	STS  _xxx1+3,R23
; 0000 01B1                 xxx1=pow(10,xxx1);
	__GETD1N 0x41200000
	CALL __PUTPARD1
	LDS  R26,_xxx1
	LDS  R27,_xxx1+1
	LDS  R24,_xxx1+2
	LDS  R25,_xxx1+3
	CALL _pow
	STS  _xxx1,R30
	STS  _xxx1+1,R31
	STS  _xxx1+2,R22
	STS  _xxx1+3,R23
; 0000 01B2                 if (xxx1>25)
	LDS  R26,_xxx1
	LDS  R27,_xxx1+1
	LDS  R24,_xxx1+2
	LDS  R25,_xxx1+3
	__GETD1N 0x41C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x52
; 0000 01B3                     co2=9999;
	LDI  R30,LOW(9999)
	LDI  R31,HIGH(9999)
	__PUTW1R 13,14
; 0000 01B4                 else
	RJMP _0x53
_0x52:
; 0000 01B5                     co2=400*xxx1;
	LDS  R30,_xxx1
	LDS  R31,_xxx1+1
	LDS  R22,_xxx1+2
	LDS  R23,_xxx1+3
	__GETD2N 0x43C80000
	CALL __MULF12
	CALL __CFD1U
	__PUTW1R 13,14
; 0000 01B6              }
_0x53:
_0x51:
; 0000 01B7              co2p=0;
	CLR  R7
; 0000 01B8            }
; 0000 01B9            else
	RJMP _0x54
_0x4F:
; 0000 01BA            {
; 0000 01BB              co2p=consentration%8;
	MOV  R30,R11
	ANDI R30,LOW(0x7)
	MOV  R7,R30
; 0000 01BC              co2p=co2p*10/8;
	MOV  R26,R7
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOV  R7,R30
; 0000 01BD            }
_0x54:
; 0000 01BE            co2led=co2;
	__PUTWMRN _co2led,0,13,14
; 0000 01BF            consentration=0;
	CLR  R11
	CLR  R12
; 0000 01C0            temp=co2/1000;
	__GETW2R 13,14
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 01C1            co2s[0]=temp+'0';
	SUBI R30,-LOW(48)
	STS  _co2s,R30
; 0000 01C2            co2-=temp*1000;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12
	__SUBWRR 13,14,30,31
; 0000 01C3            temp=co2/100;
	__GETW2R 13,14
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 01C4            co2s[1]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _co2s,1
; 0000 01C5            co2-=temp*100;
	LDI  R30,LOW(100)
	MUL  R30,R17
	MOVW R30,R0
	__SUBWRR 13,14,30,31
; 0000 01C6            temp=co2/10;
	__GETW2R 13,14
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 01C7            co2s[2]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _co2s,2
; 0000 01C8            co2-=temp*10;
	LDI  R30,LOW(10)
	MUL  R30,R17
	MOVW R30,R0
	__SUBWRR 13,14,30,31
; 0000 01C9            co2s[3]=co2+'0';
	MOV  R30,R13
	SUBI R30,-LOW(48)
	__PUTB1MN _co2s,3
; 0000 01CA            co2s[5]=co2p+'0';
	MOV  R30,R7
	SUBI R30,-LOW(48)
	__PUTB1MN _co2s,5
; 0000 01CB         }
; 0000 01CC         if (permit==10)
_0x4E:
	LDI  R30,LOW(10)
	CP   R30,R8
	BREQ PC+3
	JMP _0x55
; 0000 01CD         {
; 0000 01CE             twi_adr[0]=0xF4;
	LDI  R30,LOW(244)
	STS  _twi_adr,R30
; 0000 01CF             twi_adr[1]=0x2E;
	LDI  R30,LOW(46)
	__PUTB1MN _twi_adr,1
; 0000 01D0             twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(_twi_adr)
	LDI  R31,HIGH(_twi_adr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _twi_master_trans
; 0000 01D1         }
; 0000 01D2         if (permit==11)
_0x55:
	LDI  R30,LOW(11)
	CP   R30,R8
	BREQ PC+3
	JMP _0x56
; 0000 01D3         {
; 0000 01D4             twi_adr[0]=0xF6;
	LDI  R30,LOW(246)
	STS  _twi_adr,R30
; 0000 01D5             twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,2);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(_twi_adr)
	LDI  R31,HIGH(_twi_adr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_twi_eeprom)
	LDI  R31,HIGH(_twi_eeprom)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _twi_master_trans
; 0000 01D6         }
; 0000 01D7         if (permit==12)
_0x56:
	LDI  R30,LOW(12)
	CP   R30,R8
	BREQ PC+3
	JMP _0x57
; 0000 01D8         {
; 0000 01D9             ut=((long)twi_eeprom[0]<<8)+twi_eeprom[1];
	LDS  R30,_twi_eeprom
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN _twi_eeprom,1
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	STS  _ut,R30
	STS  _ut+1,R31
	STS  _ut+2,R22
	STS  _ut+3,R23
; 0000 01DA             x1=((ut-ac6)*ac5)>>15;
	LDS  R30,_ac6
	LDS  R31,_ac6+1
	LDS  R26,_ut
	LDS  R27,_ut+1
	LDS  R24,_ut+2
	LDS  R25,_ut+3
	CLR  R22
	CLR  R23
	CALL __SUBD21
	LDS  R30,_ac5
	LDS  R31,_ac5+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(15)
	CALL __ASRD12
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 01DB             x2=((long)mc<<11)/(x1+md);
	LDS  R26,_mc
	LDS  R27,_mc+1
	CALL __CWD2
	LDI  R30,LOW(11)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_md
	LDS  R31,_md+1
	LDS  R26,_x1
	LDS  R27,_x1+1
	LDS  R24,_x1+2
	LDS  R25,_x1+3
	CALL __CWD1
	CALL __ADDD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVD21
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 01DC             b5=x1+x2;
	LDS  R26,_x1
	LDS  R27,_x1+1
	LDS  R24,_x1+2
	LDS  R25,_x1+3
	CALL __ADDD12
	STS  _b5,R30
	STS  _b5+1,R31
	STS  _b5+2,R22
	STS  _b5+3,R23
; 0000 01DD             t=(b5+8)>>4;
	__ADDD1N 8
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(4)
	CALL __ASRD12
	STS  _t,R30
	STS  _t+1,R31
	STS  _t+2,R22
	STS  _t+3,R23
; 0000 01DE         }
; 0000 01DF         if (permit==13)
_0x57:
	LDI  R30,LOW(13)
	CP   R30,R8
	BREQ PC+3
	JMP _0x58
; 0000 01E0         {
; 0000 01E1             if (t<0)
	LDS  R26,_t+3
	TST  R26
	BRMI PC+3
	JMP _0x59
; 0000 01E2             {
; 0000 01E3                 t2s[0]='-';
	LDI  R30,LOW(45)
	STS  _t2s,R30
; 0000 01E4                 t1=-t;
	LDS  R30,_t
	LDS  R31,_t+1
	CALL __ANEGW1
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 01E5             }
; 0000 01E6             else
	RJMP _0x5A
_0x59:
; 0000 01E7             {
; 0000 01E8                 t2s[0]='+';
	LDI  R30,LOW(43)
	STS  _t2s,R30
; 0000 01E9                 t1=t;
	LDS  R30,_t
	LDS  R31,_t+1
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 01EA             }
_0x5A:
; 0000 01EB             temp=t1/100;
	LDS  R26,_t1
	LDS  R27,_t1+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R17,R30
; 0000 01EC             t2s[1]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _t2s,1
; 0000 01ED             t1-=temp*100;
	LDI  R30,LOW(100)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_t1
	LDS  R27,_t1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _t1,R26
	STS  _t1+1,R27
; 0000 01EE             temp=t1/10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R17,R30
; 0000 01EF             t2s[2]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _t2s,2
; 0000 01F0             t1-=temp*10;
	LDI  R30,LOW(10)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_t1
	LDS  R27,_t1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _t1,R26
	STS  _t1+1,R27
; 0000 01F1             t2s[4]=t1+'0';
	LDS  R30,_t1
	SUBI R30,-LOW(48)
	__PUTB1MN _t2s,4
; 0000 01F2         }
; 0000 01F3         if (permit==14)
_0x58:
	LDI  R30,LOW(14)
	CP   R30,R8
	BREQ PC+3
	JMP _0x5B
; 0000 01F4         {
; 0000 01F5             twi_adr[0]=0xF4;
	LDI  R30,LOW(244)
	STS  _twi_adr,R30
; 0000 01F6             twi_adr[1]=0x34;
	LDI  R30,LOW(52)
	__PUTB1MN _twi_adr,1
; 0000 01F7             //twi_adr[1]=0xF4;
; 0000 01F8             twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(_twi_adr)
	LDI  R31,HIGH(_twi_adr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _twi_master_trans
; 0000 01F9         }
; 0000 01FA         if (permit==17)
_0x5B:
	LDI  R30,LOW(17)
	CP   R30,R8
	BREQ PC+3
	JMP _0x5C
; 0000 01FB         {
; 0000 01FC             errorDHT=readDHT();
	CALL _readDHT
	CPI  R30,0
	BRNE _0x5D
	CBI  0x1E,1
	RJMP _0x5E
_0x5D:
	SBI  0x1E,1
_0x5E:
; 0000 01FD         }
; 0000 01FE         if (permit==18)
_0x5C:
	LDI  R30,LOW(18)
	CP   R30,R8
	BREQ PC+3
	JMP _0x5F
; 0000 01FF         {
; 0000 0200             if (dataDHT[0]+dataDHT[1]+dataDHT[2]+dataDHT[3]-dataDHT[4])
	LDS  R26,_dataDHT
	CLR  R27
	__GETB1MN _dataDHT,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _dataDHT,2
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _dataDHT,3
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _dataDHT,4
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	BRNE PC+3
	JMP _0x60
; 0000 0201                 errorDHT=0;
	CBI  0x1E,1
; 0000 0202             if (errorDHT)
_0x60:
	SBIS 0x1E,1
	RJMP _0x63
; 0000 0203             {
; 0000 0204                 v=dataDHT[0];
	LDS  R30,_dataDHT
	LDI  R31,0
	STS  _v,R30
	STS  _v+1,R31
; 0000 0205                 v<<=8;
	LDS  R31,_v
	LDI  R30,LOW(0)
	STS  _v,R30
	STS  _v+1,R31
; 0000 0206                 v+=dataDHT[1];
	__GETB1MN _dataDHT,1
	LDI  R31,0
	LDS  R26,_v
	LDS  R27,_v+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _v,R30
	STS  _v+1,R31
; 0000 0207                 t1=dataDHT[2];
	__GETB1MN _dataDHT,2
	LDI  R31,0
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 0208                 t1<<=8;
	LDS  R31,_t1
	LDI  R30,LOW(0)
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 0209                 t1+=dataDHT[3];
	__GETB1MN _dataDHT,3
	LDI  R31,0
	LDS  R26,_t1
	LDS  R27,_t1+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _t1,R30
	STS  _t1+1,R31
; 0000 020A                 vled=v;
	LDS  R30,_v
	LDS  R31,_v+1
	STS  _vled,R30
	STS  _vled+1,R31
; 0000 020B                 temp=v/100;
	LDS  R26,_v
	LDS  R27,_v+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 020C                 vs[0]=temp+'0';
	SUBI R30,-LOW(48)
	STS  _vs,R30
; 0000 020D                 v-=temp*100;
	LDI  R30,LOW(100)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_v
	LDS  R27,_v+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _v,R26
	STS  _v+1,R27
; 0000 020E                 temp=v/10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 020F                 vs[1]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _vs,1
; 0000 0210                 v-=temp*10;
	LDI  R30,LOW(10)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_v
	LDS  R27,_v+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _v,R26
	STS  _v+1,R27
; 0000 0211                 vs[3]=v+'0';
	LDS  R30,_v
	SUBI R30,-LOW(48)
	__PUTB1MN _vs,3
; 0000 0212                 if (t1&0x8000)
	__GETB1MN _t1,1
	ANDI R30,LOW(0x80)
	BRNE PC+3
	JMP _0x64
; 0000 0213                 {
; 0000 0214                     t1s[0]='-';
	LDI  R30,LOW(45)
	STS  _t1s,R30
; 0000 0215                     t1&=0x7fff;
	__ANDBMNN _t1,1,127
; 0000 0216                     t1--;
	LDI  R26,LOW(_t1)
	LDI  R27,HIGH(_t1)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0217                 }
; 0000 0218                 else
	RJMP _0x65
_0x64:
; 0000 0219                     t1s[0]='+';
	LDI  R30,LOW(43)
	STS  _t1s,R30
; 0000 021A                 temp=t1/100;
_0x65:
	LDS  R26,_t1
	LDS  R27,_t1+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R17,R30
; 0000 021B                 t1s[1]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _t1s,1
; 0000 021C                 t1-=temp*100;
	LDI  R30,LOW(100)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_t1
	LDS  R27,_t1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _t1,R26
	STS  _t1+1,R27
; 0000 021D                 temp=t1/10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R17,R30
; 0000 021E                 t1s[2]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _t1s,2
; 0000 021F                 t1-=temp*10;
	LDI  R30,LOW(10)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_t1
	LDS  R27,_t1+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _t1,R26
	STS  _t1+1,R27
; 0000 0220                 t1s[4]=t1+'0';
	LDS  R30,_t1
	SUBI R30,-LOW(48)
	__PUTB1MN _t1s,4
; 0000 0221             }
; 0000 0222             else
	RJMP _0x66
_0x63:
; 0000 0223             {
; 0000 0224                 t1s[1]='x';
	LDI  R30,LOW(120)
	__PUTB1MN _t1s,1
; 0000 0225                 t1s[2]='x';
	__PUTB1MN _t1s,2
; 0000 0226                 t1s[4]='x';
	__PUTB1MN _t1s,4
; 0000 0227             }
_0x66:
; 0000 0228         }
; 0000 0229         if (permit==21)
_0x5F:
	LDI  R30,LOW(21)
	CP   R30,R8
	BREQ PC+3
	JMP _0x67
; 0000 022A         {
; 0000 022B             twi_adr[0]=0xF6;
	LDI  R30,LOW(246)
	STS  _twi_adr,R30
; 0000 022C             twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,2);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(_twi_adr)
	LDI  R31,HIGH(_twi_adr)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_twi_eeprom)
	LDI  R31,HIGH(_twi_eeprom)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _twi_master_trans
; 0000 022D         }
; 0000 022E         if (permit==22)
_0x67:
	LDI  R30,LOW(22)
	CP   R30,R8
	BREQ PC+3
	JMP _0x68
; 0000 022F         {
; 0000 0230             pressure=((unsigned long)twi_eeprom[0]<<8)+twi_eeprom[1];
	LDS  R30,_twi_eeprom
	LDI  R31,0
	CALL __CWD1
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN _twi_eeprom,1
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	STS  _pressure,R30
	STS  _pressure+1,R31
	STS  _pressure+2,R22
	STS  _pressure+3,R23
; 0000 0231             //pressure=((long)twi_eeprom[0]<<16)+((long)twi_eeprom[1]<<8)+twi_eeprom[2];
; 0000 0232             b6 = b5 - 4000;
	LDS  R30,_b5
	LDS  R31,_b5+1
	LDS  R22,_b5+2
	LDS  R23,_b5+3
	__SUBD1N 4000
	STS  _b6,R30
	STS  _b6+1,R31
	STS  _b6+2,R22
	STS  _b6+3,R23
; 0000 0233 	        x1 = (b2 * ((b6 * b6) >> 12)) >> 11;
	LDS  R26,_b6
	LDS  R27,_b6+1
	LDS  R24,_b6+2
	LDS  R25,_b6+3
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(12)
	CALL __ASRD12
	LDS  R26,_b2
	LDS  R27,_b2+1
	CALL __CWD2
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(11)
	CALL __ASRD12
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 0234 	        x2 = ac2 * b6 >> 11;
	LDS  R30,_b6
	LDS  R31,_b6+1
	LDS  R22,_b6+2
	LDS  R23,_b6+3
	LDS  R26,_ac2
	LDS  R27,_ac2+1
	CALL __CWD2
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(11)
	CALL __ASRD12
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 0235 	        x3 = x1 + x2;
	LDS  R26,_x1
	LDS  R27,_x1+1
	LDS  R24,_x1+2
	LDS  R25,_x1+3
	CALL __ADDD12
	STS  _x3,R30
	STS  _x3+1,R31
	STS  _x3+2,R22
	STS  _x3+3,R23
; 0000 0236             b3= (long int)ac1<<2;
	LDS  R26,_ac1
	LDS  R27,_ac1+1
	CALL __CWD2
	LDI  R30,LOW(2)
	CALL __LSLD12
	STS  _b3,R30
	STS  _b3+1,R31
	STS  _b3+2,R22
	STS  _b3+3,R23
; 0000 0237             b3+=x3;
	LDS  R30,_x3
	LDS  R31,_x3+1
	LDS  R22,_x3+2
	LDS  R23,_x3+3
	LDS  R26,_b3
	LDS  R27,_b3+1
	LDS  R24,_b3+2
	LDS  R25,_b3+3
	CALL __ADDD12
	STS  _b3,R30
	STS  _b3+1,R31
	STS  _b3+2,R22
	STS  _b3+3,R23
; 0000 0238 
; 0000 0239             //b3<<=3;
; 0000 023A 
; 0000 023B             b3+=2;
	__ADDD1N 2
	STS  _b3,R30
	STS  _b3+1,R31
	STS  _b3+2,R22
	STS  _b3+3,R23
; 0000 023C             b3>>=2;
	LDS  R26,_b3
	LDS  R27,_b3+1
	LDS  R24,_b3+2
	LDS  R25,_b3+3
	LDI  R30,LOW(2)
	CALL __ASRD12
	STS  _b3,R30
	STS  _b3+1,R31
	STS  _b3+2,R22
	STS  _b3+3,R23
; 0000 023D 	        x1 = ac3 * b6;
	LDS  R30,_b6
	LDS  R31,_b6+1
	LDS  R22,_b6+2
	LDS  R23,_b6+3
	LDS  R26,_ac3
	LDS  R27,_ac3+1
	CALL __CWD2
	CALL __MULD12
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 023E             x1>>=13;
	LDS  R26,_x1
	LDS  R27,_x1+1
	LDS  R24,_x1+2
	LDS  R25,_x1+3
	LDI  R30,LOW(13)
	CALL __ASRD12
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 023F 	        x2 = (b1 * ((b6 * b6) >> 12)) >> 16;
	LDS  R30,_b6
	LDS  R31,_b6+1
	LDS  R22,_b6+2
	LDS  R23,_b6+3
	LDS  R26,_b6
	LDS  R27,_b6+1
	LDS  R24,_b6+2
	LDS  R25,_b6+3
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(12)
	CALL __ASRD12
	LDS  R26,_b1
	LDS  R27,_b1+1
	CALL __CWD2
	CALL __MULD12
	CALL __ASRD16
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 0240 	        x3 = ((x1 + x2) + 2) >> 2;
	LDS  R26,_x1
	LDS  R27,_x1+1
	LDS  R24,_x1+2
	LDS  R25,_x1+3
	CALL __ADDD12
	__ADDD1N 2
	CALL __ASRD1
	CALL __ASRD1
	STS  _x3,R30
	STS  _x3+1,R31
	STS  _x3+2,R22
	STS  _x3+3,R23
; 0000 0241 	        b4 = ac4 * (unsigned long) (x3 + 32768) >> 15;
	__ADDD1N 32768
	LDS  R26,_ac4
	LDS  R27,_ac4+1
	CLR  R24
	CLR  R25
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(15)
	CALL __LSRD12
	STS  _b4,R30
	STS  _b4+1,R31
	STS  _b4+2,R22
	STS  _b4+3,R23
; 0000 0242 	        b7 = (unsigned long) (pressure - b3) * 50000;
	LDS  R26,_b3
	LDS  R27,_b3+1
	LDS  R24,_b3+2
	LDS  R25,_b3+3
	LDS  R30,_pressure
	LDS  R31,_pressure+1
	LDS  R22,_pressure+2
	LDS  R23,_pressure+3
	CALL __SUBD12
	__GETD2N 0xC350
	CALL __MULD12U
	STS  _b7,R30
	STS  _b7+1,R31
	STS  _b7+2,R22
	STS  _b7+3,R23
; 0000 0243             //b7 = ((unsigned long)pressure - b3) * (50000>>3);
; 0000 0244 		    if (b7 < 0x80000000)
	LDS  R26,_b7
	LDS  R27,_b7+1
	LDS  R24,_b7+2
	LDS  R25,_b7+3
	__CPD2N 0x80000000
	BRLO PC+3
	JMP _0x69
; 0000 0245 		        p = (b7 << 1) / b4;
	LDS  R30,_b7
	LDS  R31,_b7+1
	LDS  R22,_b7+2
	LDS  R23,_b7+3
	CALL __LSLD1
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_b4
	LDS  R31,_b4+1
	LDS  R22,_b4+2
	LDS  R23,_b4+3
	CALL __DIVD21U
	STS  _p,R30
	STS  _p+1,R31
	STS  _p+2,R22
	STS  _p+3,R23
; 0000 0246         	else
	RJMP _0x6A
_0x69:
; 0000 0247 		        p = (b7 / b4) << 1;
	LDS  R30,_b4
	LDS  R31,_b4+1
	LDS  R22,_b4+2
	LDS  R23,_b4+3
	LDS  R26,_b7
	LDS  R27,_b7+1
	LDS  R24,_b7+2
	LDS  R25,_b7+3
	CALL __DIVD21U
	CALL __LSLD1
	STS  _p,R30
	STS  _p+1,R31
	STS  _p+2,R22
	STS  _p+3,R23
; 0000 0248 	        x1 = (p >> 8) * (p >> 8);
_0x6A:
	LDS  R26,_p
	LDS  R27,_p+1
	LDS  R24,_p+2
	LDS  R25,_p+3
	LDI  R30,LOW(8)
	CALL __ASRD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(8)
	CALL __ASRD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULD12
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 0249 	        x1 = (x1 * 3038) >> 16;
	__GETD2N 0xBDE
	CALL __MULD12
	CALL __ASRD16
	STS  _x1,R30
	STS  _x1+1,R31
	STS  _x1+2,R22
	STS  _x1+3,R23
; 0000 024A 	        x2 = (-7357 * p) >> 16;
	LDS  R30,_p
	LDS  R31,_p+1
	LDS  R22,_p+2
	LDS  R23,_p+3
	__GETD2N 0xFFFFE343
	CALL __MULD12
	CALL __ASRD16
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 024B             x2+=x1;
	LDS  R30,_x1
	LDS  R31,_x1+1
	LDS  R22,_x1+2
	LDS  R23,_x1+3
	LDS  R26,_x2
	LDS  R27,_x2+1
	LDS  R24,_x2+2
	LDS  R25,_x2+3
	CALL __ADDD12
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 024C             x2+=3791;
	__ADDD1N 3791
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 024D             x2>>=4;
	LDS  R26,_x2
	LDS  R27,_x2+1
	LDS  R24,_x2+2
	LDS  R25,_x2+3
	LDI  R30,LOW(4)
	CALL __ASRD12
	STS  _x2,R30
	STS  _x2+1,R31
	STS  _x2+2,R22
	STS  _x2+3,R23
; 0000 024E 	        pressure = p + x2;
	LDS  R26,_p
	LDS  R27,_p+1
	LDS  R24,_p+2
	LDS  R25,_p+3
	CALL __ADDD12
	STS  _pressure,R30
	STS  _pressure+1,R31
	STS  _pressure+2,R22
	STS  _pressure+3,R23
; 0000 024F            /* if (pressure>92500)
; 0000 0250             {
; 0000 0251             dataLed[3]=0x25;
; 0000 0252             dataLed[4]=0x50;
; 0000 0253             dataLed[5]=0x00;
; 0000 0254             }   */
; 0000 0255         }
; 0000 0256         if(permit==22)
_0x68:
	LDI  R30,LOW(22)
	CP   R30,R8
	BREQ PC+3
	JMP _0x6B
; 0000 0257         {
; 0000 0258         //P
; 0000 0259             dataLed[0]=0x00;
	LDI  R30,LOW(0)
	STS  _dataLed,R30
; 0000 025A             dataLed[1]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,1
; 0000 025B             dataLed[2]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,2
; 0000 025C             if (pressure>=92500)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x16954
	BRGE PC+3
	JMP _0x6C
; 0000 025D             {
; 0000 025E             dataLed[3]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,3
; 0000 025F             dataLed[4]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,4
; 0000 0260             dataLed[5]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,5
; 0000 0261             }else{dataLed[3]=0x00;
	RJMP _0x6D
_0x6C:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,3
; 0000 0262             dataLed[4]=0x00;
	__PUTB1MN _dataLed,4
; 0000 0263             dataLed[5]=0x00;}
	__PUTB1MN _dataLed,5
_0x6D:
; 0000 0264             if (pressure>=95000)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x17318
	BRGE PC+3
	JMP _0x6E
; 0000 0265             {
; 0000 0266             dataLed[6]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,6
; 0000 0267             dataLed[7]=0x50;
	__PUTB1MN _dataLed,7
; 0000 0268             dataLed[8]=0x00;}else{dataLed[6]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,8
	RJMP _0x6F
_0x6E:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,6
; 0000 0269             dataLed[7]=0x00;
	__PUTB1MN _dataLed,7
; 0000 026A             dataLed[8]=0x00;}
	__PUTB1MN _dataLed,8
_0x6F:
; 0000 026B             if (pressure>=100000)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x186A0
	BRGE PC+3
	JMP _0x70
; 0000 026C             {
; 0000 026D             dataLed[9]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,9
; 0000 026E             dataLed[10]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,10
; 0000 026F             dataLed[11]=0x00;}else{dataLed[9]=0x00;
	__PUTB1MN _dataLed,11
	RJMP _0x71
_0x70:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,9
; 0000 0270             dataLed[10]=0x00;
	__PUTB1MN _dataLed,10
; 0000 0271             dataLed[11]=0x00;}
	__PUTB1MN _dataLed,11
_0x71:
; 0000 0272             if (pressure>=102500)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x19064
	BRGE PC+3
	JMP _0x72
; 0000 0273             {
; 0000 0274             dataLed[12]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,12
; 0000 0275             dataLed[13]=0x0;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,13
; 0000 0276             dataLed[14]=0x00;}else{dataLed[12]=0x00;
	__PUTB1MN _dataLed,14
	RJMP _0x73
_0x72:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,12
; 0000 0277             dataLed[13]=0x00;
	__PUTB1MN _dataLed,13
; 0000 0278             dataLed[14]=0x00;}
	__PUTB1MN _dataLed,14
_0x73:
; 0000 0279             if (pressure>=105000)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x19A28
	BRGE PC+3
	JMP _0x74
; 0000 027A             {
; 0000 027B             dataLed[15]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,15
; 0000 027C             dataLed[16]=0x50;
	__PUTB1MN _dataLed,16
; 0000 027D             dataLed[17]=0x00;}else{dataLed[15]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,17
	RJMP _0x75
_0x74:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,15
; 0000 027E             dataLed[16]=0x00;
	__PUTB1MN _dataLed,16
; 0000 027F             dataLed[17]=0x00;}
	__PUTB1MN _dataLed,17
_0x75:
; 0000 0280             if (pressure>=107500)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x1A3EC
	BRGE PC+3
	JMP _0x76
; 0000 0281             {
; 0000 0282             dataLed[18]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,18
; 0000 0283             dataLed[19]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,19
; 0000 0284             dataLed[20]=0x00;}else{dataLed[18]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,20
	RJMP _0x77
_0x76:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,18
; 0000 0285             dataLed[19]=0x00;
	__PUTB1MN _dataLed,19
; 0000 0286             dataLed[20]=0x00;}
	__PUTB1MN _dataLed,20
_0x77:
; 0000 0287             if(pressure>=110000)
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__CPD2N 0x1ADB0
	BRGE PC+3
	JMP _0x78
; 0000 0288             {
; 0000 0289             dataLed[21]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,21
; 0000 028A             dataLed[22]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,22
; 0000 028B             dataLed[23]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,23
; 0000 028C             }else{dataLed[21]=0x00;
	RJMP _0x79
_0x78:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,21
; 0000 028D             dataLed[22]=0x00;
	__PUTB1MN _dataLed,22
; 0000 028E             dataLed[23]=0x00;}
	__PUTB1MN _dataLed,23
_0x79:
; 0000 028F 
; 0000 0290             //T
; 0000 0291             dataLed[24]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,24
; 0000 0292             dataLed[25]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,25
; 0000 0293             dataLed[26]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,26
; 0000 0294             if (t>=-100)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0xFFFFFF9C
	BRGE PC+3
	JMP _0x7A
; 0000 0295             {
; 0000 0296             dataLed[27]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,27
; 0000 0297             dataLed[28]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,28
; 0000 0298             dataLed[29]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,29
; 0000 0299             }else{dataLed[27]=0x00;
	RJMP _0x7B
_0x7A:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,27
; 0000 029A             dataLed[28]=0x00;
	__PUTB1MN _dataLed,28
; 0000 029B             dataLed[29]=0x00;}
	__PUTB1MN _dataLed,29
_0x7B:
; 0000 029C             if (t>=0)
	LDS  R26,_t+3
	TST  R26
	BRPL PC+3
	JMP _0x7C
; 0000 029D             {
; 0000 029E             dataLed[30]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,30
; 0000 029F             dataLed[31]=0x50;
	__PUTB1MN _dataLed,31
; 0000 02A0             dataLed[32]=0x00;}else{dataLed[30]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,32
	RJMP _0x7D
_0x7C:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,30
; 0000 02A1             dataLed[31]=0x00;
	__PUTB1MN _dataLed,31
; 0000 02A2             dataLed[32]=0x00;}
	__PUTB1MN _dataLed,32
_0x7D:
; 0000 02A3             if (t>=100)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0x64
	BRGE PC+3
	JMP _0x7E
; 0000 02A4             {
; 0000 02A5             dataLed[33]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,33
; 0000 02A6             dataLed[34]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,34
; 0000 02A7             dataLed[35]=0x00;}else{dataLed[33]=0x00;
	__PUTB1MN _dataLed,35
	RJMP _0x7F
_0x7E:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,33
; 0000 02A8             dataLed[34]=0x00;
	__PUTB1MN _dataLed,34
; 0000 02A9             dataLed[35]=0x00;}
	__PUTB1MN _dataLed,35
_0x7F:
; 0000 02AA             if (t>=200)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0xC8
	BRGE PC+3
	JMP _0x80
; 0000 02AB             {
; 0000 02AC             dataLed[36]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,36
; 0000 02AD             dataLed[37]=0x0;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,37
; 0000 02AE             dataLed[38]=0x00;}else{dataLed[36]=0x00;
	__PUTB1MN _dataLed,38
	RJMP _0x81
_0x80:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,36
; 0000 02AF             dataLed[37]=0x00;
	__PUTB1MN _dataLed,37
; 0000 02B0             dataLed[38]=0x00;}
	__PUTB1MN _dataLed,38
_0x81:
; 0000 02B1             if (t>=300)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0x12C
	BRGE PC+3
	JMP _0x82
; 0000 02B2             {
; 0000 02B3             dataLed[39]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,39
; 0000 02B4             dataLed[40]=0x50;
	__PUTB1MN _dataLed,40
; 0000 02B5             dataLed[41]=0x00;}else{dataLed[39]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,41
	RJMP _0x83
_0x82:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,39
; 0000 02B6             dataLed[40]=0x00;
	__PUTB1MN _dataLed,40
; 0000 02B7             dataLed[41]=0x00;}
	__PUTB1MN _dataLed,41
_0x83:
; 0000 02B8             if (t>=400)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0x190
	BRGE PC+3
	JMP _0x84
; 0000 02B9             {
; 0000 02BA             dataLed[42]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,42
; 0000 02BB             dataLed[43]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,43
; 0000 02BC             dataLed[44]=0x00;}else{dataLed[42]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,44
	RJMP _0x85
_0x84:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,42
; 0000 02BD             dataLed[43]=0x00;
	__PUTB1MN _dataLed,43
; 0000 02BE             dataLed[44]=0x00;}
	__PUTB1MN _dataLed,44
_0x85:
; 0000 02BF             if(t>=500)
	LDS  R26,_t
	LDS  R27,_t+1
	LDS  R24,_t+2
	LDS  R25,_t+3
	__CPD2N 0x1F4
	BRGE PC+3
	JMP _0x86
; 0000 02C0             {
; 0000 02C1             dataLed[45]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,45
; 0000 02C2             dataLed[46]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,46
; 0000 02C3             dataLed[47]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,47
; 0000 02C4             }else{dataLed[45]=0x00;
	RJMP _0x87
_0x86:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,45
; 0000 02C5             dataLed[46]=0x00;
	__PUTB1MN _dataLed,46
; 0000 02C6             dataLed[47]=0x00;}
	__PUTB1MN _dataLed,47
_0x87:
; 0000 02C7 
; 0000 02C8              //CO2
; 0000 02C9             dataLed[48]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,48
; 0000 02CA             dataLed[49]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,49
; 0000 02CB             dataLed[50]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,50
; 0000 02CC             if (co2led>=400)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x88
; 0000 02CD             {
; 0000 02CE             dataLed[51]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,51
; 0000 02CF             dataLed[52]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,52
; 0000 02D0             dataLed[53]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,53
; 0000 02D1             }else{dataLed[51]=0x00;
	RJMP _0x89
_0x88:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,51
; 0000 02D2             dataLed[52]=0x00;
	__PUTB1MN _dataLed,52
; 0000 02D3             dataLed[53]=0x00;}
	__PUTB1MN _dataLed,53
_0x89:
; 0000 02D4             if (co2led>=600)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x8A
; 0000 02D5             {
; 0000 02D6             dataLed[54]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,54
; 0000 02D7             dataLed[55]=0x50;
	__PUTB1MN _dataLed,55
; 0000 02D8             dataLed[56]=0x00;}else{dataLed[54]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,56
	RJMP _0x8B
_0x8A:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,54
; 0000 02D9             dataLed[55]=0x00;
	__PUTB1MN _dataLed,55
; 0000 02DA             dataLed[56]=0x00;}
	__PUTB1MN _dataLed,56
_0x8B:
; 0000 02DB             if (co2led>=800)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x320)
	LDI  R30,HIGH(0x320)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x8C
; 0000 02DC             {
; 0000 02DD             dataLed[57]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,57
; 0000 02DE             dataLed[58]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,58
; 0000 02DF             dataLed[59]=0x00;}else{dataLed[57]=0x00;
	__PUTB1MN _dataLed,59
	RJMP _0x8D
_0x8C:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,57
; 0000 02E0             dataLed[58]=0x00;
	__PUTB1MN _dataLed,58
; 0000 02E1             dataLed[59]=0x00;}
	__PUTB1MN _dataLed,59
_0x8D:
; 0000 02E2             if (co2led>=1000)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x8E
; 0000 02E3             {
; 0000 02E4             dataLed[60]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,60
; 0000 02E5             dataLed[61]=0x0;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,61
; 0000 02E6             dataLed[62]=0x00;}else{dataLed[60]=0x00;
	__PUTB1MN _dataLed,62
	RJMP _0x8F
_0x8E:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,60
; 0000 02E7             dataLed[61]=0x00;
	__PUTB1MN _dataLed,61
; 0000 02E8             dataLed[62]=0x00;}
	__PUTB1MN _dataLed,62
_0x8F:
; 0000 02E9             if (co2led>=1200)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x90
; 0000 02EA             {
; 0000 02EB             dataLed[63]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,63
; 0000 02EC             dataLed[64]=0x50;
	__PUTB1MN _dataLed,64
; 0000 02ED             dataLed[65]=0x00;}else{dataLed[63]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,65
	RJMP _0x91
_0x90:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,63
; 0000 02EE             dataLed[64]=0x00;
	__PUTB1MN _dataLed,64
; 0000 02EF             dataLed[65]=0x00;}
	__PUTB1MN _dataLed,65
_0x91:
; 0000 02F0             if (co2led>=1400)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x578)
	LDI  R30,HIGH(0x578)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x92
; 0000 02F1             {
; 0000 02F2             dataLed[66]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,66
; 0000 02F3             dataLed[67]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,67
; 0000 02F4             dataLed[68]=0x00;}else{dataLed[66]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,68
	RJMP _0x93
_0x92:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,66
; 0000 02F5             dataLed[67]=0x00;
	__PUTB1MN _dataLed,67
; 0000 02F6             dataLed[68]=0x00;}
	__PUTB1MN _dataLed,68
_0x93:
; 0000 02F7             if(co2led>=1600)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x640)
	LDI  R30,HIGH(0x640)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x94
; 0000 02F8             {
; 0000 02F9             dataLed[69]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,69
; 0000 02FA             dataLed[70]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,70
; 0000 02FB             dataLed[71]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,71
; 0000 02FC             }else{dataLed[69]=0x00;
	RJMP _0x95
_0x94:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,69
; 0000 02FD             dataLed[70]=0x00;
	__PUTB1MN _dataLed,70
; 0000 02FE             dataLed[71]=0x00;}
	__PUTB1MN _dataLed,71
_0x95:
; 0000 02FF 
; 0000 0300             //H
; 0000 0301             dataLed[72]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,72
; 0000 0302             dataLed[73]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,73
; 0000 0303             dataLed[74]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,74
; 0000 0304             if (vled>=120)
	LDS  R26,_vled
	LDS  R27,_vled+1
	CPI  R26,LOW(0x78)
	LDI  R30,HIGH(0x78)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x96
; 0000 0305             {
; 0000 0306             dataLed[75]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,75
; 0000 0307             dataLed[76]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,76
; 0000 0308             dataLed[77]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,77
; 0000 0309             }else{dataLed[75]=0x00;
	RJMP _0x97
_0x96:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,75
; 0000 030A             dataLed[76]=0x00;
	__PUTB1MN _dataLed,76
; 0000 030B             dataLed[77]=0x00;}
	__PUTB1MN _dataLed,77
_0x97:
; 0000 030C             if (vled>=250)
	LDS  R26,_vled
	LDS  R27,_vled+1
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x98
; 0000 030D             {
; 0000 030E             dataLed[78]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,78
; 0000 030F             dataLed[79]=0x50;
	__PUTB1MN _dataLed,79
; 0000 0310             dataLed[80]=0x00;}else{dataLed[78]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,80
	RJMP _0x99
_0x98:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,78
; 0000 0311             dataLed[79]=0x00;
	__PUTB1MN _dataLed,79
; 0000 0312             dataLed[80]=0x00;}
	__PUTB1MN _dataLed,80
_0x99:
; 0000 0313             if (vled>=370)
	LDS  R26,_vled
	LDS  R27,_vled+1
	CPI  R26,LOW(0x172)
	LDI  R30,HIGH(0x172)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x9A
; 0000 0314             {
; 0000 0315             dataLed[81]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,81
; 0000 0316             dataLed[82]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,82
; 0000 0317             dataLed[83]=0x00;}else{dataLed[81]=0x00;
	__PUTB1MN _dataLed,83
	RJMP _0x9B
_0x9A:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,81
; 0000 0318             dataLed[82]=0x00;
	__PUTB1MN _dataLed,82
; 0000 0319             dataLed[83]=0x00;}
	__PUTB1MN _dataLed,83
_0x9B:
; 0000 031A             if (vled>=500)
	LDS  R26,_vled
	LDS  R27,_vled+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x9C
; 0000 031B             {
; 0000 031C             dataLed[84]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,84
; 0000 031D             dataLed[85]=0x0;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,85
; 0000 031E             dataLed[86]=0x00;}else{dataLed[84]=0x00;
	__PUTB1MN _dataLed,86
	RJMP _0x9D
_0x9C:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,84
; 0000 031F             dataLed[85]=0x00;
	__PUTB1MN _dataLed,85
; 0000 0320             dataLed[86]=0x00;}
	__PUTB1MN _dataLed,86
_0x9D:
; 0000 0321             if (vled>=620)
	LDS  R26,_vled
	LDS  R27,_vled+1
	CPI  R26,LOW(0x26C)
	LDI  R30,HIGH(0x26C)
	CPC  R27,R30
	BRSH PC+3
	JMP _0x9E
; 0000 0322             {
; 0000 0323             dataLed[87]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,87
; 0000 0324             dataLed[88]=0x50;
	__PUTB1MN _dataLed,88
; 0000 0325             dataLed[89]=0x00;}else{dataLed[87]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,89
	RJMP _0x9F
_0x9E:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,87
; 0000 0326             dataLed[88]=0x00;
	__PUTB1MN _dataLed,88
; 0000 0327             dataLed[89]=0x00;}
	__PUTB1MN _dataLed,89
_0x9F:
; 0000 0328             if (co2led>=800)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x320)
	LDI  R30,HIGH(0x320)
	CPC  R27,R30
	BRSH PC+3
	JMP _0xA0
; 0000 0329             {
; 0000 032A             dataLed[90]=0x25;
	LDI  R30,LOW(37)
	__PUTB1MN _dataLed,90
; 0000 032B             dataLed[91]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,91
; 0000 032C             dataLed[92]=0x00;}else{dataLed[90]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,92
	RJMP _0xA1
_0xA0:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,90
; 0000 032D             dataLed[91]=0x00;
	__PUTB1MN _dataLed,91
; 0000 032E             dataLed[92]=0x00;}
	__PUTB1MN _dataLed,92
_0xA1:
; 0000 032F             if(co2led==100)
	LDS  R26,_co2led
	LDS  R27,_co2led+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BREQ PC+3
	JMP _0xA2
; 0000 0330             {
; 0000 0331             dataLed[93]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,93
; 0000 0332             dataLed[94]=0x50;
	LDI  R30,LOW(80)
	__PUTB1MN _dataLed,94
; 0000 0333             dataLed[95]=0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,95
; 0000 0334             }else{dataLed[93]=0x00;
	RJMP _0xA3
_0xA2:
	LDI  R30,LOW(0)
	__PUTB1MN _dataLed,93
; 0000 0335             dataLed[94]=0x00;
	__PUTB1MN _dataLed,94
; 0000 0336             dataLed[95]=0x00;}
	__PUTB1MN _dataLed,95
_0xA3:
; 0000 0337 
; 0000 0338              dataLed[0]=dataLed[0];
	LDS  R30,_dataLed
	STS  _dataLed,R30
; 0000 0339         asmSendData(96);
	LDI  R26,LOW(96)
	CALL _asmSendData
; 0000 033A              }
; 0000 033B         if (permit==24)
_0x6B:
	LDI  R30,LOW(24)
	CP   R30,R8
	BREQ PC+3
	JMP _0xA4
; 0000 033C         {
; 0000 033D             temp=pressure/100000;
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__GETD1N 0x186A0
	CALL __DIVD21
	MOV  R17,R30
; 0000 033E             ps[0]=temp+'0';
	SUBI R30,-LOW(48)
	STS  _ps,R30
; 0000 033F             pressure-=(unsigned long int)temp*100000;
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x186A0
	CALL __MULD12U
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	CALL __SUBD21
	STS  _pressure,R26
	STS  _pressure+1,R27
	STS  _pressure+2,R24
	STS  _pressure+3,R25
; 0000 0340             temp=pressure/10000;
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__GETD1N 0x2710
	CALL __DIVD21
	MOV  R17,R30
; 0000 0341             ps[1]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _ps,1
; 0000 0342             pressure-=(unsigned long int)temp*10000;
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x2710
	CALL __MULD12U
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	CALL __SUBD21
	STS  _pressure,R26
	STS  _pressure+1,R27
	STS  _pressure+2,R24
	STS  _pressure+3,R25
; 0000 0343             temp=pressure/1000;
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__GETD1N 0x3E8
	CALL __DIVD21
	MOV  R17,R30
; 0000 0344             ps[2]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _ps,2
; 0000 0345             pressure-=temp*1000;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	CALL __CWD1
	CALL __SUBD21
	STS  _pressure,R26
	STS  _pressure+1,R27
	STS  _pressure+2,R24
	STS  _pressure+3,R25
; 0000 0346             temp=pressure/100;
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__GETD1N 0x64
	CALL __DIVD21
	MOV  R17,R30
; 0000 0347             ps[4]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _ps,4
; 0000 0348             pressure-=temp*100;
	LDI  R30,LOW(100)
	MUL  R30,R17
	MOVW R30,R0
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	CALL __CWD1
	CALL __SUBD21
	STS  _pressure,R26
	STS  _pressure+1,R27
	STS  _pressure+2,R24
	STS  _pressure+3,R25
; 0000 0349             temp=pressure/10;
	LDS  R26,_pressure
	LDS  R27,_pressure+1
	LDS  R24,_pressure+2
	LDS  R25,_pressure+3
	__GETD1N 0xA
	CALL __DIVD21
	MOV  R17,R30
; 0000 034A             ps[5]=temp+'0';
	SUBI R30,-LOW(48)
	__PUTB1MN _ps,5
; 0000 034B         }
; 0000 034C         if (Run)
_0xA4:
	SBIS 0x1E,3
	RJMP _0xA5
; 0000 034D         {
; 0000 034E             if (permit==25)
	LDI  R30,LOW(25)
	CP   R30,R8
	BREQ PC+3
	JMP _0xA6
; 0000 034F             {
; 0000 0350                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 0351                 txBuffer[txWrIndex++]='P';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(80)
	STD  Z+0,R26
; 0000 0352                 temp=0;
	LDI  R17,LOW(0)
; 0000 0353                 while (ps[temp])
_0xA7:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ps)
	SBCI R31,HIGH(-_ps)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0xA9
; 0000 0354                 {
; 0000 0355                     txBuffer[txWrIndex++]=ps[temp++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_ps)
	SBCI R31,HIGH(-_ps)
	LD   R30,Z
	ST   X,R30
; 0000 0356                 }
	RJMP _0xA7
_0xA9:
; 0000 0357                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 0358                 SetBit(UCSR0B,UDRIE0);
	LDS  R30,193
	ORI  R30,0x20
	STS  193,R30
; 0000 0359             }
; 0000 035A             if (permit==27)
_0xA6:
	LDI  R30,LOW(27)
	CP   R30,R8
	BREQ PC+3
	JMP _0xAA
; 0000 035B             {
; 0000 035C                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 035D                 txBuffer[txWrIndex++]='T';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(84)
	STD  Z+0,R26
; 0000 035E                 temp=0;
	LDI  R17,LOW(0)
; 0000 035F                 if (Sw)
	SBIS 0x1E,2
	RJMP _0xAB
; 0000 0360                 {
; 0000 0361                     while (t1s[temp])
_0xAC:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_t1s)
	SBCI R31,HIGH(-_t1s)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0xAE
; 0000 0362                     {
; 0000 0363                         txBuffer[txWrIndex++]=t1s[temp++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_t1s)
	SBCI R31,HIGH(-_t1s)
	LD   R30,Z
	ST   X,R30
; 0000 0364                     }
	RJMP _0xAC
_0xAE:
; 0000 0365                 }
; 0000 0366                 else
	RJMP _0xAF
_0xAB:
; 0000 0367                 {
; 0000 0368                     while (t2s[temp])
_0xB0:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_t2s)
	SBCI R31,HIGH(-_t2s)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0xB2
; 0000 0369                     {
; 0000 036A                         txBuffer[txWrIndex++]=t2s[temp++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_t2s)
	SBCI R31,HIGH(-_t2s)
	LD   R30,Z
	ST   X,R30
; 0000 036B                     }
	RJMP _0xB0
_0xB2:
; 0000 036C                 }
_0xAF:
; 0000 036D                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 036E                 SetBit(UCSR0B,UDRIE0);
	LDS  R30,193
	ORI  R30,0x20
	STS  193,R30
; 0000 036F             }
; 0000 0370             if (permit==29)
_0xAA:
	LDI  R30,LOW(29)
	CP   R30,R8
	BREQ PC+3
	JMP _0xB3
; 0000 0371             {
; 0000 0372                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 0373                 txBuffer[txWrIndex++]='V';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(86)
	STD  Z+0,R26
; 0000 0374                 temp=0;
	LDI  R17,LOW(0)
; 0000 0375                 while (vs[temp])
_0xB4:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_vs)
	SBCI R31,HIGH(-_vs)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0xB6
; 0000 0376                 {
; 0000 0377                     txBuffer[txWrIndex++]=vs[temp++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_vs)
	SBCI R31,HIGH(-_vs)
	LD   R30,Z
	ST   X,R30
; 0000 0378                 }
	RJMP _0xB4
_0xB6:
; 0000 0379                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 037A                 SetBit(UCSR0B,UDRIE0);
	LDS  R30,193
	ORI  R30,0x20
	STS  193,R30
; 0000 037B             }
; 0000 037C             if (permit==30)
_0xB3:
	LDI  R30,LOW(30)
	CP   R30,R8
	BREQ PC+3
	JMP _0xB7
; 0000 037D             {
; 0000 037E                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 037F                 txBuffer[txWrIndex++]='N';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(78)
	STD  Z+0,R26
; 0000 0380                 temp=0;
	LDI  R17,LOW(0)
; 0000 0381                 while (co2s[temp])
_0xB8:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_co2s)
	SBCI R31,HIGH(-_co2s)
	LD   R30,Z
	CPI  R30,0
	BRNE PC+3
	JMP _0xBA
; 0000 0382                 {
; 0000 0383                     txBuffer[txWrIndex++]=co2s[temp++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_co2s)
	SBCI R31,HIGH(-_co2s)
	LD   R30,Z
	ST   X,R30
; 0000 0384                 }
	RJMP _0xB8
_0xBA:
; 0000 0385                 txBuffer[txWrIndex++]='*';
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LDI  R26,LOW(42)
	STD  Z+0,R26
; 0000 0386                 SetBit(UCSR0B,UDRIE0);
	LDS  R30,193
	ORI  R30,0x20
	STS  193,R30
; 0000 0387             }
; 0000 0388         }
_0xB7:
; 0000 0389         if (permit==31)
_0xA5:
	LDI  R30,LOW(31)
	CP   R30,R8
	BREQ PC+3
	JMP _0xBB
; 0000 038A         {
; 0000 038B             lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 038C             if (Sw)
	SBIS 0x1E,2
	RJMP _0xBC
; 0000 038D                 lcd_puts(t1s);
	LDI  R26,LOW(_t1s)
	LDI  R27,HIGH(_t1s)
	CALL _lcd_puts
; 0000 038E             else
	RJMP _0xBD
_0xBC:
; 0000 038F                 lcd_puts(t2s);
	LDI  R26,LOW(_t2s)
	LDI  R27,HIGH(_t2s)
	CALL _lcd_puts
; 0000 0390             lcd_gotoxy(7,0);
_0xBD:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0391             lcd_puts(ps);
	LDI  R26,LOW(_ps)
	LDI  R27,HIGH(_ps)
	CALL _lcd_puts
; 0000 0392             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0393             lcd_puts(vs);
	LDI  R26,LOW(_vs)
	LDI  R27,HIGH(_vs)
	CALL _lcd_puts
; 0000 0394             lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0395             lcd_puts(co2s);
	LDI  R26,LOW(_co2s)
	LDI  R27,HIGH(_co2s)
	CALL _lcd_puts
; 0000 0396             permit=0;
	CLR  R8
; 0000 0397             pressure=0;
	LDI  R30,LOW(0)
	STS  _pressure,R30
	STS  _pressure+1,R30
	STS  _pressure+2,R30
	STS  _pressure+3,R30
; 0000 0398         }
; 0000 0399 
; 0000 039A         while(timerEnd){};
_0xBB:
_0xBE:
	SBIS 0x1E,0
	RJMP _0xC0
	RJMP _0xBE
_0xC0:
; 0000 039B     }
	JMP  _0x48
_0x4A:
; 0000 039C }
_0xC1:
	RJMP _0xC1
; .FEND

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
	ADIW R28,4
	RET
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD2S 6
	CALL __CPD02
	BRGE PC+3
	JMP _0x200000C
	__GETD1N 0xFF7FFFFF
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_0x200000C:
	__GETD1S 6
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	__PUTD1S 6
	__GETD2S 6
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRLO PC+3
	JMP _0x200000D
	__GETD1S 6
	CALL __ADDF12
	__PUTD1S 6
	__SUBWRN 16,17,1
_0x200000D:
	__GETD1S 6
	__GETD2N 0x3F800000
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 6
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1S 6
	__GETD2S 6
	CALL __MULF12
	__PUTD1S 2
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2S 6
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 2
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	__GETD2S 10
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRLO PC+3
	JMP _0x200000F
	__GETD1N 0x0
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_0x200000F:
	__GETD1S 10
	CALL __CPD10
	BREQ PC+3
	JMP _0x2000010
	__GETD1N 0x3F800000
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_0x2000010:
	__GETD2S 10
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000011
	__GETD1N 0x7F7FFFFF
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_0x2000011:
	__GETD2S 10
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	__GETD2S 10
	CALL _floor
	CALL __CFD1
	MOVW R16,R30
	__GETD2S 10
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 6
	__GETD2S 6
	CALL __MULF12
	__PUTD1S 2
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	__GETD2S 6
	CALL __MULF12
	__PUTD1S 6
	__GETD1S 2
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	__GETD1S 6
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 6
	__GETD1S 2
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	__GETD1S 8
	CALL __CPD10
	BREQ PC+3
	JMP _0x2000012
	__GETD1N 0x0
	ADIW R28,12
	RET
_0x2000012:
	__GETD2S 8
	CALL __CPD02
	BRLT PC+3
	JMP _0x2000013
	__GETD1S 4
	CALL __CPD10
	BREQ PC+3
	JMP _0x2000014
	__GETD1N 0x3F800000
	ADIW R28,12
	RET
_0x2000014:
	__GETD2S 8
	CALL _log
	__GETD2S 4
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _exp
	ADIW R28,12
	RET
_0x2000013:
	__GETD1S 4
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL __GETD1S0
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 4
	CALL __CPD12
	BRNE PC+3
	JMP _0x2000015
	__GETD1N 0x0
	ADIW R28,12
	RET
_0x2000015:
	__GETD1S 8
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _log
	__GETD2S 4
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ PC+3
	JMP _0x2000016
	__GETD1S 8
	ADIW R28,12
	RET
_0x2000016:
	__GETD1S 8
	CALL __ANEGF1
	ADIW R28,12
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0xB,R30
	__DELAY_USB 27
	SBI  0x5,2
	__DELAY_USB 27
	CBI  0x5,2
	__DELAY_USB 27
	ADIW R28,1
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	CALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE PC+3
	JMP _0x2020005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO PC+3
	JMP _0x2020005
	RJMP _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	CALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ PC+3
	JMP _0x2020007
	ADIW R28,1
	RET
_0x2020007:
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x5,0
	LD   R26,Y
	CALL __lcd_write_data
	CBI  0x5,0
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x202000A
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x202000D
	MOV  R26,R17
	CALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0xA
	ORI  R30,LOW(0xF0)
	OUT  0xA,R30
	SBI  0x4,2
	SBI  0x4,0
	SBI  0x4,1
	CBI  0x5,2
	CBI  0x5,0
	CBI  0x5,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(32)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(40)
	CALL __lcd_write_data
	LDI  R26,LOW(4)
	CALL __lcd_write_data
	LDI  R26,LOW(133)
	CALL __lcd_write_data
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_master_init:
; .FSTART _twi_master_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x1E,7
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDI  R30,LOW(0)
	STS  _twi_slave_rx_handler_G102,R30
	STS  _twi_slave_rx_handler_G102+1,R30
	STS  _twi_slave_tx_handler_G102,R30
	STS  _twi_slave_tx_handler_G102+1,R30
	SBI  0x8,4
	SBI  0x8,5
	STS  188,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(8000)
	LDI  R27,HIGH(8000)
	CALL __DIVW21U
	MOV  R17,R30
	CPI  R17,8
	BRSH PC+3
	JMP _0x2040006
	SUBI R17,LOW(8)
_0x2040006:
	STS  184,R17
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_twi_master_trans:
; .FSTART _twi_master_trans
	ST   -Y,R26
	SBIW R28,4
	SBIS 0x1E,7
	RJMP _0x2040007
	LDD  R30,Y+10
	LSL  R30
	STS  _slave_address_G102,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STS  _twi_tx_buffer_G102,R30
	STS  _twi_tx_buffer_G102+1,R31
	LDI  R30,LOW(0)
	STS  _twi_tx_index,R30
	LDD  R30,Y+7
	STS  _bytes_to_tx_G102,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _twi_rx_buffer_G102,R30
	STS  _twi_rx_buffer_G102+1,R31
	LDI  R30,LOW(0)
	STS  _twi_rx_index,R30
	LDD  R30,Y+4
	STS  _bytes_to_rx_G102,R30
	LDI  R30,LOW(6)
	STS  _twi_result,R30
	sei
	LDD  R30,Y+7
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040008
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x2040009
	LDI  R30,LOW(0)
	ADIW R28,11
	RET
_0x2040009:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE PC+3
	JMP _0x204000B
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BREQ PC+3
	JMP _0x204000B
	RJMP _0x204000C
_0x204000B:
	RJMP _0x204000A
_0x204000C:
	LDI  R30,LOW(0)
	ADIW R28,11
	RET
_0x204000A:
	SBI  0x1E,6
	RJMP _0x204000F
_0x2040008:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040010
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x2040011
	LDI  R30,LOW(0)
	ADIW R28,11
	RET
_0x2040011:
	LDS  R30,_slave_address_G102
	ORI  R30,1
	STS  _slave_address_G102,R30
	CBI  0x1E,6
_0x204000F:
	CBI  0x1E,7
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	__GETD1N 0x7A120
	CALL __PUTD1S0
_0x2040016:
	SBIC 0x1E,7
	RJMP _0x2040018
	CALL __GETD1S0
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTD1S0
	BREQ PC+3
	JMP _0x2040019
	LDI  R30,LOW(5)
	STS  _twi_result,R30
	SBI  0x1E,7
	LDI  R30,LOW(0)
	ADIW R28,11
	RET
_0x2040019:
	RJMP _0x2040016
_0x2040018:
_0x2040010:
	LDS  R26,_twi_result
	LDI  R30,LOW(0)
	CALL __EQB12
	ADIW R28,11
	RET
_0x2040007:
	LDI  R30,LOW(0)
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G102
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G102
	LDS  R27,_twi_rx_buffer_G102+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BREQ PC+3
	JMP _0x2040023
	LDI  R18,LOW(0)
	RJMP _0x2040024
_0x2040023:
	CPI  R30,LOW(0x10)
	BREQ PC+3
	JMP _0x2040025
_0x2040024:
	LDS  R30,_slave_address_G102
	STS  187,R30
	RJMP _0x2040026
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x18)
	BREQ PC+3
	JMP _0x2040028
_0x2040027:
	RJMP _0x2040029
_0x2040028:
	CPI  R30,LOW(0x28)
	BREQ PC+3
	JMP _0x204002A
_0x2040029:
	CP   R16,R19
	BRLO PC+3
	JMP _0x204002B
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G102
	LDS  R27,_twi_tx_buffer_G102+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
_0x2040026:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x204002C
_0x204002B:
	LDS  R30,_bytes_to_rx_G102
	CP   R17,R30
	BRLO PC+3
	JMP _0x204002D
	LDS  R30,_slave_address_G102
	ORI  R30,1
	STS  _slave_address_G102,R30
	CBI  0x1E,6
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x2040022
_0x204002D:
	RJMP _0x2040030
_0x204002C:
	RJMP _0x2040022
_0x204002A:
	CPI  R30,LOW(0x50)
	BREQ PC+3
	JMP _0x2040031
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2040032
_0x2040031:
	CPI  R30,LOW(0x40)
	BREQ PC+3
	JMP _0x2040033
_0x2040032:
	LDS  R30,_bytes_to_rx_G102
	SUBI R30,LOW(1)
	CP   R17,R30
	BRSH PC+3
	JMP _0x2040034
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2040035
_0x2040034:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
_0x2040035:
	RJMP _0x2040022
_0x2040033:
	CPI  R30,LOW(0x58)
	BREQ PC+3
	JMP _0x2040036
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2040037
_0x2040036:
	CPI  R30,LOW(0x20)
	BREQ PC+3
	JMP _0x2040038
_0x2040037:
	RJMP _0x2040039
_0x2040038:
	CPI  R30,LOW(0x30)
	BREQ PC+3
	JMP _0x204003A
_0x2040039:
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x48)
	BREQ PC+3
	JMP _0x204003C
_0x204003B:
	CPI  R18,0
	BREQ PC+3
	JMP _0x204003D
	SBIS 0x1E,6
	RJMP _0x204003E
	CP   R16,R19
	BRLO PC+3
	JMP _0x204003F
	RJMP _0x2040040
_0x204003F:
	RJMP _0x2040041
_0x204003E:
	LDS  R30,_bytes_to_rx_G102
	CP   R17,R30
	BRLO PC+3
	JMP _0x2040042
_0x2040040:
	LDI  R18,LOW(4)
_0x2040042:
_0x2040041:
_0x204003D:
_0x2040030:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
	STS  188,R30
	RJMP _0x2040043
	RJMP _0x2040044
_0x204003C:
	CPI  R30,LOW(0x38)
	BREQ PC+3
	JMP _0x2040045
_0x2040044:
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2040043
	RJMP _0x2040046
_0x2040045:
	CPI  R30,LOW(0x68)
	BREQ PC+3
	JMP _0x2040047
_0x2040046:
	RJMP _0x2040048
_0x2040047:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2040049
_0x2040048:
	LDI  R18,LOW(2)
	RJMP _0x204004A
	RJMP _0x204004B
_0x2040049:
	CPI  R30,LOW(0x60)
	BREQ PC+3
	JMP _0x204004C
_0x204004B:
	RJMP _0x204004D
_0x204004C:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x204004E
_0x204004D:
	LDI  R18,LOW(0)
_0x204004A:
	LDI  R17,LOW(0)
	CBI  0x1E,6
	LDS  R30,_twi_rx_buffer_size_G102
	CPI  R30,0
	BREQ PC+3
	JMP _0x2040051
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2040052
_0x2040051:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
_0x2040052:
	RJMP _0x2040022
_0x204004E:
	CPI  R30,LOW(0x80)
	BREQ PC+3
	JMP _0x2040053
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x90)
	BREQ PC+3
	JMP _0x2040055
_0x2040054:
	SBIS 0x1E,6
	RJMP _0x2040056
	LDI  R18,LOW(1)
	RJMP _0x2040057
_0x2040056:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G102
	CP   R17,R30
	BRLO PC+3
	JMP _0x2040058
	LDS  R30,_twi_slave_rx_handler_G102
	LDS  R31,_twi_slave_rx_handler_G102+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x2040059
	LDI  R18,LOW(6)
	RJMP _0x2040057
_0x2040059:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G102,0
	CPI  R30,0
	BRNE PC+3
	JMP _0x204005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2040022
_0x204005A:
	RJMP _0x204005B
_0x2040058:
	SBI  0x1E,6
_0x204005B:
	RJMP _0x204005E
_0x2040055:
	CPI  R30,LOW(0x88)
	BREQ PC+3
	JMP _0x204005F
_0x204005E:
	RJMP _0x2040060
_0x204005F:
	CPI  R30,LOW(0x98)
	BREQ PC+3
	JMP _0x2040061
_0x2040060:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2040022
_0x2040061:
	CPI  R30,LOW(0xA0)
	BREQ PC+3
	JMP _0x2040062
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SBI  0x1E,7
	LDS  R30,_twi_slave_rx_handler_G102
	LDS  R31,_twi_slave_rx_handler_G102+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x2040065
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G102,0
	RJMP _0x2040066
_0x2040065:
	LDI  R18,LOW(6)
_0x2040066:
	RJMP _0x2040022
_0x2040062:
	CPI  R30,LOW(0xB0)
	BREQ PC+3
	JMP _0x2040067
	LDI  R18,LOW(2)
	RJMP _0x2040068
_0x2040067:
	CPI  R30,LOW(0xA8)
	BREQ PC+3
	JMP _0x2040069
_0x2040068:
	LDS  R30,_twi_slave_tx_handler_G102
	LDS  R31,_twi_slave_tx_handler_G102+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x204006A
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G102,0
	MOV  R19,R30
	CPI  R30,0
	BREQ PC+3
	JMP _0x204006B
	RJMP _0x204006C
_0x204006B:
	LDI  R18,LOW(0)
	RJMP _0x204006D
_0x204006A:
_0x204006C:
	LDI  R18,LOW(6)
	RJMP _0x2040057
_0x204006D:
	LDI  R16,LOW(0)
	CBI  0x1E,6
	RJMP _0x2040070
_0x2040069:
	CPI  R30,LOW(0xB8)
	BREQ PC+3
	JMP _0x2040071
_0x2040070:
	SBIS 0x1E,6
	RJMP _0x2040072
	LDI  R18,LOW(1)
	RJMP _0x2040057
_0x2040072:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G102
	LDS  R27,_twi_tx_buffer_G102+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRLO PC+3
	JMP _0x2040073
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2040074
_0x2040073:
	SBI  0x1E,6
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
_0x2040074:
	RJMP _0x2040022
_0x2040071:
	CPI  R30,LOW(0xC0)
	BREQ PC+3
	JMP _0x2040077
	RJMP _0x2040078
_0x2040077:
	CPI  R30,LOW(0xC8)
	BREQ PC+3
	JMP _0x2040079
_0x2040078:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G102
	LDS  R31,_twi_slave_tx_handler_G102+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x204007A
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G102,0
_0x204007A:
	RJMP _0x2040043
	RJMP _0x204007B
_0x2040079:
	CPI  R30,0
	BREQ PC+3
	JMP _0x2040022
_0x204007B:
	LDI  R18,LOW(3)
_0x2040057:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
	STS  188,R30
_0x2040043:
	SBI  0x1E,7
_0x2040022:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G102,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_etemp:
	.BYTE 0x2
_eCod0:
	.BYTE 0x1
_eCod1:
	.BYTE 0x1

	.DSEG
_dataLed:
	.BYTE 0x60
_v:
	.BYTE 0x2
_co2led:
	.BYTE 0x2
_vled:
	.BYTE 0x2
_t1:
	.BYTE 0x2
_xxx:
	.BYTE 0x4
_xxx1:
	.BYTE 0x4
_txBuffer:
	.BYTE 0x100
_txRdIndex:
	.BYTE 0x1
_co2s:
	.BYTE 0x7
_vs:
	.BYTE 0x6
_t1s:
	.BYTE 0x6
_t2s:
	.BYTE 0x6
_ps:
	.BYTE 0x7
_twi_eeprom:
	.BYTE 0x16
_twi_adr:
	.BYTE 0x2
_ac1:
	.BYTE 0x2
_ac2:
	.BYTE 0x2
_ac3:
	.BYTE 0x2
_b1:
	.BYTE 0x2
_b2:
	.BYTE 0x2
_mb:
	.BYTE 0x2
_mc:
	.BYTE 0x2
_md:
	.BYTE 0x2
_ac4:
	.BYTE 0x2
_ac5:
	.BYTE 0x2
_ac6:
	.BYTE 0x2
_ut:
	.BYTE 0x4
_x1:
	.BYTE 0x4
_x2:
	.BYTE 0x4
_b5:
	.BYTE 0x4
_t:
	.BYTE 0x4
_b6:
	.BYTE 0x4
_x3:
	.BYTE 0x4
_b3:
	.BYTE 0x4
_pressure:
	.BYTE 0x4
_p:
	.BYTE 0x4
_b4:
	.BYTE 0x4
_b7:
	.BYTE 0x4
_nnn:
	.BYTE 0x1
_dataDHT:
	.BYTE 0x5
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_slave_address_G102:
	.BYTE 0x1
_twi_tx_buffer_G102:
	.BYTE 0x2
_bytes_to_tx_G102:
	.BYTE 0x1
_twi_rx_buffer_G102:
	.BYTE 0x2
_bytes_to_rx_G102:
	.BYTE 0x1
_twi_rx_buffer_size_G102:
	.BYTE 0x1
_twi_slave_rx_handler_G102:
	.BYTE 0x2
_twi_slave_tx_handler_G102:
	.BYTE 0x2
__seed_G103:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__ASRD1:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__ASRD16:
	MOV  R30,R22
	MOV  R31,R23
	CLR  R22
	SBRC R31,7
	SER  R22
	MOV  R23,R22
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
