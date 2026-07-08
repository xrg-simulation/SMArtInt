#ifndef ModelicaUtilityHelper_h
#define ModelicaUtilityHelper_h

typedef struct
{
	void (*ModelicaError)(const char*);
	void (*ModelicaMessage)(const char*);
	void (*ModelicaFormatMessage)(const char*, ...);
	void (*ModelicaFormatError)(const char*, ...);
} ModelicaUtilityHelper;

#endif

