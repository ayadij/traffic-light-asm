################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
traffic.obj: ../traffic.asm $(GEN_OPTS) $(GEN_HDRS)
	@echo 'Building file: $<'
	@echo 'Invoking: MSP430 Compiler'
	"C:/ti/ccsv5/tools/compiler/msp430_4.2.1/bin/cl430" -vmsp --abi=coffabi --include_path="C:/ti/ccsv5/ccs_base/msp430/include" --include_path="C:/ti/ccsv5/tools/compiler/msp430_4.2.1/include" --advice:power=all -g --define=__MSP430F2274__ --diag_warning=225 --display_error_number --diag_wrap=off --printf_support=minimal --preproc_with_compile --preproc_dependency="traffic.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


