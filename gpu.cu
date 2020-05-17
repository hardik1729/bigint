#include<iostream>
#include<fstream>
#include<vector>
using namespace std;
#define M 9000000
#define N 2*M-1
#define B 1024
#define T 8

__global__ void square(char I[M], unsigned int O[N]){
	int x = blockIdx.x;
	int y = threadIdx.x;
	int size=0;
	int it=0;
	int pow=1;
	while(I[it]!='+'){
		size+=(I[it]-48)*pow;
		it++;
		pow=pow*10;
	}
	it++;
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
					O[idx]+=2*(I[it+i]-48)*(I[it+j]-48);
				else if(i==j){
					O[idx]+=(I[it+i]-48)*(I[it+j]-48);
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
/*
void base_case(fstream &foutr,int v,int &h,const unsigned int b){
	if(v!=0){
		base_case(foutr,v/b,h,b);
		foutr<<v%b;
		h++;
	}
	return;
}

void add(fstream &foutr,int* v,int c,int i,int h,int size,const unsigned int b){
	if(i==2*(size-1)){
		base_case(foutr,v,h,b);
		return;
	}else{
		v=v+c;
		c=v/b;
		char out=48+(v%b);
		foutr<<out;
		h++;
		add(foutr,v,c,i,h,size,b);
		return;
	}
}
*/
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

	//cout<<"input"<<endl;
	for(int i=0;i<size+it;i++){
		fin>>s;
		hostI[i]=s;
		//cout<<hostI[i]<<endl;
	}


	char *I;

	unsigned int *O;
	cout<<"before alloc"<<endl;
	cudaMalloc((void**)&I, sizeof(char) * M);

	cudaMalloc((void**)&O, sizeof(unsigned int) * N);
	// cout<<"after alloc"<<endl;
	// cout<<"before copy"<<endl;
	cudaMemcpy(I,hostI,sizeof(char) * (size+it),cudaMemcpyHostToDevice);

	cudaMemcpy(O,hostO,sizeof(unsigned int) * 2*size-1,cudaMemcpyHostToDevice);
	cout<<"after copy"<<endl;
	dim3 blocks(B,1,1);
	dim3 threads(T,1,1);

	square<<<blocks,threads>>>((char(*))I, (unsigned int(*))O);
	
	cudaMemcpy(hostO,O,sizeof(unsigned int) * N,cudaMemcpyDeviceToHost);
	
	// cout<<"output"<<endl;
	for (int i=0;i<2*size-1;i++){
		cout<<hostO[i]<<" ";
	}
	
	// add(&hostO,foutr,);

	cout<<hostO[N-1]<<endl;

	return 0;

}