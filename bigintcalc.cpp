#include<iostream>
#include<fstream>
using namespace std;

void a(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,const long long int x,const long long int y){
    long long int v=0;
		if(x==y){
			if(i<x-1){
                fin1.seekg(x-i-1,ios::beg);
                fin2.seekg(y-i-1,ios::beg);
                char q1,q2;
                fin1>>q1;
                fin2>>q2;
                v=(q1-48)+(q2-48)+c;
                c=v/10;
                i++;
                a(fin1,fin2,foutr,c,h,i,x,y);
                foutr<<v%10;
                h++;
            }else if(i==x-1){
                fin1.seekg(x-i-1,ios::beg);
                fin2.seekg(y-i-1,ios::beg);
                char q1,q2;
                fin1>>q1;
                fin2>>q2;
                v=(q1-48)+(q2-48)+c;
                foutr<<v;
                long long int aa=0;
                while(v!=0){
					aa++;
					v=v/10;
				}
                if(aa==0){aa=1;}
				h=h+aa;
            }
		}else{
			if(i<y){
                fin1.seekg(x-i-1,ios::beg);
                fin2.seekg(y-i-1,ios::beg);
                char q1,q2;
                fin1>>q1;
                fin2>>q2;
                v=(q1-48)+(q2-48)+c;
                c=v/10;
                i++;
                a(fin1,fin2,foutr,c,h,i,x,y);
                foutr<<v%10;
                h++;
            }else if(i<x-1){
                fin1.seekg(x-i-1,ios::beg);
                char q1;
                fin1>>q1;
                v=(q1-48)+c;
                c=v/10;
                i++;
                a(fin1,fin2,foutr,c,h,i,x,y);
                foutr<<v%10;
                h++;
            }else if(i==x-1){
                fin1.seekg(x-i-1,ios::beg);
                char q1;
                fin1>>q1;
                v=(q1-48)+c;
                foutr<<v;
                long long int aa=0;
                while(v!=0){
					aa++;
					v=v/10;
				}
				h=h+aa;
            }
		}
    return;
}

void m(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,long long int &j,long long int &k,long long int &l,const long long int x,const long long int y){
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
                foutr<<v;
                long long int aa=0;
                while(v!=0){
                    aa++;
                    v=v/10;
                }
                h=h+aa;
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
                c=v/10;

                m(fin1,fin2,foutr,c,h,i,j,k,l,x,y);

                foutr<<v%10;
                h++;
                return;
            }
}

void s(fstream &fin1,fstream &fin2,fstream &foutr,long long int &c,long long int &h,long long int &i,long long int &j,const long long int x,const long long int y,const long long int l){
    long long int v=0;
            if(i<y-l){
                fin1.seekg(x-i-1,ios::beg);
                fin2.seekg(y-i-1,ios::beg);
                char q1,q2;
                fin1>>q1;
                fin2>>q2;
                v=(q1-48)-(q2-48)-c;
                if(v<0){
                    v=v+10;
                    c=1;
                }else{
                    c=0;
                }
                i++;
                s(fin1,fin2,foutr,c,h,i,j,x,y,l);
                if(j==0 && v!=0){
                    j=1;
                }
                if(j==1){
                    foutr<<v;
                    h++;
                }
            }else if(i<x-l){
                fin1.seekg(x-i-1,ios::beg);
                char q1;
                fin1>>q1;
                v=(q1-48)-c;
                if(v<0){
                    v=v+10;
                    c=1;
                }else{
                    c=0;
                }
                i++;
                s(fin1,fin2,foutr,c,h,i,j,x,y,l);
                if(j==0 && v!=0){
                    j=1;
                }         
                if(j==1){
                    foutr<<v;
                    h++;
                }
            }
    return;
}

int main(){
    fstream fin1,fin2,foutr;
    fin1.open("p.txt");
    fin2.open("q.txt");
    foutr.open("r.txt");
    long long int h=0;
    char s1,s2,q;
    cin>>q;
    int x=0;
    int y=0;
    while(1){
        fin1>>s1;
        if(s1=='+' || s1=='-'){break;}
        x++;
    }

    while(2){
        fin2>>s2;
        if(s2=='+' || s2=='-'){break;}
        y++;
    }

if(q=='*'){
    if((s1=='+' && s2=='-')||(s1=='-' && s2=='+')){
        q='-';
    }else{
        q='+';
    }
    if(y>x){
        fin1.close();
        fin2.close();
        fin1.open("q.txt");
        fin2.open("p.txt");
        x=x+y;
        y=x-y;
        x=x-y;
    }
    fin2.seekg(0,ios::beg);
    fin2>>s2;
    if(y==1 && s2=='0'){
        foutr<<"0"<<q;
        cout<<"1"<<endl<<x<<" "<<y;
        return 0;
    }

    long long int c=0;
    long long int i=0;
    long long int j=0;
    long long int k=0;
    long long int l=0;
    m(fin1,fin2,foutr,c,h,i,j,k,l,x,y);

}else if((q=='+' && s1==s2)||(q=='-' && s1!=s2)){
	if(q=='+' && s1=='-'){
		q='-';
	}else if(q=='+' && s1=='+'){
		q='+';
	}else if(s1=='+'){
		q='+';
	}else{
		q='-';
	}
	
	if(y>x){
        fin1.close();
        fin2.close();
        fin1.open("q.txt");
        fin2.open("p.txt");
        x=x+y;
        y=x-y;
        x=x-y;
    }

    long long int c=0;
    long long int i=0;

    a(fin1,fin2,foutr,c,h,i,x,y);
	
}else if((q=='+' && s1!=s2)||(q=='-' && s1==s2)){
	int a=0;
	if(s1=='-'){
		fin1.close();
		fin2.close();
		fin1.open("q.txt");
		fin2.open("p.txt");
		x=x+y;
		y=x-y;
		x=x-y;
		a=1;
	}
	long long int l=0;
	if(y>x){
		if(a==1){
			fin1.close();
			fin2.close();
			fin1.open("p.txt");
			fin2.open("q.txt");
        	}else if(a==0){
            		fin1.close();
            		fin2.close();
            		fin1.open("q.txt");
            		fin2.open("p.txt");
        	}
        	x=x+y;
        	y=x-y;
        	x=x-y;
        	q='-';
    	}else if(x==y){
        	long long int k=0;
            	while(k==0 && l<x){
                	fin1.seekg(l,ios::beg);
                	fin2.seekg(l,ios::beg);
                	char q1,q2;
                	fin1>>q1;
                	fin2>>q2;
                	k=q1-q2;
                	l++;
            	}
            	if(k<0){
                	if(a==1){
				fin1.close();
				fin2.close();
				fin1.open("p.txt");
				fin2.open("q.txt");
			}else if(a==0){
				fin1.close();
				fin2.close();
				fin1.open("q.txt");
				fin2.open("p.txt");
			}
                	l=l-1;
                	q='-';
            	}else if(k>0){
                	fin1.seekg(-1,ios::cur);
                	fin2.seekg(-1,ios::cur);
                	l=l-1;
                	q='+';
            	}else if(k==0){
                	foutr<<"0+";
                	cout<<"1"<<endl<<x<<" "<<y<<endl;
                	return 0;
            	}
    	}else{
        	q='+';
    	}

    	long long int c=0;
    	long long int i=0;
    	long long int j=0;
    	s(fin1,fin2,foutr,c,h,i,j,x,y,l);
	
}   
foutr<<q;
cout<<h<<endl<<x<<" "<<y<<endl; 
}
