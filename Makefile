CROSS_COMPILE =arm-none-eabi-
#CROSS_COMPILE =/opt/OSELAS.Toolchain-2011.11.0/arm-cortexm3-eabi/gcc-4.6.2-newlib-1.19.0-binutils-2.21.1a/bin/arm-cortexm3-eabi-
CROSS_COMPILE =/opt/gcc-arm/bin/arm-none-eabi-
CC		= $(CROSS_COMPILE)gcc
LD		= $(CROSS_COMPILE)ld
AR		= $(CROSS_COMPILE)ar
AS		= $(CROSS_COMPILE)as
OC		= $(CROSS_COMPILE)objcopy
OD		= $(CROSS_COMPILE)objdump
SZ		= $(CROSS_COMPILE)size

CFLAGS	= 	-c -fno-common \
			-ffunction-sections \
			-fdata-sections \
			-g3 \
			-mcpu=cortex-m3 \
			-mthumb \
			-Wall

LDSCRIPT= ld/stm32f103.ld

LDFLAGS	=	--gc-sections,-T$(LDSCRIPT),-no-startup,-nostdlib

OCFLAGS	=	-Obinary

ODFLAGS	=	-S


OUTPUT_DIR = output

TARGET  = 	$(OUTPUT_DIR)/main


INCLUDE =   -I./src/include \
			-I./src/freertos/include/ \
			-I./src/freertos/portable/GCC/ARM_CM3/


# Add other source files if they are needed e.g. other Firmwarlib Components
SRCS	=	./src/main.c \
            ./src/startup.c \
			./src/freertos/timers.c \
			./src/freertos/portable/MemMang/heap_2.c \
			./src/freertos/portable/GCC/ARM_CM3/port.c \
			./src/freertos/tasks.c \
			./src/freertos/queue.c \
			./src/freertos/croutine.c \
			./src/freertos/list.c \


OBJS=$(SRCS:.c=.o)


.PHONY : clean all


all: $(TARGET).bin  $(TARGET).list
	@echo "  SIZE $(TARGET).elf"
	$(SZ) $(TARGET).elf


clean:
	@echo "Removing files..."
	-find . -name '*.o'   | xargs rm
	-find . -name '*.elf' | xargs rm
	-find . -name '*.lst' | xargs rm
	-find . -name '*.out' | xargs rm
	-find . -name '*.bin' | xargs rm
	-find . -name '*.map' | xargs rm


$(TARGET).list: $(TARGET).elf
	@echo "  OBJDUMP $(TARGET).list"
	$(OD) $(ODFLAGS) $< > $(TARGET).lst



$(TARGET).bin: $(TARGET).elf
	@echo "  OBJCOPY $(TARGET).bin"
	$(OC) $(OCFLAGS) $(TARGET).elf $(TARGET).bin



$(TARGET).elf: $(OBJS)
	@echo "  LD $(TARGET).elf"
	$(CC) -mcpu=cortex-m3 -mthumb -Wl,$(LDFLAGS),-o$(TARGET).elf,-Map,$(TARGET).map $(OBJS)


%.o: %.c
	@echo "  CC $<"
	$(CC) $(INCLUDE) $(CFLAGS)  $< -o $*.o

