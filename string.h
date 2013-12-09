/**
* This file contain all string contants use in the program
*/

#ifndef _STRING_H
#define _STRING_H

/**
* UART string constants
*/
const char uart_menu[] = "Select a menu";
const char uart_welcome[] = "Welcome";
const char uart_play[] = "Play";
const char uart_record[] = "Record";
const char uart_setSamplingRate[] = "Set sampling rate";
const char uart_errorWrite[] = "Write error!";
const char uart_errorRead[] = "Read error";
const char uart_done[] = "Done";
const char uart_trackList[] = "Track list";
const char uart_changeSampleRate[] = "Change sample rate";
const char uart_writing[] = "Writing";
const char uart_reading[] = "Reading";
const char uart_initReadError[] = "Initial buffering error";
const char uart_debugRead[] = "Debug read";

/*------------------- LCD String constant ------------------------------------*/
// const char lcd_welcome[] = "VOICE RECORDER";
// const char lcd_record[] = "> Record";
// const char lcd_play[] = "> Play";
// const char lcd_sampleRate[] = "> Sample Rate";
// const char lcd_writing[] = "Recording...";
// const char lcd_errorWrite[] = "Write error";
// const char lcd_done[] = "Completed!";
// const char lcd_playing[] = "Playing...";
// const char lcd_s_16khz[] = "> 16Khz";
// const char lcd_s_8khz[] = "> 8khz";
// const char lcd_saved[] = "Saved!";
// const char lcd_t_notrack[] = "No track!";
// const char lcd_totaltrack[] = "> Total track";
char lcd_welcome[] = "VOICE RECORDER";
char lcd_record[] = "> Record";
char lcd_play[] = "> Play";
char lcd_sampleRate[] = "> Sample Rate";
char lcd_writing[] = "Recording...";
char lcd_errorWrite[] = "Write error";
char lcd_done[] = "Completed!";
char lcd_playing[] = "Playing...";
char lcd_s_16khz[] = "> 16Khz";
char lcd_s_8khz[] = "> 8khz";
char lcd_saved[] = "Saved!";
char lcd_t_notrack[] = "No track!";
char lcd_totaltrack[] = "> Total track";
#endif /* _STRING_H */