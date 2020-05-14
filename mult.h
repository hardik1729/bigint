#include<iostream>
#include<fstream>
using namespace std;

void mult(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,long long int &j,long long int &k,long long int &l,const long long int x,const long long int y,const unsigned int b){
	long long int v=0;
	while(j<y && i>=0){
		fin1.seekg(x-i-1,ios::beg);
		fin2.seekg(y-j-1,ios::beg);
		char q1,q2;
		fin1>>q1;
		fin2>>q2;
		v+=(q1-48)*(q2-48);
		i--;
		j++;
	}
	v=v+c;
	if(x+y-2==i+j){
		base_case(foutr,v,h,b);
		return;
	}else{
		if(k==x-1){
			i=k;
			l++;
			j=l;
		}else{
			j=0;
			k++;
			i=k;
		}
		c=v/b;

		mult(fin1,fin2,foutr,c,h,i,j,k,l,x,y,b);
		char out=48+(v%b);
		foutr<<out;
		h++;
		return;
	}
}