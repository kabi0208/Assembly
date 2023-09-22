#include <stdio.h>
#include <stdlib.h>
#include <time.h>

struct timespec diff(struct timespec start, struct timespec end) {//clock_gettime
  struct timespec temp;
  if ((end.tv_nsec-start.tv_nsec)<0) {
    temp.tv_sec = end.tv_sec-start.tv_sec-1;
    temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
  } else {
    temp.tv_sec = end.tv_sec-start.tv_sec;
    temp.tv_nsec = end.tv_nsec-start.tv_nsec;
  }
  return temp;
}

int main() {
    int row=200,column=198; //200x198
    struct timespec start, end;
    FILE *fp=NULL;
    fp = fopen("data.txt", "w");
    int i, j, k;
    float num;
    for(i=0;i<row*2;i++){//亂數產生數字寫入data.txt
        for(j=0;j<column-1;j++){
            num=(float)rand()+(float)rand()/RAND_MAX;
            fprintf(fp,"%f ",num);
        }
        num=(float)rand()+(float)rand()/RAND_MAX;
        fprintf(fp,"%f\n",num);
    }
    fclose(fp);

    //讀入data.txt並測量花費時間
    clock_gettime(CLOCK_MONOTONIC, &start);
    float input[400][198];
    fp = fopen("data.txt", "r");
    for(i=0;i<row*2;i++){
        for(j=0;j<column;j++){
            fscanf(fp, "%f", &input[i][j]);
        }
    }
    fclose(fp);
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("%ld : %ld\n",diff(start,end).tv_sec,diff(start,end).tv_nsec);
    
    //計算並測量花費時間
    clock_gettime(CLOCK_MONOTONIC, &start);
    float output[200];
    for(i=0;i<row;i++){//A陣列每row的值經過運算後存入output陣列中
        output[i]=0;
        for(j=row;j<row*2;j++){
            for(k=0;k<column;k++){
                output[i]+=input[i][k]*input[j][k];
            }
        }
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("%ld : %ld\n",diff(start,end).tv_sec,diff(start,end).tv_nsec);

    //把結果輸出到output.txt並測量花費時間
    clock_gettime(CLOCK_MONOTONIC, &start);
    fp = fopen("output.txt","w");
    for(i=0;i<row;i++)
        fprintf(fp, "%.2f\n",output[i]);
    fclose(fp);
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("%ld : %ld\n",diff(start,end).tv_sec,diff(start,end).tv_nsec);

    return 0;
}