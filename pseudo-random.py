#!/usr/bin/python3
if __name__ == "__main__":
    lfsr = 60
    for i in range(10):
        newbit = (lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)
        # newbit = newbit % 65535
        #newbit = newbit & 0X0000FFFF
        # print(newbit)
        lfsr = (newbit << 15) | (lfsr >> 1)
        lfsr = lfsr & 0X0000FFFF
        alfa = hex(lfsr)
        pointer = lfsr | 0X00010000
        # print(f"lfsr = (int){lfsr}, (hex){alfa}")
        if pointer >= 0X00010000 and pointer <= 0X0001FFFF:
            print(f"[{i}] = {pointer:08x} is in range")
        else:
            print(f"[{i}] = {pointer:08x} is not in range") 