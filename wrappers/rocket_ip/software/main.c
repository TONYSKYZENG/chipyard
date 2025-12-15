// 不依赖 stdint.h，只用基本C类型
int main() {
    // 每次延时 1000000，跑 20 次流水
    int i=4;
    int j=0;
    
    /*float *data = (float *)4096;
    float ru = 0.0f;
    data[0] = 2.5f;
    for(i=1;i<8;i++) {
        ru =ru+1.0f;
        data[i]=ru;
    }*/
   int *data = (int *)(0x80000000+4096);
   for(i=1;i<8;i++) {
        data[i]=i;
    }
   // data[2]=i+6;
    //data[0]=7;
    return 0;
}