#include<iostream>
#include<fstream>
using namespace std;
const long int M = 17000000;
const long int D = 2;
const long int N = D*(2*M-1);
const long int B = 2097152;
const long int T = 1024;

__global__ void square(unsigned long long int I[M], unsigned long long int O[N]){
	int x = blockIdx.x;
	int y = threadIdx.x;
	int size=I[0];
        int idx=(y+x*T);
        if(idx<D*(2*size-1)){
                O[idx+1]=0;
                int i,j,op,idx_one,idx_two;
                if(idx/D<size){
                        i=idx/D+1;
                        j=1;
                        op=(i+1)/2;                                                              }else{
                        i=size;
                        j=((idx/D)%size)+2;
                        op=(size-j)/2+1;                                                         }                                                                                if(op>=D){
                        i-=(op/D)*(idx%D);
                        j+=(op/D)*(idx%D);                                                               if(idx%D==D-1){
                                idx_one=i+(op/D)*(idx%D)-op;                                                     idx_two=j-(op/D)*(idx%D)+op;
                        }else{
                                idx_one=i-op/D;
                                idx_two=j+op/D;
                        }
                }else{
                        if(idx%D!=D-1){                                                                          idx_one=i;
                                idx_two=j;
                        }else{                                                                                   idx_one=i-op;                                                                    idx_two=j+op;                                                            }
                }
                while(i!=idx_one && j!=idx_two){
                        if(i>j){
                                O[idx+1]+=2*(I[i])*(I[j]);
                        }
                        else if(i==j){
                                O[idx+1]+=(I[i])*(I[j]);
                        }
                        i--;
                        j++;
                }
        }
	if(idx+1==(2*size-1)*D)
		printf("index_end : %d\n", idx+1);
	O[N-1]=1;
}

int main(){

	unsigned long long int *hostI=new unsigned long long int[M];
	unsigned long long int *hostO=new unsigned long long int[N];

	int size=4;
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
	while(size<=4){
		cudaMemcpy(I,hostI,sizeof(unsigned long long int) * (size+1),cudaMemcpyHostToDevice);

		cudaMemcpy(O,hostO,sizeof(unsigned long long int) * (2*size-1)*D,cudaMemcpyHostToDevice);
		
		dim3 blocks(B,1,1);
		dim3 threads(T,1,1);

		square<<<blocks,threads>>>((unsigned long long int(*))I, (unsigned long long int(*))O);
		cudaMemcpy(hostO,O,sizeof(unsigned long long int) * N,cudaMemcpyDeviceToHost);
		unsigned long long int c=0;
		int pos=1;
		int flag=0;
		while (c!=0 || pos<2*size){
			hostI[pos]=0;
			if(pos>2*size-1){
				for(int pos_sub=D*(pos-1)+1;pos_sub<D*pos+1;pos_sub++)
					hostO[pos_sub]=0;
			}
			for(int pos_sub=D*(pos-1)+1;pos_sub<D*pos+1;pos_sub++)
				hostI[pos]+=hostO[pos_sub];
			
			hostI[pos]=hostI[pos]+c;
			c=hostI[pos]/base;
			hostI[pos]=hostI[pos]%base;
			/*if(pos==1){
				if(hostI[pos]<2){
					hostI[pos]=base-2+hostI[pos];
					flag=1;
				}else{
					hostI[pos]-=2;
				}
			}else if(flag==1 && hostI[pos]==0){
				hostI[pos]=base-1;
			}else if(flag==1){
				hostI[pos]-=1;
				flag=0;
			}
			*/
			//cout<<hostI[pos]<<","<<c<<";";
			if((pos>=2*size && (c!=0 || hostI[pos]!=0)) || pos<2*size)
				pos++;
		}
		if(hostI[pos-1]==0){
			pos--;
		}
		hostI[0]=pos-1;
		size=hostI[0];
		cout<<"size : "<<hostI[0]<<","<<hostI[hostI[0]]<<endl;
		cout<<"working : "<<hostO[N-1]<<endl<<endl;
	}
	return 0;
}
