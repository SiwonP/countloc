#include <stdio.h>
#include "extensions.h"
#include "string.h"

#define EXTENT "txt", "c", "cpp", "cc", "h", "hpp" ,"java", "py", "js", "xml",\
"json", "markdown", "md"

#define NUM_EXTENT sizeof(extensions)/sizeof(extensions[0])

char *extensions[] = { EXTENT };
int extensions_count[NUM_EXTENT] = { 0 };
int extensions_count_lines[NUM_EXTENT] = { 0 };

int check_extension(char *ext)
{
    int res = 0;

    for (int i = 0; i < NUM_EXTENT; i++) {
        if ( strcmp(extensions[i], ext) == 0) {
            return i;
        }
    }
    return -1;
}


char *get_extension(char *string)
{
    char *delim = ".";
    char str[128];
    strcpy(str, string);
    char *token = {0};
    char *last = {0};

    token = strtok(str, delim);
    while(token != NULL) {
        last = token;
        token = strtok(NULL, delim);
    }

    return last;
}

int count_extension(char *ext, int files)
{
    int n = check_extension(ext);

    if ( n > -1 ) {
        extensions_count[n]++;
        files++;
    }
    return files;
}

void print_result()
{
    printf("Language\tFiles\t\tLines\n");
    for (int i = 0; i < NUM_EXTENT; i++) {
        if (extensions_count[i] != 0) {
            printf("%s\t\t%d\n", extensions[i], extensions_count[i]);
        }
    }
}


