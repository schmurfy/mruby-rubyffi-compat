
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

// A function that returns a memeber of the Day enum type
enum day my_favorite_day(){
  return SATURDAY;
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

void test(){
  printf("Yeah !\n");
}







////////////////////////////
// string_specs
////////////////////////////
static char buffer[200];
void save_string(const char *str)
{
  strncpy(buffer, str, sizeof(buffer) - 1);
}

unsigned int get_char(unsigned int n)
{
  return buffer[n];
}






////////////////////////////
// callbacks_specs
////////////////////////////
struct SomeObject {
  struct SomeObject *next ;
  char              *name ;
  double             value ;
};

struct SomeObject* create_object(double d)
{
  struct SomeObject *obj = malloc(sizeof(struct SomeObject));
  obj->next = NULL;
  obj->name = malloc(3 + 1);
  strcpy(obj->name, "abc");
  obj->value = d;
  return obj;
}

void free_object(struct SomeObject *obj)
{
  free(obj->name);
  free(obj);
}

typedef int (*notifyWhenYouWant)(struct SomeObject *waggled, double val);
void set_object_callback(struct SomeObject *waggler, notifyWhenYouWant callback)
{
  callback(waggler, waggler->value);
}




////////////////////////////
// struct
////////////////////////////


struct buffer_struct {
 uint8_t id; 
 uint8_t name[5];
}; 


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

struct buffer_struct *create_buffer()
{
  struct buffer_struct *ret = malloc(sizeof(struct buffer_struct));
  ret->id = 56;
  strcpy(ret->name, "rambo !");
  printf("\nbase: %llx\n", (uint64_t)ret);
  printf("name: %llx\n", (uint64_t)&ret->name);
  
  uint8_t *ptr = (uint8_t *)ret;
  printf("%x %x %x %x %x %x\n", ptr[0], ptr[1], ptr[2], ptr[3], ptr[4], ptr[5]);
  
  return ret;
}


void inspect_buffer(struct buffer_struct *s)
{
  uint8_t *ptr = (uint8_t *)s;
  printf("%x %x %x %x %x %x\n", ptr[0], ptr[1], ptr[2], ptr[3], ptr[4], ptr[5]);
  printf("id: %d\n", s->id);
  printf("str: %s\n", s->name);
}

// For Struct's as types tests
//
//

// simple struct
typedef struct {
  int id;
  const char* name;
} SomeStruct;

// count the objects
int s_count = 0;

// return initialized struct
//   with name field filled to passed string
//   and id set to incremented count
SomeStruct* some_struct_new(const char* n) 
{
  SomeStruct *s = malloc(sizeof(SomeStruct));
  s->name = n;
  s->id = s_count++;
  return s;
}

// take a SomeStruct*
// return its id
int some_struct_get_id(SomeStruct* s)
{
  return s->id;
}

// take a SomeStruct*
// return its name
const char* some_struct_get_name(SomeStruct* s)
{
  return s->name;
}


//
typedef int (*test_types_cb)(SomeStruct *ss, double val);
int test_types_callback(test_types_cb cb)
{
  SomeStruct* ss = some_struct_new("fred");
  double dbl = 3.3;
  return cb(ss,dbl);
}

/*
 union 
*/

typedef union {
  int8_t         int_v;
  SomeStruct* struct_v;
  uint8_t     buffer_v[4];
} SomeUnion;

SomeUnion*
some_union_new()
{
  SomeUnion* u = malloc(sizeof(SomeUnion));
  return u;
}

void
some_union_fill_int(SomeUnion* u)
{
  u->int_v = 63;
}

void
some_union_fill_struct(SomeUnion* u)
{
  u->struct_v = some_struct_new("union_member");
}

void
some_union_fill_buffer(SomeUnion* u)
{
  u->buffer_v[0] = 65;
  u->buffer_v[1] = 66;
  u->buffer_v[2] = 67;
  u->buffer_v[3] = 0;
}
