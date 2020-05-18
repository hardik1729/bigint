#include<iostream>
#include<fstream>
#include<vector>
using namespace std;
#define M 9000000
#define N 2*M
#define B 1024
#define T 8

__global__ void square(unsigned long long int I[M], unsigned long long int O[N]){
	int x = blockIdx.x;
	int y = threadIdx.x;
	int size=I[0];
	int idx_start=(y+x*T);
	int idx_end=(1+y+x*T);
	int C=B*T;
	if(2*size>C){
		int jump=2*size/(C/2)-1;
		if(idx_start<(C/4)){
			idx_start*=jump;
			idx_end*=jump;
		}else if(idx_start>(C/2)+(C/4)-1){
			idx_start-=((C/2)+(C/4));
			idx_start*=jump;
			idx_start+=((C/4)*jump+(C/2));
			idx_end-=((C/2)+(C/4));
			idx_end*=jump;
			idx_end+=((C/4)*jump+(C/2));
		}else{
			idx_start-=(C/4);
			idx_start+=(C/4)*jump;
			idx_end-=(C/4);
			idx_end+=(C/4)*jump;
		}
	}
	
	for(int idx=idx_start;idx<idx_end;idx++){
		if(idx<2*size){	
			int i,j;
			if(idx<size){
				i=size-1-idx;
				j=size-1;
			}else{
				i=0;
				j=size-1-(idx-(size-1));
			}
			while(i!=size && j!=-1 && i<=j){
				if(i<j)
					O[idx+1]+=2*(I[1+i])*(I[1+j]);
				else if(i==j){
					O[idx+1]+=(I[1+i])*(I[1+j]);
				}
				i++;
				j--;
			}
		}
	}
	if(idx_end==size*2)
		printf("%d\n", idx_end);
	O[N-1]=1;
}

int main(){

	unsigned long long int *hostI=new unsigned long long int[M];
	unsigned long long int *hostO=new unsigned long long int[N];

	int size=4096;

	for(int i=0;i<size+1;i++){
		if(i==0){
			hostI[0]=size;
		}else{
			hostI[i]=1;
		}
	}


	unsigned long long int *I;

	unsigned long long int *O;
	cout<<"before alloc"<<endl;
	cudaMalloc((void**)&I, sizeof(unsigned long long int) * M);

	cudaMalloc((void**)&O, sizeof(unsigned long long int) * N);
	// cout<<"after alloc"<<endl;
	// cout<<"before copy"<<endl;
	cudaMemcpy(I,hostI,sizeof(unsigned long long int) * (size+1),cudaMemcpyHostToDevice);

	cudaMemcpy(O,hostO,sizeof(unsigned long long int) * (2*size),cudaMemcpyHostToDevice);
	cout<<"after copy"<<endl;
	dim3 blocks(B,1,1);
	dim3 threads(T,1,1);

	square<<<blocks,threads>>>((unsigned long long int(*))I, (unsigned long long int(*))O);
	
	cudaMemcpy(hostO,O,sizeof(unsigned long long int) * N,cudaMemcpyDeviceToHost);
	
	// cout<<"output"<<endl;
	for (int i=0;i<2*size;i++){
		// cout<<hostO[i]<<" ";
	}
	
	cout<<hostO[N-1]<<endl;

	return 0;

}