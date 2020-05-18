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
	
	for(int idx=idx_start+1;idx<idx_end+1;idx++){
		if(idx<2*size){	
			int i,j;
			if(idx<size+1){
				i=idx;
				j=1;
			}else{
				i=size;
				j=idx%size;
			}
			while(i!=0 && j!=size+1 && i>=j){
				if(i>j){
					O[idx]+=2*(I[i])*(I[j]);
				}
				else if(i==j){
					O[idx]+=(I[i])*(I[j]);
				}
				i--;
				j++;
			}
		}
	}
	if(idx_end==size*2)
		// printf("index_end : %d\n", idx_end);
	O[N-1]=1;
}

int main(){

	unsigned long long int *hostI=new unsigned long long int[M];
	unsigned long long int *hostO=new unsigned long long int[N];

	int size=1;
	int base=1024*1024;

	for(int i=0;i<size+1;i++){
		if(i==0){
			hostI[0]=size;
		}else{
			hostI[i]=4;
		}
	}


	unsigned long long int *I;

	unsigned long long int *O;
	
	cudaMalloc((void**)&I, sizeof(unsigned long long int) * M);

	cudaMalloc((void**)&O, sizeof(unsigned long long int) * N);
	for(int i=0;i<5;i++){
		// cout<<i<<endl;
		cudaMemcpy(I,hostI,sizeof(unsigned long long int) * (size+1),cudaMemcpyHostToDevice);

		cudaMemcpy(O,hostO,sizeof(unsigned long long int) * (2*size),cudaMemcpyHostToDevice);
		
		dim3 blocks(B,1,1);
		dim3 threads(T,1,1);

		square<<<blocks,threads>>>((unsigned long long int(*))I, (unsigned long long int(*))O);
		
		cudaMemcpy(hostO,O,sizeof(unsigned long long int) * N,cudaMemcpyDeviceToHost);
		unsigned long long int c=0;
		int pos=1;
		int flag=0;
		while (c!=0 || pos<2*size){
			if(pos>=2*size)
				hostO[pos]=0;
			hostO[pos]=hostO[pos]+c;
			c=hostO[pos]/base;
			hostO[pos]=hostO[pos]%base;
			
			if(pos==1){
				// cout<<"number : ";
				if(hostO[pos]<2){
					hostO[pos]=base-2+hostO[pos];
					flag=1;
				}else{
					hostO[pos]-=2;
				}
			}else if(flag==1 && hostO[pos]==0){
				hostO[pos]=base-1;
			}else if(flag==1){
				hostO[pos]-=1;
				flag=0;
			}
			// cout<<hostO[pos]<<" ";
			hostI[pos]=hostO[pos];
			hostO[pos]=0;
			if(c!=0 || hostI[pos]!=0)
				pos++;
		}
		hostO[0]=pos-1;
		hostI[0]=hostO[0];
		size=hostI[0];
		hostO[0]=0;
		cout<<endl<<"size : "<<hostI[0]<<endl;
		cout<<"working : "<<hostO[N-1]<<endl<<endl;
	}
	return 0;
}