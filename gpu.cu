#include<iostream>
#include<fstream>
#include<vector>
using namespace std;
#define M 175000000
#define N 2*M
#define S 8

__global__ void square(char I[M], unsigned int O[N]){
	int x0 = blockIdx.x;
	int x1 = blockIdx.y;
	int x2 = blockIdx.z;
	int x3 = threadIdx.x;
	int size=0;
	int it=0;
	int pow=1;
	while(I[it]!='+'){
		size+=(I[it]-48)*pow;
		it++;
		pow=pow*10;
	}
	it++;
	int idx=x0+x1*S+x2*S*S+x3*S*S*S;
	
	if(idx<2*size-1){	
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
				O[idx]+=2*(I[it+i]-48)*(I[it+j]-48);
			else if(i==j){
				O[idx]+=(I[it+i]-48)*(I[it+j]-48);
			}
			i++;
			j--;
		}
	}

	O[N-1]=1;
}

int main(){
	fstream fin,foutr;
	string file="s.txt";
	fin.open(file.c_str());
	foutr.open("r.txt");

	char *hostI=new char[M];
	unsigned int *hostO=new unsigned int[N];

	int size=0;
	int it=0;
	int pow=1;
	char s;
	fin>>s;
	while(s!='+'){
		size+=(s-48)*pow;
		it++;
		pow=pow*10;
		fin>>s;
	}
	it++;

	fin.close();
	fin.open(file.c_str());

	cout<<"input"<<endl;
	for(int i=0;i<size+it;i++){
		fin>>s;
		hostI[i]=s;
		cout<<hostI[i]<<endl;
	}


	char *I;

	unsigned int *O;

	cudaMalloc((void**)&I, sizeof(char) * M);

	cudaMalloc((void**)&O, sizeof(unsigned int) * N);

	cudaMemcpy(I,hostI,sizeof(char) * M,cudaMemcpyHostToDevice);

	cudaMemcpy(O,hostO,sizeof(unsigned int) * N,cudaMemcpyHostToDevice);

	dim3 blocks(S,S,S);
	dim3 threads(S,1,1);

	square<<<blocks,threads>>>((char(*))I, (unsigned int(*))O);

	cudaMemcpy(hostO,O,sizeof(unsigned int) * N,cudaMemcpyDeviceToHost);

	cout<<"output"<<endl;
	for (int i=0;i<2*size-1;i++){
		cout<<hostO[i]<<endl;
	}

	cout<<hostO[N-1]<<endl;

	return 0;

}