# project_terminal

An interactive assembly terminal for a pipelined RV32I RISC-V core, implemented entirely in hardware. 
Type an instruction into a serial terminal on your PC — it's assembled into machine code on the FPGA itself,
then executed live by the pipeline, one instruction at a time.

No host-side compiler, no bitstream reflash between instructions — the assembler is the hardware.

## How it works

```
PC serial terminal
      │  (types e.g. "ADDI x5, x0, 10\r")
      ▼
   UART_rx 
      │ received_byte, byte_valid                          
      ▼                                                     
  tokenizer          splits the line into mnemonic + up     
      │              to 3 operand tokens on spaces/commas   
      ▼                                                     
mnemonic_decoder      maps mnemonic → opcode/func3/func7 +  
      │                RISC-V instruction format tag        
      ▼                                                     
operand_interpreter   parses register numbers ("x5") and    
      │                decimal immediates (incl. negatives)
      ▼                                                     
instruction_assembler assembles the final 32-bit RISC-V     
      │                instruction word                     
      ▼                                                     
    fetch stage        injects the instruction directly     
                        into Decode (instr_mem is bypassed); 
                        NOPs fill the idle cycles between    
                        commands so the pipeline never runs  
                        ahead of what you've typed       
```

## Observing results

7-segment display — shows the 32-bit assembled instruction word in hex as soon as it's built, 
so you can sanity-check the encoding of what you just typed before/as it executes.

LEDs — display the lower 8 bits of the ALU/writeback result whenever an instruction writes to a register.

## Hardware setup

Board: Digilent Nexys A7 

Serial connection: onboard USB-UART bridge (same micro-USB cable used for programming) → open a terminal (TeraTerm / screen) at 9600 baud, 8N1

Line ending: send Carriage Return (\r, 0x0D) to submit a line — this is what triggers tokenization and assembly.
A trailing Line Feed (0x0A) is explicitly ignored by the tokenizer so CRLF-sending terminals work fine.     
