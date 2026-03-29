import serial
import time
import sys

# --- CONFIGURATION (MATCH YOUR HARDWARE) ---
COM_PORT = 'COM11'      # Change this to your port
BAUD_RATE = 9600         # This MUST match your Verilog UART speed
TIMEOUT = 1            

def run_uart_monitor():
    print(f"--- UART Monitor Started on {COM_PORT} @ {BAUD_RATE} ---")
    print("--- Press Ctrl+C to stop ---")

    try:
        with serial.Serial(COM_PORT, BAUD_RATE, timeout=TIMEOUT) as ser:
            ser.reset_input_buffer() 

            while True:
                packet = ser.read(6)

                if len(packet) == 0:
                    continue 

                if len(packet) == 6:
                    payload = packet[0:4] 
                    terminator = packet[4:6] 

                    if terminator == b'\r\n':
                        # FIX: Reverse the bytes using [::-1]
                        # This turns "04 00 00 00" into "00 00 00 04"
                        hex_string = payload[::-1].hex().upper()
                        
                        formatted_hex = " ".join(hex_string[i:i+2] for i in range(0, len(hex_string), 2))
                        
                        print(f"Received: {formatted_hex}")
                    else:
                        print(f"Sync Error: Footer was {terminator.hex()}, expected 0D 0A.")

    except serial.SerialException as e:
        print(f"\nError: Could not open port {COM_PORT}.")
    except KeyboardInterrupt:
        print("\n--- Monitor Stopped by User ---")

if __name__ == "__main__":
    run_uart_monitor()