/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/31/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>

#include <delay.h>

#include <string.h>

#include <stdio.h>

#include <stdlib.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void TODelay(){
    TCNT0 = 1;
    TCCR0 = 0x05;
    while ((TIFR&(1<<TOV0))==0);
    TCCR0 = 0;
    TIFR = 0x1;
}

TODelays(){
    TODelay();  
    TODelay();
    TODelay();
    TODelay();
    TODelay();
    TODelay();
    TODelay();
    TODelay();
    TODelay();
}

int floorSqrt(int x)
{
    long start = 1, end = x / 2, ans = 0;
    if (x == 0 || x == 1)
        return x;
    while (start <= end) {
        int mid = (start + end) / 2;
        if (mid * mid == x)
            return (int)mid;
        if (mid * mid < x) {
            start = mid + 1;
            ans = mid;
        }
        else{ 
            end = mid - 1;
        }
    }
    return (int)ans;
}

void main(void)
{
// Declare your local variables here
char x=0;
float Temperature ;
char Previous_temperature, out[10];
bit first = 0;
char i=-1;
float firstNum=0.00;
float secondNum=0.00;
float thirdNum=0.00;
int operator=0;
bit isSecondNum=0;
char out1[10];
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 7.813 kHz
// ADC Voltage Reference: Int., cap. on AREF
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

while (1)
      {
            
            //  calculator
            
            //  First row
                  
            PORTD = 0b00000001;  
            
            //  Add 7
            
            if(PIND.4==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 7;
            }
            else{      
                secondNum = (secondNum * 10) + 7;
            }
            i=i+1;  
            lcd_gotoxy(i,1); 
            lcd_putchar('7');
            }    
            
            //  Add 8
            
            if(PIND.5==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 8;
            }
            else{      
                secondNum = (secondNum * 10) + 8;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('8');
            }     
            
            //  Add 9
            
            if(PIND.6==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 9;
            }
            else{      
                secondNum = (secondNum * 10) + 9;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('9');
            } 
            
            //  Division operator
            
            if(PIND.7==1){ 
            if(operator == 1){
                operator = 5;        
            }
            else{
                operator = 1;
                isSecondNum = 1;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('/');
            }
            
            delay_ms(80);    
            
            
            //  Second row
            
            PORTD = 0b00000010; 
            
            //  Add 4
            
            if(PIND.4==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 4;
            }
            else{      
                secondNum = (secondNum * 10) + 4;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('4');
            }      
            
            //  Add 5
            
            if(PIND.5==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 5;
            }
            else{      
                secondNum = (secondNum * 10) + 5;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('5');
            }     
            
            //  Add 6
            
            if(PIND.6==1){  
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 6;
            }
            else{      
                secondNum = (secondNum * 10) + 6;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('6');
            }
            
            //  Multiplication operator
            
            if(PIND.7==1){  
            if(operator == 2){
                operator = 6;    
            }
            else{
                operator = 2;
                isSecondNum = 1;
            } 
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('*');
            }  
            
            delay_ms(80);     
            
            
            // Third row
            
            PORTD = 0b00000100; 
            
            //  Add 1
            
            if(PIND.4==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 1;
            }
            else{      
                secondNum = (secondNum * 10) + 1;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('1');
            }  
            
            //  Add 2
            
            if(PIND.5==1){ 
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 2;
            }
            else{      
                secondNum = (secondNum * 10) + 2;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('2');
            }    
            
            //  Add 3
            
            if(PIND.6==1){   
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 3;
            }
            else{      
                secondNum = (secondNum * 10) + 3;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('3');
            } 
            
            // Subtraction operator
            
            if(PIND.7==1){      
            if(operator == 3){
                operator = 7;        
            }
            else{
                operator = 3;
                isSecondNum = 1;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('-');
            }  
            
            delay_ms(80);    
            
            
            // Fourth row
            
            PORTD = 0b00001000;
            
            //  Clear calculator
            
            if(PIND.4==1){ 
            lcd_clear();
            firstNum=0;
            secondNum=0;
            thirdNum=0;
            operator=0;
            i=-1;
            isSecondNum=0;
            }
            
            //  Add 0
             
            if(PIND.5==1){   
            if(isSecondNum == 0){
                firstNum = (firstNum * 10) + 0;
            }
            else{      
                secondNum = (secondNum * 10) + 0;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('0');
            }    
            
            //  Operations calculations
            
            if(PIND.6==1){ 
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('=');
            switch(operator) {
              case 1:
                thirdNum = firstNum / secondNum;
                break;
              case 2:
                thirdNum = firstNum * secondNum;
                break; 
              case 3:
                thirdNum = firstNum - secondNum;
                break;
              case 4:
                thirdNum = firstNum + secondNum;
                break;  
              case 5:
                thirdNum = floorSqrt(firstNum);
                break; 
              case 6:
                thirdNum = firstNum * firstNum;
                break; 
              case 7:
                thirdNum = firstNum - 1;
                break; 
              case 8:
                thirdNum = firstNum + 1;
                break; 
            }   
            ftoa(thirdNum, 2, out1);
            i=i+1; 
            lcd_gotoxy(i,1);
            lcd_puts(out1);
            }   
            
            //  Addition operator
            
            if(PIND.7==1){ 
            if(operator == 4){
                operator = 8;        
            }
            else{
                operator = 4;  
                isSecondNum = 1;
            }
            i=i+1; 
            lcd_gotoxy(i,1); 
            lcd_putchar('+');
            }  
            
            delay_ms(80);

      }
}
