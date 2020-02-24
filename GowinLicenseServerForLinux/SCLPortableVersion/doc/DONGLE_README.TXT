FLEXid-9 Dongle Installation for FlexNet 11.14.1.3
================================================

To install the FLEXid dongle driver for Synopsys Common Licensing (SCL) 
version 2018.06 and higher, complete the following steps for the Windows 
or Linux system.

On Windows:
-----------

1. Install the dongle driver from the SCL install directory. 

   SCL installation contains a zip file called FLEXID9_Windows_v7_54_i686.zip. 
   The zip file contains the dongle installer executable, named haspdinst.exe. 
   This installer needs to be run from the command (cmd)shell. For example, 

      cd C:\Synopsys\SCL\2018.06\win32\drivers
      C:\Synopsys\SCL\2018.06\win32\drivers> haspdinst.exe -install

   The installation window appears and shows the progress of the installation.
   
   Note:
         Only running the haspdinst.exe program shows the help and other options.

2. Copy the haspsrm_<platform>.dll file from the "scl_root\win32\drivers" directory 
   to your "C:\Windows\System32" directory.

     - For Windows 32-bit OS installation, copy the haspsrm_win32.dll file.
	
     - For Windows 64-bit OS installation, 
     
       o Copy the haspsrm_win64.dll file to the "C:\windows\system32" directory.
       o Copy the haspsrm_win32.dll file to the "C:\windows\sysWOW64" directory. 
       
       This makes 32-bit dongle programs and utilities (such as snpslmd, 
       lmtools, lmutil, and so on.) compatible with the 64-bit OS platform.

   Note:
         For compatibility purposes, 64-bit Windows uses the "System32" directory.

3. For uncounted, or serverless, licenses that reference a FLEXid 9 dongle 
   it is also necessary to install the older dongle driver. (Both the newer 
   haspdinst.exe driver and the older FLEXIdInstaller.exe driver can be installed 
   on the same system).

   The legacy FLEXIdInstaller.exe installer can be found in the 
   "scl_root\win32\drivers\FLEXIdInstaller.exe" directory. This GUI installer 
   guides you through the driver installation. A machine reboot is required 
   after the installation is completed.

4. To verify that the dongle is working, type the following command.

        lmutil.exe lmhostid -flexid

   This should display the FlexNet dongle host ID.

On Linux:
---------

The dongle driver is named aksusbd-redhat-suse-7.54.tar.gz and is 
located in the "scl_root/<platform>/drivers" directory. For example, 
/usr/synopsys/scl/2018.06/linux/drivers/aksusbd-redhat-suse-7.54.tar.gz

The following steps apply to both 32-bit and 64-bit Linux installations.

1. Extract the files in the tar file with the following command.

        tar xvfz aksusbd-redhat-suse-7.54.tar.gz

   The extracted files contain an RPM package named "aksusbd-7.54-1.i386.rpm".

2. Install the driver using the rpm command. For example,

        rpm -iv aksusbd-7.54-1.i386.rpm

3. Copy the 32-bit libhasp_linux_i686.so or 64-bit libhasp_linux_x86_64.so 
   shared library file to the /usr/lib directory to complete the installation.  
   (For example, for the 32-bit linux platform, copy libhasp_linux_i686.so 
    from scl_root/linux/drivers to /usr/lib.)

4. Verify the FLEXid by running one of the commands after installing the dongle driver.

       lmutil lmhostid -flexid

       or

       lmhostid -flexid

