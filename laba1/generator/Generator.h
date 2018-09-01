#include <iostream>
#include <fstream>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <ctime>

using namespace std;
class Generator{
    struct cat{
        char name[64];
	char breed[64];
        int age;
        char gender;
	};
    vector<string>vF,vM,vB;
  public:
    void init(string n,string b,int a,char g,FILE * f);
    bool check(ifstream & fin,vector<string> & v);
    bool work(int quantity,int max_age);
};
