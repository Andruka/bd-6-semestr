#include"Generator.h"
void Generator::init(string n,string b,int a,char g,FILE * fr){
    char nn[64];
    strcpy(nn,n.c_str());
    cout<<nn<<endl;
    char bb[64];
    strcpy(bb,b.c_str());
    struct cat ct;
    for(int i=0;i<64;++i){
        ct.name[i]=nn[i];
        ct.breed[i]=bb[i];
        }
    ct.age=a;
    ct.gender=g;
    fwrite(&ct,sizeof(ct),1,fr);
}
bool Generator::check(ifstream &fin,vector<string> & v){
    string buf;
    if(fin.eof())return 1;
    while(true){
        getline(fin,buf);
	if(fin.eof())return 0;
	v.push_back(buf);
        }
}
bool Generator::work(int quantity,int max_age){
    char gender;
    ifstream fm("male.txt");
    ifstream ff("female.txt");
    ifstream fb("breed.txt");
    FILE * fr;
    fr=fopen("bd.txt","w");
    srand(time(0));
    cout<<"Идёт чтение файлов,ожидайте..."<<endl;
    if(check(fm,vM)){cout<<"Файл male.txt пуст! "<<endl;return 1;}
    if(check(ff,vF)){cout<<"Файл female.txt пуст! "<<endl;return 1;}
    if(check(fb,vB)){cout<<"Файл breed.txt пуст! "<<endl;return 1;}
    cout<<endl<<"Файлы считаны,идёт генерация базы котов,подождите ещё чуть чуть..."<<endl;
    fwrite(&quantity,sizeof(int),1,fr);
    for(int i=0;i<quantity;++i){
	if(rand() % 2)gender='m';
	else gender='f';
  	if(gender == 'm'){
	    init(vM[rand() % vM.size()],vB[rand() % vB.size()],rand() % max_age + 1,gender,fr);
	    }
	else{
	    init(vF[rand() % vF.size()],vB[rand() % vB.size()],rand() % max_age + 1,gender,fr);
	    }
        }
    return 0;
}
int main(int argc , char ** argv ){
    int quantity;
    int max_age;
    if(argc!=3)cout<<"Ошибка!"<<endl;
    quantity=atoi(argv[1]);
    max_age=atoi(argv[2]);
    Generator gen;
    if(gen.work(quantity,max_age)){cout<<"Какой-то входной файл оказался пустым"<<endl;return 1;}
    cout<<"База котов сгенерирована!"<<endl;
}
