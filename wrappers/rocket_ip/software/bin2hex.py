#!/usr/bin/env python3
import argparse
import os

def main():
    parser = argparse.ArgumentParser(description="Convert raw binary into 64-bit-per-line hex for AXI RAM.")
    parser.add_argument("input", help="Input binary file (prog.bin)")
    parser.add_argument("output", help="Output hex file (prog.hex)")
    args = parser.parse_args()

    print(f"[bin2hex64] Reading {args.input} ...")
    with open(args.input, "rb") as f:
        data = f.read()

    print(f"[bin2hex64] {len(data)} bytes loaded.")

    # -----------------------------------------------------------------
    # Pad to *multiple of 8 bytes* (one 64-bit AXI beat)
    # -----------------------------------------------------------------
    if len(data) % 8 != 0:
        pad = 8 - (len(data) % 8)
        data += b"\x00" * pad
        print(f"[bin2hex64] padded with {pad} bytes to align to 8.")

    # -----------------------------------------------------------------
    # Convert to hex: each line = ONE 64-bit little-endian word
    # -----------------------------------------------------------------
    print(f"[bin2hex64] Writing {args.output} ...")
    with open(args.output, "w") as out:
        for i in range(0, len(data), 8):
            chunk = data[i:i+8]

            # little-endian interpretation
            value = int.from_bytes(chunk, "little")

            # 16 hex digits = 64 bits
            out.write(f"{value:016x}\n")

    print("[bin2hex64] Done.")

if __name__ == "__main__":
    main()
