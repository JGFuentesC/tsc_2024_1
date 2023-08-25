#include <stdio.h>

unsigned long long factorial(unsigned long long n) {
    if (n == 0 || n == 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

int main() {
    while (1) {
        printf("Ingresa un número para calcular su factorial (ingresa un número negativo para salir):\n");

        long long num;
        if (scanf("%lld", &num) != 1) {
            printf("Por favor, ingresa un número válido.\n");
            while (getchar() != '\n');  // Limpiar el buffer de entrada
            continue;
        }

        if (num < 0) {
            printf("Saliendo del programa.\n");
            break;
        } else if (num >= 0) {
            unsigned long long result = factorial((unsigned long long)num);
            printf("El factorial de %lld es %llu\n", num, result);
        }
    }

    return 0;
}
