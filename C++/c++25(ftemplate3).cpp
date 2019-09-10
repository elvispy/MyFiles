// template arguments
#include <iostream>
using namespace std;

template <class T, int N>
T fixed_multiply (T val)
{
  return val * N;
}

int main() {
  std::cout << fixed_multiply<double,2>(10.0) << '\n';
  std::cout << fixed_multiply<int,3>(10) << '\n';
}
