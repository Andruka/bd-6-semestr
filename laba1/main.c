#include "postgres.h"
#include "funcapi.h"
#include "fmgr.h"
#include <stdio.h>
#define MAXNAME 64
#define MAXBREED 64
#define CATSIZE 133
#include <string.h>
typedef struct cat
{
    char name[MAXNAME];
    char breed[MAXBREED];
    int age;
    char gender;
} cat;

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(catset);

Datum catset(PG_FUNCTION_ARGS) {
    FuncCallContext *funcctx;
    int call_cntr;
    int max_calls;
    cat *ct;
    TupleDesc tupdesc;
    AttInMetadata *attinmeta;
    FILE *bd;
    
    if (SRF_IS_FIRSTCALL()) {
        MemoryContext oldcontext;
        funcctx = SRF_FIRSTCALL_INIT();
        oldcontext = MemoryContextSwitchTo(funcctx->multi_call_memory_ctx);
        
        
        int count; 
        bd = fopen("/home/andrei/laba1/bd.txt", "rb");
        fread(&count, sizeof(count), 1, bd);
        funcctx->max_calls =  count;
        ct = (cat*)palloc(sizeof(cat)*count);
        fread(ct, sizeof(cat), count, bd);
        funcctx->user_fctx = (void*)ct;
        /* сформировать дескриптор кортежа для типа результата */
        if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE)
            ereport(ERROR,
                    (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
                     errmsg("function returning record called in context "
                            "that cannot accept type record")));

        /*
         * получить метаданные атрибутов, необходимые позже для формирования кортежей из
         * простых строк C
         */
        
        attinmeta = TupleDescGetAttInMetadata(tupdesc);
        funcctx->attinmeta = attinmeta;
        
        MemoryContextSwitchTo(oldcontext);
    }
    funcctx = SRF_PERCALL_SETUP();
    
    call_cntr = funcctx->call_cntr;
    max_calls = funcctx->max_calls;
    attinmeta = funcctx->attinmeta;
    ct = (cat*)funcctx->user_fctx;
    
    if(call_cntr < max_calls) {
        char **values;
        HeapTuple tuple;
        Datum result;
        
        values = (char**)palloc(4 * sizeof(char*));
        values[0] = (char*)palloc(MAXNAME * sizeof(char));
        values[1] = (char*)palloc(MAXBREED * sizeof(char));
        values[2] = (char*)palloc(16 * sizeof(char));
        values[3] = (char*)palloc(8 * sizeof(char));
        //catread(bdq, &ct);
        
        snprintf(values[0], MAXNAME, "%s", ct[call_cntr].name);
        snprintf(values[1], MAXBREED, "%s", ct[call_cntr].breed);
        snprintf(values[2], 16, "%d", ct[call_cntr].age);
        if(ct[call_cntr].gender == 'm')
            snprintf(values[3], 8, "%s", "муж");
        else
            snprintf(values[3], 8, "%s", "жен");
        tuple = BuildTupleFromCStrings(attinmeta, values);
        result = HeapTupleGetDatum(tuple);
        
        SRF_RETURN_NEXT(funcctx, result);
    }
    else {
        SRF_RETURN_DONE(funcctx);
    }
}
