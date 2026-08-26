import std.stdio;
import core.stdc.stdlib : malloc, free, alloca;

void livingDangerously()
{
    // Access to C's malloc and free primitives
    enum bytes = float.sizeof * 1024 * 1024; // 4 MB
    auto buf = malloc(bytes);
    if (!buf)
        throw new Exception("Memory allocation failed");

    // Free memory automatically upon scope exit (RAII)
    scope(exit) free(buf);

    // Reinterpret raw memory buffer as a typed float slice
    auto floats = cast(float[]) buf[0 .. bytes];
    floats[0] = 3.14159f;
    floats[1] = 2.71828f;

    writeln("Allocated ", floats.length, " floats (", bytes / (1024 * 1024), " MB)");
    writefln("Sample values: [%f, %f, ...]", floats[0], floats[1]);

    // Ephemeral stack allocation via alloca
    enum stackBytes = 4096 * 10;
    void* stackBuf = alloca(stackBytes);
    if (stackBuf)
    {
        auto stackInts = cast(int[]) stackBuf[0 .. stackBytes];
        stackInts[0] = 42;
        writeln("Stack memory written successfully, value: ", stackInts[0]);
    }
}

uint checked_multiply(uint x, uint y)
{
    uint result;

    version (D_InlineAsm_X86)
    {
        asm
        {
            mov     EAX, x      ;
            mul     y           ;
            mov     result, EAX ;
            jc      Loverflow   ;
        }
        return result;
    }
    else version (D_InlineAsm_X86_64)
    {
        asm
        {
            mov     EAX, x      ;
            mul     y           ;
            mov     result, EAX ;
            jc      Loverflow   ;
        }
        return result;
    }
    else
    {
        result = x * y;
        if (!y || x <= uint.max / y)
            return result;
    }

Loverflow:
    throw new Exception("Multiply overflow occurred");
}

void main()
{
    writeln("=== Executing Low-Level Memory Routine ===");
    livingDangerously();

    writeln("\n=== Testing Checked Multiplication ===");
    
    // 1. Valid multiplication
    uint a = 1200;
    uint b = 3500;
    writeln("Calculating: ", a, " * ", b);
    writeln("Result: ", checked_multiply(a, b));

    // 2. Controlled overflow check
    try
    {
        uint largeValue = uint.max;
        writeln("\nAttempting overflow: ", largeValue, " * 2");
        uint result = checked_multiply(largeValue, 2);
        writeln("Result: ", result);
    }
    catch (Exception e)
    {
        writeln("Caught Exception: ", e.msg);
    }
}
