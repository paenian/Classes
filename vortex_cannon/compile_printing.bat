#!/bin/sh

#this file compiles the vortex cannon parts.

#cupcutter
openscad -o stls/cupcutter.stl cupcutter.scad &

#cannon
openscad -o stls/printing_plate.stl -D part=10 cupnado.scad &
openscad -o stls/pull_loop.stl -D part=0 cupnado.scad &
openscad -o stls/pull_ring.stl -D part=1 cupnado.scad &
openscad -o stls/cup_base.stl -D part=2 cupnado.scad &
