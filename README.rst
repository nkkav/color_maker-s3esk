=========================
 color_maker user manual
=========================

+-------------------+----------------------------------------------------------+
| **Title**         | color_maker-s3esk (simple VGA tester)                    |
+-------------------+----------------------------------------------------------+
| **Author**        | Nikolaos Kavvadias (C) 2014                              |
+-------------------+----------------------------------------------------------+
| **Contact**       | nikos@nkavvadias.com                                     |
+-------------------+----------------------------------------------------------+
| **Source**        | Mike Field (for the VGA controller; see AUTHORS)         |
+-------------------+----------------------------------------------------------+
| **Website**       | http://www.nkavvadias.com                                |
+-------------------+----------------------------------------------------------+
| **Release Date**  | 18 June 2014                                             |
+-------------------+----------------------------------------------------------+
| **Version**       | 1.0.1                                                    |
+-------------------+----------------------------------------------------------+
| **Rev. history**  |                                                          |
+-------------------+----------------------------------------------------------+
|        **v1.0.0** | 2014-06-09                                               |
|                   |                                                          |
|                   | Initial release for the Spartan-3E Starter kit board.    |
+-------------------+----------------------------------------------------------+
|        **v1.0.1** | 2014-06-18                                               |
|                   |                                                          |
|                   | Changed README to README.rst; COPYING to LICENSE.        |
+-------------------+----------------------------------------------------------+


1. Introduction
===============

``color_maker`` is a simple design for testing VGA output. This version of the 
``color_maker`` produces 3-bit RGB color (R1G1B1) as supported by the Xilinx 
Spartan-3E starter kit board. 3 out of the 4 available slide switches 
(specifically switches SW2, SW1, SW0) are used for setting a specific color 
out of the eight unique colors that are available.

The following table summarizes the available colors.

   =  =  =  ============
   R  G  B  Description
   =  =  =  ============
   0  0  0  Black (Noir)
   0  0  1  Blue
   0  1  0  Green
   0  1  1  Cyan
   1  0  0  Red
   1  0  1  Magenta
   1  1  0  Yellow
   1  1  1  White
   =  =  =  ============
   
For the standard VGA resolution (640x480@60Hz), a 25MHz clock is used, as 
produced by the ``clockdiv`` clock divider (divide by 2). The VGA controller 
is implemented by ``vgactrl.vhd``. The color selection logic is very 
simple and directly assigns SW2 to the R, SW1 to G and SW0 to the B component. 
For 800x600@72Hz, a 50 MHz clock should be used.

The ``vga_controller`` design has been adapted from the work by Mike Field: 
http://hamsterworks.co.nz/mediawiki/index.php/Hidef_snow
   
 
2. File listing
===============

The ``color_maker`` distribution includes the following files: 

+-----------------------+------------------------------------------------------+
| /color_maker-s3esk    | Top-level directory                                  |
+-----------------------+------------------------------------------------------+
| AUTHORS               | List of authors.                                     |
+-----------------------+------------------------------------------------------+
| LICENSE               | 3-clause modified BSD license.                       |
+-----------------------+------------------------------------------------------+
| README.rst            | This file.                                           |
+-----------------------+------------------------------------------------------+
| README.html           | HTML version of README.rst.                          |
+-----------------------+------------------------------------------------------+
| README.pdf            | PDF version of README.rst.                           |
+-----------------------+------------------------------------------------------+
| clockdiv.vhd          | Configurable, portable, clock divider.               |
+-----------------------+------------------------------------------------------+
| color_maker.vhd       | Color assignment logic.                              |
+-----------------------+------------------------------------------------------+
| color_maker_top.ucf   | User Constraints File for the XC3S500E-FG320-4       |
|                       | device.                                              |
+-----------------------+------------------------------------------------------+
| color_maker_top.vhd   | The top-level RTL VHDL design file.                  |
+-----------------------+------------------------------------------------------+
| color_maker_top-syn.sh| Bash shell script for synthesizing the               |
|                       | ``color_maker`` design with Xilinx ISE.              |
+-----------------------+------------------------------------------------------+
| impact_s3esk.bat      | Windows Batch file for automatically invoking Xilinx |
|                       | IMPACT in order to download the generated bitstream  |
|                       | to the target hardware.                              |
+-----------------------+------------------------------------------------------+
| rst2docs.sh           | Bash script for generating the HTML and PDF versions.|
+-----------------------+------------------------------------------------------+
| vgactrl.vhd           | RTL VHDL code for the VGA controller.                |
+-----------------------+------------------------------------------------------+
| xst.mk                | Standard Makefile for command-line usage of ISE.     |
+-----------------------+------------------------------------------------------+


3. Usage
========

The ``color_maker`` distribution includes scripts for logic synthesis automation 
supporting Xilinx ISE. The corresponding synthesis script can be edited in order
to specify the following for adapting to the user's setup:

- ``XDIR``: the path to the ``/bin`` subdirectory of the Xilinx ISE/XST 
  installation where the ``xst.exe`` executable is placed
- ``arch``: specific FPGA architecture (device family) to be used for synthesis
- ``part``: specific FPGA part (device) to be used for synthesis

3.1. Running the synthesis script
---------------------------------

For running the Xilinx ISE synthesis tool, generating FPGA configuration 
bistream and downloading to the target device, execute the corresponding script 
from within the ``color_maker-s3esk`` directory:

| ``$ ./color_maker_top-syn.sh``

In order to successfully run the entire process, you should have the target 
board connected to the host and it should be powered on.

The synthesis procedure invokes several Xilinx ISE command-line tools for logic 
synthesis as described in the corresponding Makefile, found in the 
the ``color_maker-s3esk`` directory.

Typically, this process includes the following:

- Generation of the ``*.xst`` synthesis script file.
- Generation of the ``*.ngc`` gate-level netlist file in NGC format.
- Building the corresponding ``*.ngd`` file.
- Performing mapping using ``map`` which generates the corresponding ``*.ncd`` 
  file.
- Place-and-routing using ``par`` which updates the corresponding ``*.ncd`` 
  file.
- Tracing critical paths using ``trce`` for reoptimizing the ``*.ncd`` file.
- Bitstream generation (``*.bit``) using ``bitgen``, however with unused pins.

As a result of this process, the ``color_maker_top.bit`` bitstream file is 
produced.

Then, the shell script invokes the Xilinx IMPACT tool by a Windows batch file, 
automatically passing a series of commands that are necessary for configuring 
the target FPGA device:

1. Set mode to binary scan.

| ``setMode -bs``

2. Set cable port detection to auto (tests various ports).

| ``setCable -p auto``

3. Identify parts and their order in the scan chain.

| ``identify``

4. Assign the bitstream to the first part in the scan chain.

| ``assignFile -p 1 -file color_maker_top.bit``

5. Program the selected device.

| ``program -p 1``

6. Exit IMPACT.

| ``exit``


4. Prerequisites
================

- [suggested] MinGW environment on Windows 7 (64-bit).

- Xilinx ISE (free ISE webpack is available from the Xilinx website): 
  http://www.xilinx.com.
  The 14.6 version on Windows 7/64-bit is known to work.
