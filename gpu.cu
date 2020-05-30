#include<iostream>
#include<fstream>
using namespace std;
#define M 17000000
#define N 2*M
const long int B = 2097152;
const long int T = 1024;

__global__ void square(unsigned long long int I[M], unsigned long long int O[N]){
	int x = blockIdx.x;
	int y = threadIdx.x;
	int size=I[0];
	int idx_start=(y+x*T);
	int idx_end=(1+y+x*T);
	long int C=B*T;

	if(2*size-1>C){
		int n=int((sqrtf(1+2*(2*size-1-C))-1)/2)+1;
		int rem=2*size-1-C-2*n*(n-1);
		int rem_l=rem/2;
		int rem_r=rem-rem_l;
		if(idx_start<n || idx_end>C-n){
			if(idx_start<C/2){
				int idx=idx_start;
				idx_start=(n*n-(n-idx)*(n-idx));
				idx_end=idx_start+(1+(n-idx-1)*2);
			}else{
				idx_start-=(C-n);
				int idx=idx_start;
				idx_start=(n*n+C-2*n+idx*idx);
				idx_end=idx_start+(1+idx*2);
			}
		}else{
			idx_start-=n;
			idx_start+=(n*n);
			idx_end-=n;
			idx_end+=(n*n);
		}	
		if(idx_start==0){
			idx_end+=rem_l;
		}else if(idx_end==2*size-1-(rem_l+rem_r)){
			idx_start+=rem_l;
			idx_end+=(rem_r+rem_l);
		}else{
			idx_start+=rem_l;
			idx_end+=rem_l;
		}
	}

	for(int idx=idx_start+1;idx<idx_end+1;idx++){
		if(idx<2*size){	
			O[idx]=0;
			int i,j;
			if(idx<size+1){
				i=idx;
				j=1;
			}else{
				i=size;
				j=(idx%size)+1;
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
	if(idx_end==size*2-1)
		printf("index_end : %d\n", idx_end);
	O[N-1]=1;
}

int main(){

	unsigned long long int *hostI=new unsigned long long int[M];
	unsigned long long int *hostO=new unsigned long long int[N];

	int size=140;
	int base=1024*1024;

	for(int i=0;i<size+1;i++){
		if(i==0){
			hostI[0]=size;
		}else if(i==size){
			hostI[i]=1;
		}else{
			hostI[i]=0;
		}
	}


	unsigned long long int *I;

	unsigned long long int *O;
	
	cudaMalloc((void**)&I, sizeof(unsigned long long int) * M);

	cudaMalloc((void**)&O, sizeof(unsigned long long int) * N);
	while(size<=140){
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
			/*if(pos==1){
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
			}*/
			hostI[pos]=hostO[pos];
			// cout<<hostO[pos]<<",";
			hostO[pos]=0;
			if((pos>=2*size && (c!=0 || hostI[pos]!=0)) || pos<2*size)
				pos++;
		}
		if(hostI[pos-1]==0){
			pos--;
		}
		hostO[0]=pos-1;
		hostI[0]=hostO[0];
		size=hostI[0];
		hostO[0]=0;
		cout<<"size : "<<hostI[0]<<","<<hostI[hostI[0]]<<endl;
		cout<<"working : "<<hostO[N-1]<<endl<<endl;
	}
	return 0;
}
