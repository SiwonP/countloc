%{
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <stdio.h>
#include <dirent.h>
int strings = 0;
int lines = 0;
void open_directories(char *dir_path, int indent);
%}

%option noyywrap

NUMBER [0-9].*[0-9]*

%%

\n              { lines++; }
[^\n]*          { strings++; }

%%
typedef struct dirent dirent;

/**
 * Function that open and print every file 
 * from the directory whose path is dir_path
 * and its subdirectories as well
 */
void open_directories(char *dir_path, int indent)
{
    DIR *dir = opendir(dir_path);
    dirent *content;

    /**
     * Checking every element of the directory
     */
    while ((content = readdir(dir)) != NULL) {
        char path[1024] = {0};
        struct stat *s = {0};
        /**
         * Adding the path of the current file/folder to the main path 
         * so that it can be open either for lex or for the recursive
         * opening of subdirectories
         */
        snprintf(path, sizeof(path), "%s/%s", dir_path, content->d_name);

        /**
         * If the content read from the current directory 
         * is not a directory, apply the lex and print its name
         */
        if (content->d_type != DT_DIR) {
            if (content->d_name[0] != '.') {
                printf("%*s%s\n",indent,"", content->d_name);
                stat(path, s); 
                //printf("%hu\n", indent, "", s->st_mode); 
                yyin = fopen(path, "r");
                yylex();
                fclose(yyin);
            }

        /**
         * else repeat the function recursively but still print
         * the directory name
         */
        } else {
            if (content->d_name[0] != '.') {
                printf("%*s%s :\n",indent, "", content->d_name);
                open_directories(path, indent+4);
            }
        }
        }

        closedir(dir);
    }

    int main(int argc, char *argv[])
    {
        /**
         * Requires at least 1 argument to work.
         * only the first will be taken into account
         */
        //TODO: take into account more than 1 argument

        if (argc > 1) {
            clock_t start = clock();

            DIR *dir = opendir(argv[1]);
            DIR *sub;

            /**
             * if the argument is a fill, run the lexer on this file
             */
            if (dir == NULL) {
                yyin = fopen(argv[1], "r");
                yylex();
                fclose(yyin);

            /**
             * Else run the open_directories recursive function
             */
            } else {

                open_directories(argv[1], 0);
            }

            //TODO: print the number of files
            printf("lines: %d\n", lines);
            clock_t end = clock();
            float sec = (float)(end - start) / CLOCKS_PER_SEC;
            printf("Success in %f seconds\n", sec);

        } else {
            printf("Usage : countloc <file>\n");
        }
        return 0;
    }
