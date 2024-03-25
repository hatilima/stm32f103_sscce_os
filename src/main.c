#include "stm32f103x_registers.h"
#include "FreeRTOS.h"
#include "task.h"

void delay() {
    for (int i = 0; i < 1000000; ++i);
}

void task1(void* args)
{
    //int i;
    for(;;)
    {
        // Toggle Pin 13 (LED)
        GPIOC->ODR ^= (1 << 13);
        delay();
        /*for(i = 0; i < 1000000; i++)
        {
            __asm__("nop");
        } */
    }
}

int main() {
    // Enable GPIOC clock
    RCC->APB2ENR |= (1 << 4);

    // Configure Pin 13 as Output (LED)
    GPIOC->CRH |= (1 << 20);  // Set mode bits for Pin 13
    GPIOC->CRH &= ~(1 << 21);
    xTaskCreate(task1,"LED",100,NULL,tskIDLE_PRIORITY + 1 ,NULL); //configMAX_PRIORITIES-1
	vTaskStartScheduler();
	for (;;);
   
   /* while(1)
    {
        // Toggle Pin 13 (LED)
        GPIOC->ODR ^= (1 << 13);
        delay();
    }
    */

    return 0;
}
