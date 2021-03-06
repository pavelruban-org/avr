#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "config.h"
#include <avr/cpufunc.h>
#include <string.h>
#include <avr/pgmspace.h>
#include "tools.h"
#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <math.h>
#include "screen.h"
#include <avr/sleep.h>

uint8_t buffer[48];
uint16_t adc_val;

uint8_t btns_noise_filter[BTNS_COUNT];
uint8_t is_float;
uint8_t odd = 0;
uint8_t play;

uint16_t game_record;
uint16_t current_max_adc;

extern uint8_t context;
extern	uint8_t * CTCNT6;

void audio_routine();
void adc_update();

void main_init()
{
	odd = 0;
	play = 0;

	context = MOD_IDLE;
	game_record = screen_number = SCREEN_DASH_ROW;
	current_max_adc = 0;
	screen_current_digit = 0;
	is_float = 1;

	memset(sr_screen, 0, sizeof(sr_screen));
	memset(btns_noise_filter, 0, sizeof(btns_noise_filter));
	memset(screen_render_digits, 0, sizeof(screen_render_digits));

	screen_upd_number(screen_number);
}

void events_poll()
{
	uint8_t pressed = !((START_IN_PIN & (1 << START_IN)) >> START_IN);

	if (pressed) {
		++btns_noise_filter[0];

		if (btns_noise_filter[0] > NOISE_FILTER_THRESHOLD)
		{
			CLR_CTCNT6();

			if (btns_noise_filter[0] > 20)
			{
				context = MOD_IDLE;
			}
			else {
				context = MOD_GAME_START;
			}
		}
	}
	else {
		btns_noise_filter[0] = 0;
	}
}

void game_action_script()
{
	uint16_t temp = adc_val;
	if (temp > current_max_adc)
	{
		current_max_adc = temp;
		if (game_record > 9999 || current_max_adc > game_record)
		{
			game_record = current_max_adc;
		}
		play = 1;
		audio_routine();
	}

	screen_number = current_max_adc;
	screen_upd_number(screen_number);

}

void script()
{
	if (context == MOD_GAME)
	{
		adc_update();
	}
}

void adc_update()
{
	//uart_str_send_P(PSTR("Hi there! What's up?\n\r"));
	//ADCSRA |= (1 << ADSC); // Start conversion
	while (ADCSRA & (1 << ADSC)); // wait for conversion to complete

	ADMUX =  (1 << REFS0) | (1 << MUX2) | (1 << MUX1) | (1 << MUX0);
	sei();
	sleep_mode();

	adc_val = ADCW;
	sprintf_P(buffer, PSTR("%" PRIu16 "\n\r"), adc_val);
	uart_str_send(buffer);
	//adc_val = (uint16_t) fmax(0, (double) adc_val - 460);
	//adc_val *= 10;
	adc_val = (uint16_t) (fmax(0, ((double) adc_val) - 512));
}

void screen_set_game_params()
{
	screen_number = 0;
	current_max_adc = 0;
	adc_val = 0;
	screen_upd_number(screen_number);
}

void game_start_complete_script()
{
	screen_set_game_params();
	START_OUT_ON;

	//play = 1;
	//audio_routine();
	CLR_CTCNT6();
}

void game_idle_action_script()
{
	START_OUT_INV;
	screen_number = game_record;

	screen_upd_number(screen_number);
}

void game_start_blink()
{
	if (odd)
	{
		memset(screen_render_digits, SCREEN_BLANK, sizeof(screen_render_digits));
		START_OUT_OFF;
	}
	else {
		memset(screen_render_digits, SCREEN_DASH, sizeof(screen_render_digits));
		START_OUT_ON;
	}

	odd ^= 1;
}

void game_over_complete_script()
{
	screen_upd_number(screen_number);
	START_OUT_OFF;

	context = MOD_IDLE;

	CLR_CTCNT6();
}

void game_over_blink()
{
	if (odd)
	{
		memset(screen_render_digits, SCREEN_BLANK, sizeof(screen_render_digits));
		START_OUT_OFF;
	}
	else {
		screen_upd_number(screen_number);
		START_OUT_ON;
	}

	odd ^= 1;
}

uint8_t const sine[256] PROGMEM = {
	127, 130, 133, 136, 139, 143, 146, 149, 152, 155, 158, 161, 164, 167, 170, 173, 176, 178, 181, 184, 187, 189, 192, 195, 197, 200, 203, 205, 207, 210, 212, 214, 217, 219, 221, 223, 225, 227, 229, 231, 232, 234, 236, 237, 239, 240, 242, 243, 244, 245, 246, 248, 248, 249, 250, 251, 251, 252, 253, 253, 253, 254, 254, 254, 254, 254, 254, 254, 253, 253, 253, 252, 252, 251, 250, 250, 249, 248, 247, 246, 245, 243, 242, 241, 239, 238, 236, 235, 233, 231, 229, 227, 225, 224, 221, 219, 217, 215, 213, 210, 208, 206, 203, 201, 198, 195, 193, 190, 187, 185, 182, 179, 176, 173, 170, 167, 164, 161, 158, 155, 152, 149, 146, 143, 140, 137, 134, 131, 128, 125, 121, 118, 115, 112, 109, 106, 103, 100, 97, 94, 91, 88, 85, 82, 79, 76, 73, 71, 68, 65, 62, 60, 57, 55, 52, 50, 47, 45, 42, 40, 38, 36, 34, 31, 29, 27, 26, 24, 22, 20, 19, 17, 15, 14, 13, 11, 10, 9, 8, 7, 6, 5, 4, 3, 3, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 16, 17, 19, 21, 22, 24, 26, 28, 30, 32, 34, 36, 39, 41, 43, 45, 48, 50, 53, 55, 58, 61, 63, 66, 69, 72, 74, 77, 80, 83, 86, 89, 92, 95, 98, 101, 104, 107, 110, 113, 116, 119, 122
};

extern void pwm_init();

void audio_routine()
{
	if (play)
	{
		pwm_init();
		uint8_t delay,n;

		for(delay = 1; delay <= 50; delay++)
		{
			for(n = 0; n < (51 - delay) / 24; n++)
			{
				for(uint8_t i = 0; i <= 254; i++)
				{
					OCR0A = OCR0B = pgm_read_byte_near(sine + i);
					cli();
					_delay_loop_2(delay);
					sei();
				}
			}
		}
//		for(delay=50;delay>=2;delay--)
//		{
//			for(n = 0; n < (51 - delay) / 20; n++)
//			{
//				for(uint8_t i=0;i<=254;i++)
//				{
//					OCR0B = OCR0A = pgm_read_byte_near(sine + i);
//					_delay_loop_2(delay);
//				}
//			}
//		}
	}
	TCCR0A = 0x00;
	AUDIO_PWM_A_PORT |= 1 << AUDIO_PWM_A;
	AUDIO_PWM_B_PORT |= 1 << AUDIO_PWM_B;

	play = 0;
}
