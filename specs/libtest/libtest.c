
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


enum day {
  SUNDAY = 1,
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY
};

// A function that takes an argument of the Day enum type:
int is_work_day( enum day day_of_week ){
  int ret = ((day_of_week > SUNDAY) && (day_of_week < SATURDAY)) ? 1 : 0;
  return ret;
}


unsigned int return_uint(unsigned int n){
  return n;
}

double return_double(double d){
  return d;
}

void return_uint_by_address(unsigned int *out){
  *out = 42;
}


struct s1
{
  uint32_t n1;
  uint32_t n2;
  uint16_t shorty;
  double d1;
};

void fill_struct(struct s1 *s)
{
  s->n1 = 56;
  s->n2 = 982;
  s->shorty = 12;
  s->d1 = 6.78;
}

void test(){
  printf("Yeah !\n");
}




// string_specs
static char buffer[200];
void save_string(const char *str)
{
  strncpy(buffer, str, sizeof(buffer) - 1);
}

unsigned int get_char(unsigned int n)
{
  return buffer[n];
}





