/* memset
   This implementation is in the public domain.  */

/*
@deftypefn Supplemental void* memset (void *@var{s}, int @var{c}, @
  size_t @var{count})
Sets the first @var{count} bytes of @var{s} to the constant byte
@var{c}, returning a pointer to @var{s}.
@end deftypefn
*/

#include <stddef.h>

void *
memset (void *dest, register int val, register size_t len)
{
  register unsigned char *ptr = (unsigned char*)dest;
  while (len-- > 0)
    *ptr++ = val;
  return dest;
}

/* Wrapper to implement ANSI C's memmove using BSD's bcopy. */
/* This function is in the public domain.  --Per Bothner. */

/*
@deftypefn Supplemental void* memmove (void *@var{from}, const void *@var{to}, @
  size_t @var{count})
Copies @var{count} bytes from memory area @var{from} to memory area
@var{to}, returning a pointer to @var{to}.
@end deftypefn
*/

#include <stddef.h>

void bcopy (const void*, void*, size_t);

void *
memmove (void *s1, const void *s2, size_t n)
{
  bcopy (s2, s1, n);
  return s1;
}

/* memcpy (the standard C function)
   This function is in the public domain.  */

/*
@deftypefn Supplemental void* memcpy (void *@var{out}, const void *@var{in}, @
  size_t @var{length})
Copies @var{length} bytes from memory region @var{in} to region
@var{out}.  Returns a pointer to @var{out}.
@end deftypefn
*/

#include <stddef.h>

void bcopy (const void*, void*, size_t);

void *
memcpy (void *out, const void *in, size_t length)
{
    bcopy(in, out, length);
    return out;
}