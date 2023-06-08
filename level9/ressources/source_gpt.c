#include <iostream>

class N {
public:
    N(int x) {
        std::cout << "N::N(" << x << ")" << std::endl;
    }
    
    void setAnnotation(char* str) {
        std::cout << "N::setAnnotation(" << str << ")" << std::endl;
    }
};

int main(int argc, char** argv) {
    if (argc <= 1) {
        exit(1);
    }
    
    N* n1 = new N(0x6c);
    N* n2 = new N(0x6);
    
    char* annotation = argv[1];
    n1->setAnnotation(annotation);
    n2->setAnnotation(annotation);
    
    delete n1;
    delete n2;
    
    return 0;
}