/***********************license start************************************
 * OCTEON SDK
 * 
 * Copyright (c) 2003-2005 Cavium Networks. All rights reserved.
 * 
 * This file, which is part of the OCTEON SDK from Cavium Networks,
 * contains proprietary and confidential information of Cavium Networks and
 * its suppliers.
 * 
 * Any licensed reproduction, distribution, modification, or other use of
 * this file or the confidential information or patented inventions
 * embodied in this file is subject to your license agreement with Cavium
 * Networks. Unless you and Cavium Networks have agreed otherwise in
 * writing, the applicable license terms can be found at:
 * licenses/cavium-license-type2.txt
 * 
 * All other use and disclosure is prohibited.
 * 
 * Contact Cavium Networks at info@caviumnetworks.com for more information.
 **********************license end**************************************/

/*
 * File version info: $Id: hello.c 26635 2007-07-28 23:40:41Z cchavva $
 */
 
#include <stdio.h>
#include <cvmx.h>


int main(void)
{
    /* There are two main ways for a program running on the simulator to
    ** produce output: printf and simprintf.  Both (by default) generate
    ** output to the stdout of the simulator, with each line prepended
    ** with a string similar to 'PP#:~CONSOLE-> ', with # being the number (id)
    ** of the core generating the output.  The -log option may be used
    ** to direct this output to log files.
    */

    /* printf() provides maximum flexibility, but is slow due to
    ** the format string being processed in simulated code. Normal
    ** buffering is done by the C library.
    */
    printf("\n");
    printf("\n");
    printf("Hello world!\n");

#if 0
    /* simprintf() passes the format string and up to 7 arguments to the
    ** simulator and is much faster than standard printfs.  It is limited
    ** to 7 arguments of integer types, and all must use long long (%ll)
    ** formats in order to be processed properly by the host.
    ** No buffering is done - output of each simprintf call is immediate.
    ** See README in the 'runtime' directory for more info.
    */
    simprintf("Hello again - a big number is 0x%llx\n", 0x1234567887654321ULL);
#endif

    printf("Hello example run successfully.\n");
    return 0;
}
