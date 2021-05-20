#!/usr/bin/python3
if __name__ == "__main__":

    alfa = '32798 49167 57351 61443 63489 64512 65024 65280 65408 65472'
    separeted = alfa.split(' ')
    for i in separeted:
        print(hex(int(i) + 65536))