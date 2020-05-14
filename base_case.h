#include<iostream>
#include<fstream>
using namespace std;

void base_case(fstream &foutr,long long int v,long long int &h,const unsigned int b){
	if(v!=0){
		base_case(foutr,v/b,h,b);
		foutr<<v%b;
		h++;
	}
	return;
}