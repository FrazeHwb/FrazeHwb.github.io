/*************************************************************
* File Name: F28034.cmd
* Description: cmd file configure
* Version: V1.0
* Author: AUX
* Date: 2016.09.13
*************************************************************/


/*************************************************************
* MEMORY
*************************************************************/
MEMORY
{
PAGE 0:  /* Program Memory */
   RAML0       : origin = 0x008000, length = 0x000800     /* L0 SARAM 2K*16 */
   OTP         : origin = 0x3D7800, length = 0x000400     /* OTP 1K*16 */
   FLASH       : origin = 0x3E8000, length = 0x00FF80     /* FLASH 64K*16 */
   CSM_RSVD    : origin = 0x3F7F80, length = 0x000076     /* FLASH 64K*16 */
   BEGIN       : origin = 0x3F7FF6, length = 0x000002     /* FLASH 64K*16 */
   CSM_PWL_P0  : origin = 0x3F7FF8, length = 0x000008     /* FLASH 64K*16 */

   IQTABLES    : origin = 0x3FE000, length = 0x000B50     /* Boot ROM 8K*16 */
   IQTABLES2   : origin = 0x3FEB50, length = 0x00008C     /* Boot ROM 8K*16 */
   IQTABLES3   : origin = 0x3FEBDC, length = 0x0000AA	  /* Boot ROM 8K*16 */
   ROM         : origin = 0x3FF27C, length = 0x000D44     /* Boot ROM 8K*16 */
   RESET       : origin = 0x3FFFC0, length = 0x000002     /* Boot ROM 8K*16 */
   VECTORS     : origin = 0x3FFFC2, length = 0x00003E     /* Boot ROM 8K*16 */

PAGE 1 :  /* Data Memory */
   BOOT_RSVD   : origin = 0x000000, length = 0x000050     /* M0 SARAM 1K*16 */
   RAMM0       : origin = 0x000050, length = 0x0003B0     /* M0 SARAM 1K*16 */
   RAMM1       : origin = 0x000400, length = 0x000400     /* M1 SARAM 1K*16 */
   RAML1       : origin = 0x008800, length = 0x000400     /* L1 DPSARAM 1K*16 */
   RAML2       : origin = 0x008C00, length = 0x000400     /* L2 DPSARAM 1K*16 */
   RAML3       : origin = 0x009000, length = 0x001000     /* L3 DPSARAM 4K*16 */
}


/*************************************************************
* SECTIONS
*************************************************************/
SECTIONS
{
   /* Allocate program areas: */
   .cinit              : > FLASH      PAGE = 0
   .pinit              : > FLASH,     PAGE = 0
   .text               : > FLASH      PAGE = 0
   codestart           : > BEGIN      PAGE = 0

    /* Section secureRamFuncs used by file SysCtrl.c. */
   secureRamFuncs    :   LOAD = FLASH,     PAGE = 0                /* Should be Flash */ 
                         RUN = RAML0,      PAGE = 0                /* Must be CSM secured RAM */
                         LOAD_START(_secureRamFuncs_loadstart),
                         LOAD_END(_secureRamFuncs_loadend),
                         RUN_START(_secureRamFuncs_runstart)

   csmpasswds          : > CSM_PWL_P0  PAGE = 0
   csm_rsvd            : > CSM_RSVD    PAGE = 0

   /* Allocate uninitalized data sections: */
   .stack              : > RAMM0       PAGE = 1
   .ebss               : > RAML3       PAGE = 1
   .bss                : > RAML3       PAGE = 1
   .esysmem            : > RAML3       PAGE = 1
   .sysmem             : > RAML3       PAGE = 1

   /* Initalized sections go in Flash */
   /* For SDFlash to program these, they must be allocated to page 0 */
   .econst             : > FLASH      PAGE = 0
   .const              : > FLASH      PAGE = 0
   .switch             : > FLASH      PAGE = 0

   /* Allocate IQ math areas: */
   IQmath              : > FLASH      PAGE = 0            /* Math Code */
   IQmathTables        : > IQTABLES,   PAGE = 0, TYPE = NOLOAD

   /* .reset is a standard section used by the compiler.  It contains the */
   /* the address of the start of _c_int00 for C Code. */
   /* When using the boot ROM this section and the CPU vector */
   /* table is not needed.  Thus the default type is set here to  */
   /* DSECT */
   .reset              : > RESET,      PAGE = 0, TYPE = DSECT
   vectors             : > VECTORS     PAGE = 0, TYPE = DSECT
}

