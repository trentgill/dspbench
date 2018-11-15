TARGET=bench

CC=arm-none-eabi-gcc-4.9.3
LD=arm-none-eabi-gcc-4.9.3
OBJDUMP=arm-none-eabi-objdump

SRC = bench.c

MCFLAGS = -mthumb -march=armv7e-m -mfloat-abi=hard -mfpu=fpv4-sp-d16
OPTIMIZE       = -O0
CFLAGS += -std=c99
CFLAGS += -Wall
CFLAGS += $(MCFLAGS)
CFLAGS += $(OPTIMIZE)
CFLAGS += $(DEFS) -I. -I./ $(STM32_INCLUDES)
CFLAGS += -fsingle-precision-constant -Wdouble-promotion
LIBS = -lm -lc -lnosys

OBJDIR = .
OBJS = $(SRC:%.c=$(OBJDIR)/%.o)

all: $(OBJS)
	$(LD) -g $(MCFLAGS) $(LDFLAGS) $(OBJS) $(LIBS) -o $(TARGET)
	$(OBJDUMP) --disassemble $(TARGET) > $(TARGET).lst

%.o: %.c
	$(CC) -ggdb $(CFLAGS) -c $< -o $@
	echo $@

