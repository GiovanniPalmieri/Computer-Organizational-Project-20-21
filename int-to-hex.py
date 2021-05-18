#!/usr/bin/python3
if __name__ == "__main__":

    alfa = '1736734 2147467279 2147475463 2147479555 2147481601 2147482624 2147483136 2147483392 2147483520 2147483584'
    separeted = alfa.split(' ')
    for i in separeted:
        print(hex(int(i) + 65536))