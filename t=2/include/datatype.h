#ifndef __DATATYPE_1271_H__
#define __DATATYPE_1271_H__

#define NLIMBS 2
#define u_NLIMBS 4
typedef unsigned char uchar8;
typedef unsigned long long uint64;

typedef struct {
  uint64 l[NLIMBS]; 
}
p1271;

typedef struct {
  uint64 l[u_NLIMBS]; 
}
unreduced_p1271;



#endif


