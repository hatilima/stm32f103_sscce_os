#include <stdint.h>

extern void main(void);

// Symbols defined by the linker script
extern uint32_t _sidata;  // Start of initialized data in Flash
extern uint32_t _sdata;   // Start of initialized data in RAM
extern uint32_t _edata;   // End of initialized data in RAM
extern uint32_t _sbss;    // Start of BSS section in RAM
extern uint32_t _ebss;    // End of BSS section in RAM

void Reset_Handler(void);

void Default_Handler(void);



__attribute__((section(".vector_table")))
void (*const vector_table[])(void) = {
    (void (*)(void))0x20001000, // Initial stack pointer
    Reset_Handler,
    Default_Handler, // NMI
    Default_Handler, // Hard fault
    // Other interrupt handlers...
};

/*
// Vector Table Definition
uint32_t *vector_table[] __attribute__((section(".vector_table"))) = {
    (uint32_t *)0x20001000,   // Stack Pointer (SP)
    (uint32_t *)Reset_Handler, // Reset Handler
    (uint32_t *)Default_Handler, // NMI
    (uint32_t *)Default_Handler, // Hard fault
    // Other interrupt service routine (ISR) entries...
};
*/

void Reset_Handler(void) {
    // Copy initialized data section from Flash to RAM
    uint32_t *source = &_sidata;
    uint32_t *destination = &_sdata;

    while (destination < &_edata) {
        *destination++ = *source++;
    }

    // Initialize BSS section to zero
    destination = &_sbss;
    while (destination < &_ebss) {
        *destination++ = 0;
    }

    // Call the main function
    main();

    // Infinite loop to prevent falling through
    while (1);
}

void Default_Handler(void) {
    while (1);
}
