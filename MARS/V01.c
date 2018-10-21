/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 02.11.2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

/*
Управление 
    G   -   начать передачу данных по ВТ
    R   -   остановить передачу данных по ВТ
    C   -   передавать температуру оцифрованную DHT-22
    c   -   передавать темпераутру оцифрованную BMP-180
    S   -   перейти в режим настройки (концентрация СО2 указывается в коде, а не ррм
    s   -   перейти в обычный режим
    x   -   в режиме настройки команда х111, где 111 - любые цифры, изменяет в программе код0
Возврат
*/


#include <mega328p.h>
#include <delay.h>
#include <math.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define Bit(bit)				(1<<(bit))						//Обратится к биту
#define ClearBit(reg, bit)      reg &= (~(1<<(bit)))			//Очистить бит
#define SetBit(reg, bit)        reg |= (1<<(bit))				//Установить бит
#define BitIsClear(reg, bit)    ((reg & (1<<(bit))) == 0)		//Проверка очистки бита
#define BitIsSet(reg, bit)      ((reg & (1<<(bit))) != 0)		//Проверка установки бита
#define InvBit(reg, bit)        reg ^= (1<<(bit))				//Инвертировать бит

#define DC_GAIN 8.5
#define ZERO_POINT_VOLTAGE  0.325
#define REACTION_VOLTAGE    0.02
#define UREF                5

eeprom unsigned int etemp;
eeprom unsigned char eCod0,eCod1;
unsigned int cod0,codTemp;
unsigned char dataLed[96]={0x10};

// Declare your global variables here
bit timerEnd,errorDHT,Sw,Run,Stp,Ust;
unsigned char permit,co2p,timerCounter=0;
unsigned int consentration,co2,v,co2led,vled;
int t1;
float xxx,xxx1;


unsigned char txBuffer[256];
unsigned char txWrIndex=0,txRdIndex=0;
unsigned char co2s[7]={'x','x','x','x','.','x',0};
unsigned char vs[6]={'x','x','.','x','0',0};
unsigned char t1s[6]={'+','x','x','.','x',0};
unsigned char t2s[6]={'+','x','x','.','x',0};
unsigned char ps[7]={'x','x','x','.','x','x',0};
unsigned char twi_eeprom[22];
unsigned char twi_adr[2];
int ac1,ac2,ac3,b1,b2,mb,mc,md;
unsigned int ac4,ac5,ac6;
long int ut,x1,x2,b5,t,b6,x3,b3,pressure,p;
unsigned long b4,b7;

unsigned char nnn;

interrupt [USART_RXC] void usart_rx_isr(void)
{
    unsigned char temp;
    temp=UDR0;
    if (Ust)
    {
        codTemp*=10;
        codTemp+=temp-'0';
        nnn--;
        if (nnn==0)
        {
            eCod0=codTemp/256;
            eCod1=codTemp%256;
            cod0=codTemp;
            Ust=0;
        }
    }
    if (temp=='C')
        Sw=1;
    if (temp=='c')
        Sw=0;
    if (temp=='G')
        Run=1;
    if (temp=='R')
        Run=0;
    if (temp=='S')
        Stp=0;
    if (temp=='s')
        Stp=1;
    if (temp=='x')
        if (Stp==0)
        {
            Ust=1;
            nnn=3;
            codTemp=0;
        }
}

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
    ClearBit(UCSR0B,TXCIE0);									//Запретить прерывания по завершению передачи
	if (txRdIndex!=txWrIndex)									//Если появился новый символ для передачи
		SetBit(UCSR0B,UDRIE0);
}

// USART DRE interrupt service routine
interrupt [USART_DRE] void usart_dre_isr(void)
{
    UDR0=txBuffer[txRdIndex++];
    if (txRdIndex==txWrIndex)									//Если достигли конца команды
	{
		ClearBit(UCSR0B,UDRIE0);								//Запретить прерывания - регистр данных пуст
		SetBit(UCSR0B,TXCIE0);
	}
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    timerCounter++;
    if (timerCounter==7)
    {
        timerEnd=0;
        timerCounter=0;
    }
}

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

unsigned int readADC(void)
{
    SetBit(ADCSRA,ADSC);
    // Wait for the AD conversion to complete
    while (BitIsClear(ADCSRA,ADIF)){};
    SetBit(ADCSRA,ADIF);
    return ADCW;
}
    
unsigned char dataDHT[5];						//Данные (5 байт) принимаемые от DHT22
unsigned char readDHT(void)
{
    unsigned char id,jd;
	SetBit(DDRD,2);
	ClearBit(PORTD,2);
	delay_ms(25);
	SetBit(PORTD,2);
    delay_us(30);
	ClearBit(DDRD,2);
	delay_us(40);
	if (BitIsSet(PIND,2)) return 0;
	delay_us(80);
	if (BitIsClear(PIND,2)) return 0;
	while (BitIsSet(PIND,2))
        if (!timerEnd)
            return 0;
	for (id=0;id<5;id++){
		dataDHT[id]=0;
        jd=7;
        while (jd!=0xff)
        {
			while (BitIsClear(PIND,2))
                if (!timerEnd)
                    return 0;
			delay_us(40);
			if (BitIsSet(PIND,2))
				dataDHT[id]|=(1<<jd);
			while (BitIsSet(PIND,2))
                if (!timerEnd)
                    return 0;
            jd--;
		}        
	}
	return 1;
}

#pragma warn-
void asmSendData(unsigned char n){
#asm 
	cli
	push r30
	push r31
    push r28
    push r29
    push r26
    push r27
	push r18
	push r19
	push r20   
    ld   r18,y               ;R18 bytes
	ldi R30,0x00	            ;Z dataLed  (0x0300)
	ldi R31,0x03				
m4:	ldi R19,8				;R19 bits
	ld R20,Z+				;R20 data
m3:	cbi 0x05,3				;0x05 PORTB
m5:	nop
	nop
	nop
	lsl R20
	sbi 0x05,3
	nop
	nop
	nop
	brcs m1
	cbi 0x05,3
	nop
	nop
	nop
	nop
	nop
	dec R19
	brne m5
	dec R18
	brne m4
	pop r20
	pop r19
	pop r18
	pop r31
	pop r30
	sei
	ret
m1:	nop
	nop
	nop
	nop
	dec R19
	brne m3
	nop
	cbi 0x05,3
	dec R18
	brne m4
	pop r20
	pop r19
	pop r18 
    pop r27
    pop r26
    pop r29
    pop r28
	pop r31
	pop r30
	sei
	ret
#endasm
}
#pragma warn+




// TWI functions
#include <twi.h>

void main(void)
{
// Declare your local variables here
unsigned char temp;
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=In 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 16,384 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x67;

// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: Off, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (1<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE | 1;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// TWI initialization
// Mode: TWI Master
// Bit Rate: 100 kHz
twi_master_init(100);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);
lcd_gotoxy(0,0);
lcd_putsf("+xx.xC xxx.xxkPa");
lcd_gotoxy(0,1);
lcd_putsf("xx.xx% xxxx.xppm");

xxx=(float)REACTION_VOLTAGE*DC_GAIN*1023/UREF/(3-2.602);
cod0=eCod0;
cod0*=256;
cod0+=eCod1;
//cod0=665;

permit=etemp;
permit=0;
consentration=0;
timerCounter=0;
Sw=0;
Run=0;
Stp=1;
nnn=0;
Ust=0;

// Global enable interrupts
#asm("sei")
delay_ms(20);
twi_adr[0]=0xF4;
twi_adr[1]=0x2E;
//twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
delay_ms(2000);
twi_adr[0]=0xAA;
twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,22);
//twi_master_trans(0x77,0,0,(unsigned char *)&twi_adr,2);
ac1=(twi_eeprom[0]<<8)|(twi_eeprom[1]);
ac2=(twi_eeprom[2]<<8)|(twi_eeprom[3]);
ac3=(twi_eeprom[4]<<8)|(twi_eeprom[5]);
ac4=(twi_eeprom[6]<<8)|(twi_eeprom[7]);
ac5=(twi_eeprom[8]<<8)|(twi_eeprom[9]);
ac6=(twi_eeprom[10]<<8)|(twi_eeprom[11]);
b1=(twi_eeprom[12]<<8)|(twi_eeprom[13]);
b2=(twi_eeprom[14]<<8)|(twi_eeprom[15]);
mb=(twi_eeprom[16]<<8)|(twi_eeprom[17]);
mc=(twi_eeprom[18]<<8)|(twi_eeprom[19]);
md=(twi_eeprom[20]<<8)|(twi_eeprom[21]);

ClearBit(DDRD,2);
delay_ms(20);



    while (1)
    {
        timerEnd=1;
        permit++;
        if (permit<9)
        {   
            consentration+=readADC();
        }
        if (permit==9)
        {
           co2=consentration>>3;
           if (Stp)
           {
             //co2=400*pow(10,(consentration-cod0)/xxx);
             if (co2>cod0)
                co2=400;
             else
             {
                co2=cod0-co2;
                xxx1=co2/xxx;
                xxx1=pow(10,xxx1);
                if (xxx1>25)
                    co2=9999;
                else
                    co2=400*xxx1;
             }
             co2p=0;   
           }
           else
           {
             co2p=consentration%8;
             co2p=co2p*10/8;
           }  
           co2led=co2;
           consentration=0;
           temp=co2/1000;
           co2s[0]=temp+'0';
           co2-=temp*1000;
           temp=co2/100;
           co2s[1]=temp+'0';
           co2-=temp*100;
           temp=co2/10;
           co2s[2]=temp+'0';
           co2-=temp*10;
           co2s[3]=co2+'0';
           co2s[5]=co2p+'0';
        }
        if (permit==10)
        {
            twi_adr[0]=0xF4;
            twi_adr[1]=0x2E;
            twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
        }
        if (permit==11)
        {
            twi_adr[0]=0xF6;
            twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,2);    
        }
        if (permit==12)
        {
            ut=((long)twi_eeprom[0]<<8)+twi_eeprom[1];
            x1=((ut-ac6)*ac5)>>15;
            x2=((long)mc<<11)/(x1+md);
            b5=x1+x2;
            t=(b5+8)>>4;
        }
        if (permit==13)
        {
            if (t<0)
            {
                t2s[0]='-';
                t1=-t;
            }
            else
            {
                t2s[0]='+';
                t1=t;
            }
            temp=t1/100;
            t2s[1]=temp+'0';
            t1-=temp*100;
            temp=t1/10;
            t2s[2]=temp+'0';
            t1-=temp*10;
            t2s[4]=t1+'0';    
        }
        if (permit==14)
        {
            twi_adr[0]=0xF4;
            twi_adr[1]=0x34;
            //twi_adr[1]=0xF4;
            twi_master_trans(0x77,(unsigned char *)&twi_adr,2,0,0);
        }   
        if (permit==17)
        {
            errorDHT=readDHT();    
        }
        if (permit==18)
        {
            if (dataDHT[0]+dataDHT[1]+dataDHT[2]+dataDHT[3]-dataDHT[4])
                errorDHT=0;
            if (errorDHT)
            {
                v=dataDHT[0];
                v<<=8;
                v+=dataDHT[1];
                t1=dataDHT[2];
                t1<<=8;
                t1+=dataDHT[3];
                vled=v;
                temp=v/100;
                vs[0]=temp+'0';
                v-=temp*100;
                temp=v/10;
                vs[1]=temp+'0';
                v-=temp*10;
                vs[3]=v+'0';
                if (t1&0x8000)
                {
                    t1s[0]='-';
                    t1&=0x7fff;
                    t1--;    
                }
                else
                    t1s[0]='+';
                temp=t1/100;
                t1s[1]=temp+'0';
                t1-=temp*100;
                temp=t1/10;
                t1s[2]=temp+'0';
                t1-=temp*10;
                t1s[4]=t1+'0';    
            }
            else
            {
                t1s[1]='x';
                t1s[2]='x';
                t1s[4]='x';
            }
        }
        if (permit==21)
        {
            twi_adr[0]=0xF6;
            twi_master_trans(0x77,(unsigned char *)&twi_adr,1,(unsigned char *)&twi_eeprom,2);    
        }
        if (permit==22)
        {
            pressure=((unsigned long)twi_eeprom[0]<<8)+twi_eeprom[1];
            //pressure=((long)twi_eeprom[0]<<16)+((long)twi_eeprom[1]<<8)+twi_eeprom[2];
            b6 = b5 - 4000;
	        x1 = (b2 * ((b6 * b6) >> 12)) >> 11;
	        x2 = ac2 * b6 >> 11;
	        x3 = x1 + x2;
            b3= (long int)ac1<<2;
            b3+=x3;
            
            //b3<<=3;
            
            b3+=2;
            b3>>=2;
	        x1 = ac3 * b6; 
            x1>>=13;
	        x2 = (b1 * ((b6 * b6) >> 12)) >> 16;
	        x3 = ((x1 + x2) + 2) >> 2;
	        b4 = ac4 * (unsigned long) (x3 + 32768) >> 15;
	        b7 = (unsigned long) (pressure - b3) * 50000;
            //b7 = ((unsigned long)pressure - b3) * (50000>>3);
		    if (b7 < 0x80000000)
		        p = (b7 << 1) / b4;
        	else
		        p = (b7 / b4) << 1;
	        x1 = (p >> 8) * (p >> 8);
	        x1 = (x1 * 3038) >> 16;
	        x2 = (-7357 * p) >> 16;
            x2+=x1;
            x2+=3791;
            x2>>=4;
	        pressure = p + x2;  
           /* if (pressure>92500)
            {
            dataLed[3]=0x25; 
            dataLed[4]=0x50;
            dataLed[5]=0x00;
            }   */
        }   
        if(permit==22)
        {      
        //P
            dataLed[0]=0x00; 
            dataLed[1]=0x50;
            dataLed[2]=0x00;
            if (pressure>=92500)
            {
            dataLed[3]=0x25; 
            dataLed[4]=0x50;
            dataLed[5]=0x00;
            }else{dataLed[3]=0x00; 
            dataLed[4]=0x00;
            dataLed[5]=0x00;}
            if (pressure>=95000)
            {
            dataLed[6]=0x50; 
            dataLed[7]=0x50;
            dataLed[8]=0x00;}else{dataLed[6]=0x00; 
            dataLed[7]=0x00;
            dataLed[8]=0x00;}    
            if (pressure>=100000)
            {
            dataLed[9]=0x50; 
            dataLed[10]=0x00;
            dataLed[11]=0x00;}else{dataLed[9]=0x00; 
            dataLed[10]=0x00;
            dataLed[11]=0x00;}
            if (pressure>=102500)
            {
            dataLed[12]=0x50; 
            dataLed[13]=0x0;
            dataLed[14]=0x00;}else{dataLed[12]=0x00; 
            dataLed[13]=0x00;
            dataLed[14]=0x00;}
            if (pressure>=105000)
            {
            dataLed[15]=0x50; 
            dataLed[16]=0x50;
            dataLed[17]=0x00;}else{dataLed[15]=0x00; 
            dataLed[16]=0x00;
            dataLed[17]=0x00;}   
            if (pressure>=107500)
            {
            dataLed[18]=0x25; 
            dataLed[19]=0x50;
            dataLed[20]=0x00;}else{dataLed[18]=0x00; 
            dataLed[19]=0x00;
            dataLed[20]=0x00;} 
            if(pressure>=110000)
            {    
            dataLed[21]=0x00;
            dataLed[22]=0x50;
            dataLed[23]=0x00;
            }else{dataLed[21]=0x00; 
            dataLed[22]=0x00;
            dataLed[23]=0x00;}  
            
            //T
            dataLed[24]=0x00; 
            dataLed[25]=0x50;
            dataLed[26]=0x00;
            if (t>=-100)
            {
            dataLed[27]=0x25; 
            dataLed[28]=0x50;
            dataLed[29]=0x00;
            }else{dataLed[27]=0x00; 
            dataLed[28]=0x00;
            dataLed[29]=0x00;}
            if (t>=0)
            {
            dataLed[30]=0x50; 
            dataLed[31]=0x50;
            dataLed[32]=0x00;}else{dataLed[30]=0x00; 
            dataLed[31]=0x00;
            dataLed[32]=0x00;}    
            if (t>=100)
            {
            dataLed[33]=0x50; 
            dataLed[34]=0x00;
            dataLed[35]=0x00;}else{dataLed[33]=0x00; 
            dataLed[34]=0x00;
            dataLed[35]=0x00;}
            if (t>=200)
            {
            dataLed[36]=0x50; 
            dataLed[37]=0x0;
            dataLed[38]=0x00;}else{dataLed[36]=0x00; 
            dataLed[37]=0x00;
            dataLed[38]=0x00;}
            if (t>=300)
            {
            dataLed[39]=0x50; 
            dataLed[40]=0x50;
            dataLed[41]=0x00;}else{dataLed[39]=0x00; 
            dataLed[40]=0x00;
            dataLed[41]=0x00;}   
            if (t>=400)
            {
            dataLed[42]=0x25; 
            dataLed[43]=0x50;
            dataLed[44]=0x00;}else{dataLed[42]=0x00; 
            dataLed[43]=0x00;
            dataLed[44]=0x00;} 
            if(t>=500)
            {    
            dataLed[45]=0x00;
            dataLed[46]=0x50;
            dataLed[47]=0x00;
            }else{dataLed[45]=0x00; 
            dataLed[46]=0x00;
            dataLed[47]=0x00;}      
                   
             //CO2
            dataLed[48]=0x00; 
            dataLed[49]=0x50;
            dataLed[50]=0x00;
            if (co2led>=400)
            {
            dataLed[51]=0x25; 
            dataLed[52]=0x50;
            dataLed[53]=0x00;
            }else{dataLed[51]=0x00; 
            dataLed[52]=0x00;
            dataLed[53]=0x00;}
            if (co2led>=600)
            {
            dataLed[54]=0x50; 
            dataLed[55]=0x50;
            dataLed[56]=0x00;}else{dataLed[54]=0x00; 
            dataLed[55]=0x00;
            dataLed[56]=0x00;}    
            if (co2led>=800)
            {
            dataLed[57]=0x50; 
            dataLed[58]=0x00;
            dataLed[59]=0x00;}else{dataLed[57]=0x00; 
            dataLed[58]=0x00;
            dataLed[59]=0x00;}
            if (co2led>=1000)
            {
            dataLed[60]=0x50; 
            dataLed[61]=0x0;
            dataLed[62]=0x00;}else{dataLed[60]=0x00; 
            dataLed[61]=0x00;
            dataLed[62]=0x00;}
            if (co2led>=1200)
            {
            dataLed[63]=0x50; 
            dataLed[64]=0x50;
            dataLed[65]=0x00;}else{dataLed[63]=0x00; 
            dataLed[64]=0x00;
            dataLed[65]=0x00;}   
            if (co2led>=1400)
            {
            dataLed[66]=0x25; 
            dataLed[67]=0x50;
            dataLed[68]=0x00;}else{dataLed[66]=0x00; 
            dataLed[67]=0x00;
            dataLed[68]=0x00;} 
            if(co2led>=1600)
            {    
            dataLed[69]=0x00;
            dataLed[70]=0x50;
            dataLed[71]=0x00;
            }else{dataLed[69]=0x00; 
            dataLed[70]=0x00;
            dataLed[71]=0x00;}
            
            //H
            dataLed[72]=0x00; 
            dataLed[73]=0x50;
            dataLed[74]=0x00;
            if (vled>=120)
            {
            dataLed[75]=0x25; 
            dataLed[76]=0x50;
            dataLed[77]=0x00;
            }else{dataLed[75]=0x00; 
            dataLed[76]=0x00;
            dataLed[77]=0x00;}
            if (vled>=250)
            {
            dataLed[78]=0x50; 
            dataLed[79]=0x50;
            dataLed[80]=0x00;}else{dataLed[78]=0x00; 
            dataLed[79]=0x00;
            dataLed[80]=0x00;}    
            if (vled>=370)
            {
            dataLed[81]=0x50; 
            dataLed[82]=0x00;
            dataLed[83]=0x00;}else{dataLed[81]=0x00; 
            dataLed[82]=0x00;
            dataLed[83]=0x00;}
            if (vled>=500)
            {
            dataLed[84]=0x50; 
            dataLed[85]=0x0;
            dataLed[86]=0x00;}else{dataLed[84]=0x00; 
            dataLed[85]=0x00;
            dataLed[86]=0x00;}
            if (vled>=620)
            {
            dataLed[87]=0x50; 
            dataLed[88]=0x50;
            dataLed[89]=0x00;}else{dataLed[87]=0x00; 
            dataLed[88]=0x00;
            dataLed[89]=0x00;}   
            if (co2led>=800)
            {
            dataLed[90]=0x25; 
            dataLed[91]=0x50;
            dataLed[92]=0x00;}else{dataLed[90]=0x00; 
            dataLed[91]=0x00;
            dataLed[92]=0x00;} 
            if(co2led==100)
            {    
            dataLed[93]=0x00;
            dataLed[94]=0x50;
            dataLed[95]=0x00;
            }else{dataLed[93]=0x00; 
            dataLed[94]=0x00;
            dataLed[95]=0x00;}   
              
             dataLed[0]=dataLed[0];
        asmSendData(96);
             }                             
        if (permit==24)
        {
            temp=pressure/100000;
            ps[0]=temp+'0';
            pressure-=(unsigned long int)temp*100000;
            temp=pressure/10000;
            ps[1]=temp+'0';
            pressure-=(unsigned long int)temp*10000;
            temp=pressure/1000;
            ps[2]=temp+'0';
            pressure-=temp*1000;
            temp=pressure/100;
            ps[4]=temp+'0';
            pressure-=temp*100;
            temp=pressure/10;
            ps[5]=temp+'0';
        }
        if (Run)
        {
            if (permit==25)
            {
                txBuffer[txWrIndex++]='*';
                txBuffer[txWrIndex++]='P';
                temp=0;
                while (ps[temp])
                {
                    txBuffer[txWrIndex++]=ps[temp++];    
                }
                txBuffer[txWrIndex++]='*';
                SetBit(UCSR0B,UDRIE0);
            }
            if (permit==27)
            {
                txBuffer[txWrIndex++]='*';
                txBuffer[txWrIndex++]='T';
                temp=0;
                if (Sw)
                {
                    while (t1s[temp])
                    {
                        txBuffer[txWrIndex++]=t1s[temp++];    
                    }
                }
                else
                {
                    while (t2s[temp])
                    {
                        txBuffer[txWrIndex++]=t2s[temp++];    
                    }
                }
                txBuffer[txWrIndex++]='*';
                SetBit(UCSR0B,UDRIE0);
            }
            if (permit==29)
            {
                txBuffer[txWrIndex++]='*';
                txBuffer[txWrIndex++]='V';
                temp=0;
                while (vs[temp])
                {
                    txBuffer[txWrIndex++]=vs[temp++];    
                }
                txBuffer[txWrIndex++]='*';
                SetBit(UCSR0B,UDRIE0);
            }
            if (permit==30)
            {
                txBuffer[txWrIndex++]='*';
                txBuffer[txWrIndex++]='N';
                temp=0;
                while (co2s[temp])
                {
                    txBuffer[txWrIndex++]=co2s[temp++];    
                }
                txBuffer[txWrIndex++]='*';
                SetBit(UCSR0B,UDRIE0);
            }
        }
        if (permit==31)
        {   
            lcd_gotoxy(0,0);
            if (Sw)
                lcd_puts(t1s);
            else
                lcd_puts(t2s);                
            lcd_gotoxy(7,0);
            lcd_puts(ps);
            lcd_gotoxy(0,1);
            lcd_puts(vs);
            lcd_gotoxy(7,1);
            lcd_puts(co2s);
            permit=0;
            pressure=0;
        }              
                
        while(timerEnd){};  
    }
}
