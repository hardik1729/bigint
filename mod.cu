#include<iostream>
#include<fstream>
using namespace std;
#define M (100+1)
#define N 2*(M-1)
unsigned long long int B = 65535;
unsigned long long int T = 1024;

__global__ void square(unsigned long long int I[M], unsigned long long int O[N]){
	unsigned long long int x = blockIdx.x;
	unsigned long long int y = threadIdx.x;
	unsigned long long int size=I[0];	
	unsigned long long int T=1024;
	unsigned long long int B=1+(2*size-1)/T;
	unsigned long long int idx_start=(y+x*T);
	unsigned long long int idx_end=(1+y+x*T);
	long int C=B*T;

	for(unsigned long long int idx=idx_start+1;idx<idx_end+1;idx++){
		if(idx<2*size){
			O[idx]=0;
			unsigned long long int i,j;
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
}

int main(){

	unsigned long long int *hostI=new unsigned long long int[M];
	unsigned long long int *hostO=new unsigned long long int[N];

	unsigned long long int size=1;
	unsigned long long int s=20;
	unsigned long long int base=pow(2,s);
	unsigned long long int p;
	cin>>p;
	int total_count=p-2;
	int count=0;

	for(unsigned long long int i=0;i<size+1;i++){
		if(i==0){
			hostI[0]=size;
		}else if(i==size){
			hostI[i]=4;
		}else{
			hostI[i]=0;
		}
	}

	unsigned long long int *I;

	unsigned long long int *O;
	
	cudaMalloc((void**)&I, sizeof(unsigned long long int) * M);

	cudaMalloc((void**)&O, sizeof(unsigned long long int) * N);
	while(count<=total_count){
//SQUARE
		cudaError_t err=cudaMemcpy(I,hostI,sizeof(unsigned long long int) * (size+1),cudaMemcpyHostToDevice);
		cout<<cudaGetErrorString(err)<<endl;

		// err=cudaMemcpy(O,hostO,sizeof(unsigned long long int) * (2*size),cudaMemcpyHostToDevice);
		// cout<<err<<endl;

		T=1024;
		B=1+(2*size-1)/T;

		dim3 blocks(B,1,1);
		dim3 threads(T,1,1);

		square<<<blocks,threads>>>((unsigned long long int(*))I, (unsigned long long int(*))O);	

		err=cudaMemcpy(hostO,O,sizeof(unsigned long long int) * 2*size,cudaMemcpyDeviceToHost);
		cout<<cudaGetErrorString(err)<<endl;
		// for(int i=1;i<2*size;i++)
			// cout<<hostO[i]<<",";
		// cout<<endl;

//NORMALIZED SUM
		int carry=0;
		int idx;
		for(idx=1;carry!=0 || idx<2*size;idx++){
			hostI[idx]=(hostO[idx]+carry)%base;
			carry=(carry+hostO[idx])/base;
			// cout<<hostI[idx]<<",";	
		}
		// cout<<endl;
		hostI[0]=--idx;

//SUBTRACT 2
		int flag=0;
		if(total_count!=count){
			for(int i=1;i<hostI[0]+1;i++){
				if(i==1){
					if(hostI[i]<2){
						flag=1;
					}
					hostI[i]=(hostI[i]+base-2)%base;
				}else if(flag){
					if(hostI[i]<1)
						flag=1;
					else
						flag=0;
					hostI[i]=(hostI[i]+base-1)%base;
				}else{
					break;
				}
				// cout<<hostI[i]<<",";
			}
			// cout<<endl;
			if(hostI[idx]==0)
				hostI[0]--;
		}

//MODULO REDUCTION TO HALF
		cout<<"step : "<<count<<endl;
		int m_count=0;
		while(hostI[0]>p/s+1 && m_count<5){
			flag=0;
			if(2*(p/s+1)-hostI[0]==1)
				flag=1;
			carry=0;
			for(idx=1;carry!=0 || (idx<=hostI[0] && idx<=p/20+1);idx++){
				if(idx>p/s+1){
					hostI[idx]=carry;
					carry=0;
				}else if(idx==p/s+1 && flag){
					hostI[idx]=(hostI[idx]+carry);
					carry=(hostI[idx])/base;
					hostI[idx]%=base;		
				}else{
					hostI[idx]=(hostI[idx]+hostI[idx+p/s+1]*pow(2,s-p%s)+carry);
					carry=(hostI[idx])/base;
					hostI[idx]%=base;
				}
				// cout<<idx<<","<<hostI[idx]<<";";
			}
			// cout<<endl;
			while(--idx>-1 && hostI[idx]==0);
			hostI[0]=idx;
			m_count++;
		}

//MODULO
		// while(hostI[0]==p/20+1 && hostI[hostI[0]]>=pow(2,p%20)){
		// 	cout<<endl<<"comeback after coding it.";
		// }
 		size=hostI[0];
 		for(int i=1;i<size+1;i++)
 			cout<<i-1<<","<<hostI[i]<<";";
 		cout<<endl;
		cout<<"size : "<<hostI[0]<<endl<<endl;
		count++;
	}
	return 0;
}
