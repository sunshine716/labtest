#include <stdio.h>
#include <string.h>

void granted(){
    printf("\n Access granted!\n\n");
    printf("%11s\t%-30s\n ", "  Name:", "Jesscia Simpson");
    printf("%10s\t%-30s\n ", "Card No:", "4266-8416-5678-5628");
    printf("%10s\t%-30s\n ", "GOOD THRU:", "08/25");
    printf("%10s\t%-30s\n\n ", "CVV:", "872");
	
    exit(0);
}

int main(int argc, char** args) {

    while(1) {
    printf("\n Please enter your password:");   
    char password[16] = {0};
    gets(password);
   
    printf("\nThe password you entered is:%s\n", password);
    printf(args[1]);

    if (strcmp(password, "ecelab@123"))
        printf("\n Unauthorized access!\n\n");
    else
        granted();
    }
}

