# ZPS2 - Minimal PS/2 Keyboard Module 

ZPS2 is a lightweight PS/2 keyboard input module written in x86 Assembly.
It is designed to be easily integrated into low-level projects without rewriting keyboard handling logic.

---

# ✨ What It Does

- Handles PS/2 keyboard input using IRQ1 interrupt
- Reads raw scan codes from the keyboard
- Stores input in an internal circular buffer
- Provides simple functions to access key data

---

# ⚙️ How It Works

1. Keyboard sends data via PS/2
2. CPU triggers IRQ1 interrupt
3. "ps2_handler" reads scan code from port "0x60"
4. Data is stored in buffer
5. User retrieves keys using "ps2_getkey"

---

# 🚀 Usage

1. Include the module

%include "ps2.asm"

---

2. Initialize keyboard

call ps2_init

---

3. Connect interrupt (REQUIRED)

set_idt_entry 0x21, ps2_handler

---

4. Enable interrupts

sti

---

5. Read key input

call ps2_getkey
; AL = scan code

---

# 🧩 API

"ps2_init"

Enables the PS/2 keyboard.

---

"ps2_handler"

IRQ1 interrupt handler.
Must be connected to IDT entry "0x21".

---

"ps2_getkey"

Blocking function. Waits until a key is available.
Returns scan code in "AL".

---

"ps2_has_key"

Non-blocking check.
Returns:

- "AL = 1" → key available
- "AL = 0" → no key

---

# ⚠️ Important Notes

- Returns raw scan codes, not ASCII
- Key release events are ignored
- Buffer size is 256 bytes
- Designed for 32-bit protected mode
- Requires manual IDT setup

---

# 📜 License

- MIT License
