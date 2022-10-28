/*service_grey_cpu.c*/
 
/* service_grey.h */

#ifndef __SERVICE_GREY_H__
#define __SERVICE_GREY_H__

/* service_plugin.h */

#ifndef __SERVICE_PLUGIN_H__
#define __SERVICE_PLUGIN_H__

#include <stdint.h>

#define QuantumRange UINT16_MAX

typedef uint16_t Quantum;

typedef struct __PixelPacket__ {
	Quantum blue;
	Quantum green;
	Quantum red;
	Quantum opacity;
} PixelPacket;

typedef struct __Image__ {
	PixelPacket *image;
	int32_t rows;
	int32_t columns;
	int64_t j_arr;
} Image;

void run_service(char resource, void *handler_gpu, Image **target_images, int32_t *target_images_size, Image *source_images, int32_t source_images_size, double *params, int32_t *status_code);

void get_service_ids(char ***id_strings, int32_t *id_strings_size);
void get_service_info(char ***info_strings, int32_t *info_strings_size);
void get_service_params(char ***param_strings, int32_t *param_strings_size);
void get_service_resources(char ***resource_strings, int32_t *resource_strings_size);
int32_t get_number_of_input_images(void);
int32_t get_number_of_output_images(void);

#endif /* __SERVICE_PLUGIN_H__ */
/* common.h */

#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdio.h>

void malloc_copy_string_array(char ***target_array, char **source_array, int32_t array_size);
void free_string_array(char ***array, int32_t array_size);

#endif /* __COMMON_H__ */

int32_t run_service_grey_scpu(PixelPacket *pixpack_target, PixelPacket *pixpack_source, int32_t rows, int32_t columns);
int32_t run_service_grey_cpu(PixelPacket *pixpack_target, PixelPacket *pixpack_source, int32_t rows, int32_t columns);
int32_t run_service_grey_gpu(PixelPacket *pixpack_target, PixelPacket *pixpack_source, int32_t rows, int32_t columns);
int32_t run_service_grey_fpga(PixelPacket *pixpack_target, PixelPacket *pixpack_source, int32_t rows, int32_t columns);

// internal maxfile interface(s)
void run_service_grey_max(uint16_t *dataOut, uint16_t *dataIn, uint32_t picSize);

#endif /* __SERVICE_GREY_H__ */


int32_t run_service_grey_cpu(PixelPacket *pixpack_target, PixelPacket *pixpack_source, int32_t rows, int32_t columns) {
		//Tranform RGB to Grey Picture
		int32_t pos,i,j;
		#pragma omp parallel
		{
		#pragma omp for private(pos)
			for (i=0; i<rows; ++i) {
				for (j=0; j<columns; ++j) {
					pos = i*columns+j;
					pixpack_target[pos].red = (pixpack_source[pos].red+pixpack_source[pos].green+pixpack_source[pos].blue)/3;
					pixpack_target[pos].green = (pixpack_source[pos].red+pixpack_source[pos].green+pixpack_source[pos].blue)/3;
					pixpack_target[pos].blue = (pixpack_source[pos].red+pixpack_source[pos].green+pixpack_source[pos].blue)/3;
					pixpack_target[pos].opacity	= 0;
				}
			}
		}
	return 0;
}
