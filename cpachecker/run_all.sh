#!/bin/bash

declare -a arr=(
		"service_blend"
		"service_canny"
		"service_contrast"
		"service_cutselection"
		"service_deform"
		"service_dim"
		"service_dim2"
		"service_fft"
		"service_gaussblur"
		"service_gausslowpass"
		"service_gausslowpass2"
		"service_grayhistoequal"
		"service_grey"
		"service_hitormiss"
		"service_maxrgb"
		"service_median"
		"service_morphedgedetection"
		"service_morphopen"
		"service_negative"
		"service_pixelate"
		"service_radialblur"
		"service_reflect"
		"service_resize"
		"service_rgbchannelmixer"
		"service_rotate"
		"service_scaling"
		"service_sobel"
		"service_whitebalance"
	)

for input in "${arr[@]}"
do
	echo "***** INPUT: " $input "*****"
	rm output/*
	./run_gen.sh default.spc ${1} basicServices/${input}/${input}_cpu.c
	cp output/arg.proof basicServices/${input}/${input}_cpu_${1}.proof
	./run_check.sh default.spc ${1} basicServices/${input}/${input}_cpu.c
done
